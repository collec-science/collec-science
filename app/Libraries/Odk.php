<?php

namespace App\Libraries;

use App\Models\Campaign;
use App\Models\Document;
use App\Models\Odk as ModelsOdk;
use App\Models\OdkChoice;
use App\Models\OdkLine;
use App\Models\OdkSampletype;
use App\Models\Sample;
use App\Models\SampleType;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Libraries\Views\FileView;
use Ppci\Models\PpciModel;

class Odk extends PpciLibrary
{
    /**
     * @var ModelsOdk
     */
    protected PpciModel $dataclass;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsOdk();
        $this->keyName = "odk_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getList(), "data");
        $this->vue->set("odk/odkList.tpl", "corps");
        $this->vue->help(_("odk/utiliser-odk-pour-importer-des-échantillons.html"));
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "odk/odkChange.tpl");
        $this->vue->set($_SESSION["collections"], "collections");
        $campaign = new Campaign;
        $this->vue->set($campaign->getList("campaign_name"), "campaigns");
        $this->vue->help(_("odk/générer-le-formulaire-odk.html"));
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        $this->vue->set("odk/odkDisplay.tpl", "corps");
        $this->vue->set($data = $this->dataclass->getDetail($_REQUEST["odk_id"]), "data");
        /**
         * Treatment of sampletypes
         */
        if (!isset($_REQUEST["odk_sampletype_id"])) {
            $_REQUEST["odk_sampletype_id"] = 0;
        }
        $odksampletype = new OdkSampletype;
        $this->vue->set($odksampletype->read($_REQUEST["odk_sampletype_id"], true, $this->id), "odksampletype");
        $this->vue->set($odksampletype->getListFromOdk($this->id), "odksampletypes");
        $this->vue->set($_REQUEST["odk_sampletype_id"], "sampletypeCurrent");
        $sampletype = new SampleType;
        $this->vue->set($sampletype->getListFromCollection($data["collection_id"]), "sampletypes");
        /**
         * tables nn
         */
        $this->vue->set($this->dataclass->getAllIdentifiers($this->id), "identifiers");
        $this->vue->set($this->dataclass->getAllStations($this->id, $data["collection_id"]), "stations");
        $this->vue->set($this->dataclass->getAllReferents($this->id), "referents");
        /**
         * tables used to create ods file
         */
        $odkline = new OdkLine;
        $this->vue->set($odkline->getListFromParent($this->id, "line_order"), "lines");
        $odkchoice = new OdkChoice;
        $this->vue->set($odkchoice->getListFromParent($this->id), "choices");
        /**
         * end
         */
        $this->vue->help(_("odk/générer-le-formulaire-odk.html"));
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return true;
            } else {
                return false;
            }
        } catch (PpciException) {
            return false;
        }
    }

    /**
     * Method writeComp
     * write tables nn
     */
    function writeComp()
    {
        try {
            $this->dataclass->writeComp($_POST["odk_id"], $_POST);
            return true;
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            return false;
        }
    }
    function delete()
    {
        /*
         * delete record
         */
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException $e) {
            return false;
        }
    }
    function calculate()
    {
        $odkGenerate = new OdkGenerate;
        $odkGenerate->calculate($this->id);
    }
    function createSpreadsheet()
    {
        $odkGenerate = new OdkGenerate;
        try {
            $realfilename = $odkGenerate->createSpreadsheet($this->id);
            $this->vue = new FileView;
            $dataOdk = $this->dataclass->read($this->id);
            $filename = $dataOdk["odk_name"] . ".xlsx";
            $this->vue->setParam(["tmp_name" => $realfilename, "filename" => $filename]);
            return $this->vue->send();
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            return false;
        }
    }

    function duplicate()
    {
        $db = $this->dataclass->db;
        try {
            if (!is_numeric($this->id) || $this->id == 0) {
                throw new PpciException(_("L'identifiant du formulaire n'a pas été fourni"));
            }
            /**
             * get data
             */
            $data = $this->dataclass->read($this->id);
            if (empty($data)) {
                throw new PpciException(_("Le formulaire n'existe pas"));
            }
            $odksampletype = new OdkSampletype;
            $odkline = new OdkLine;
            $odkchoice = new OdkChoice;
            /**
             * related tables 
             */
            $identifiers = $this->dataclass->getIdentifiers($this->id);
            $stations = $this->dataclass->getStations($this->id);
            $referents = $this->dataclass->getReferents($this->id);
            $sampletypes = $odksampletype->getListFromParent($this->id);
            $lines = $odkline->getListFromParent($this->id);
            $choices = $odkchoice->getListFromParent($this->id);
            /**
             * create new form
             */
            $data["odk_id"] = 0;
            $data["odk_author"] = $_SESSION["login"];
            /**
             * generate new version number
             */
            $version = explode(".", $data["odk_version"]);
            if (count($version) > 1) {
                $dec = array_last($version);
                if (is_numeric($dec)) {
                    $version[count($version) - 1] = $dec + 1;
                    $data["odk_version"] = implode(".", $version);
                } else {
                    $data["odk_version"] .= ".1";
                }
            } else {
                $data["odk_version"] .= ".1";
            }
            $id = $this->dataclass->write($data);
            /**
             * create items in tables n-n
             */
            $new = [];
            foreach ($identifiers as $row) {
                $new[] = $row["identifier_type_id"];
            }
            if (!empty($new)) {
                $this->dataclass->writeTableNN("odk_identifier", "odk_id", "identifier_type_id", $id, $new);
            }
            $new = [];
            foreach ($stations as $row) {
                $new[] = $row["sampling_place_id"];
            }
            if (!empty($new)) {
                $this->dataclass->writeTableNN("odk_station", "odk_id", "sampling_place_id", $id, $new);
            }
            $new = [];
            foreach ($referents as $row) {
                $new[] = $row["referent_id"];
            }
            if (!empty($new)) {
                $this->dataclass->writeTableNN("odk_referent", "odk_id", "referent_id", $id, $new);
            }
            /**
             * create item in others related tables
             */
            foreach ($sampletypes as $row) {
                $row["odk_sampletype_id"] = 0;
                $row["odk_id"] = $id;
                $odksampletype->write($row);
            }
            foreach ($lines as $row) {
                $row["odk_line_id"] = 0;
                $row["odk_id"] = $id;
                $odkline->write($row);
            }
            foreach ($choices as $row) {
                $row["odk_choice_id"] = 0;
                $row["odk_id"] = $id;
                $odkchoice->write($row);
            }
            $db->transCommit();
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            if ($db->transEnabled) {
                $db->transRollback();
            }
        }
    }
    function import()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getList(), "odks");
        $this->vue->set("odk/odkImport.tpl", "corps");
        $this->vue->help(_("odk/utiliser-odk-pour-importer-des-échantillons.html"));
        return $this->vue->send();
    }
    function importExec(int $odkId, string $folder, string $filename)
    {
        $db = $this->dataclass->db;
        try {

            $db->transBegin();
            /**
             * get the content of odk 
             */
            $odk = $this->dataclass->read($odkId);
            /**
             * verify rights
             */
            if (empty($_SESSION["collections"][$odk["collection_id"]])) {
                throw new PpciException(_("Vous ne disposez pas des droits suffisants pour importer dans cette collection"));
            }
            /**
             * counters
             */
            $nbCreate = 0;
            $nbChange = 0;
            $nbMedia = 0;
            $uidMin = 99999999;
            $uidMax = 0;
            /**
             * initialize classes
             */
            $sampleModel = new Sample;
            $document = new Document;
            /**
             * extract the root of the filename
             */
            $rootname = substr($filename, 0, strrpos($filename, "."));
            /**
             * Read the content of csv files
             */
            $csv = new Csv;
            $csvnames = [
                "stations" => $folder . "/" . $rootname . ".csv",
                "samples" => $folder . "/" . $rootname . "-samples.csv",
                "pictures" => $folder . "/" . $rootname . "-pictures.csv",
                "videos" => $folder . "/" . $rootname . "-videos.csv",
                "sounds" => $folder . "/" . $rootname . "-sounds.csv",
            ];
            $zipdata = [];
            foreach ($csvnames as $name => $content) {
                $csv->openfile($content);
                $zipdata[$name] = $csv->getContentAsArray();
            }
            /**
             * prepare structured data
             */
            $data = [];
            /**
             * stations
             */
            foreach ($zipdata["stations"] as $station) {
                $dstation = [
                    "sampling_date" => $station["sampling_date"],
                    "referent_id" => $station["referent_id"],
                    "sampling_place_id" => $station["sampling_place_id"],
                    "wgs84_x" => $station["geopoint-Longitude"],
                    "wgs84_y" => $station["geopoint-Latitude"]
                ];
                $data[$station["KEY"]] = $dstation;
            }
            /**
             * samples
             */
            $keyArr = ["PARENT_KEY", "KEY"];
            foreach ($zipdata["samples"] as $sample) {
                $dsample = [];
                foreach ($sample as $k => $v) {
                    if (!in_array($k, $keyArr)) {
                        $dsample[$k] = $v;
                    }
                }
                $data[$sample["PARENT_KEY"]]["samples"][$sample["KEY"]] = $dsample;
            }
            /**
             * pictures
             */
            foreach ($zipdata["pictures"] as $media) {
                if (!empty($media["picture"])) {
                    /**
                     * extract station key
                     */
                    $stationKey = explode("/", $media["PARENT_KEY"])[0];
                    $data[$stationKey]["samples"][$media["PARENT_KEY"]]["medias"][] = $media["picture"];
                }
            }
            /**
             * videos
             */
            foreach ($zipdata["videos"] as $media) {
                if (!empty($media["video"])) {
                    /**
                     * extract station key
                     */
                    $stationKey = explode("/", $media["PARENT_KEY"])[0];
                    $data[$stationKey]["samples"][$media["PARENT_KEY"]]["medias"][] = $media["video"];
                }
            }
            /**
             * sounds
             */
            foreach ($zipdata["sounds"] as $media) {
                if (!empty($media["sound"])) {
                    /**
                     * extract station key
                     */
                    $stationKey = explode("/", $media["PARENT_KEY"])[0];
                    $data[$stationKey]["samples"][$media["PARENT_KEY"]]["medias"][] = $media["sound"];
                }
            }
            /**
             * Treatment of each sample
             */
            $sampleKeyExclude = ["PARENT_KEY", "KEY", "medias"];
            foreach ($data as $station) {
                $object = [
                    "uid" => 0,
                    "collection_id" => $odk["collection_id"],
                    "sampling_date" => $station["sampling_date"],
                    "wgs84_x" => $station["wgs84_x"],
                    "wgs84_y" => $station["wgs84_y"],
                    "referent_id" => $station["referent_id"],
                    "sampling_place_id" => $station["sampling_place_id"],
                    "sample_creation_date" => date($_SESSION["date"]["maskdatelong"]),
                    "object_status_id" => 1
                ];
                $parentId = 0;
                foreach ($station["samples"] as $sample) {
                    $identifier = $sample["root-identifier"] . $sample["identifier"];
                    $dsample = $object;
                    /**
                     * Search if exists the sample
                     */
                    $uid = $sampleModel->getUid("identifier", $identifier, $odk["collection_id"]);
                    if ($uid > 0) {
                        $isNew = false;
                        $dsample = $sampleModel->read($uid);
                        if ($dsample["collection_id"] != $odk["collection_id"]) {
                            throw new PpciException(_("La collection de l'échantillon à mettre à jour n'est pas la même que celle déclarée dans le modèle ODK"));
                        }
                    } else {
                        $isNew = true;
                    }
                    /**
                     * add values
                     */
                    $metadata = [];
                    foreach ($sample as $k => $v) {
                        if (!in_array($k, $sampleKeyExclude)) {
                            /**
                             * Treatment of metadata
                             */
                            if (substr($k, 0, 3) == "md_" && strlen($v) > 0) {
                                $metadata[substr($k, 3)] = $v;
                            } else {
                                $dsample[$k] = $v;
                            }
                        }
                        $dsample["metadata"] = json_encode($metadata);
                    }
                    /**
                     * Treatment of the parent
                     */
                    if ($sample["is_subsampling"] == 1 && $parentId > 0) {
                        /**
                         * add reference to the parent
                         */
                        $dsample["parent_sample_id"] = $parentId;
                    }
                    /**
                     * write sample
                     */
                    $dsample["identifier"] = $identifier;
                    $uid = $sampleModel->write($dsample);
                    if ($uid > $uidMax) {
                        $uidMax = $uid;
                    }
                    if ($uid < $uidMin) {
                        $uidMin = $uid;
                    }
                    if ($sample["is_subsampling"] == 0) {
                        $parentId = $sampleModel->getIdFromUid($uid);
                    }
                    /**
                     * Treatment of medias
                     */
                    if ($isNew) {
                        $nbCreate++;
                        foreach ($sample["medias"] as $mediaName) {
                            /**
                             * prepare file array
                             */
                            $filepath = $folder . "/media/" . $mediaName;
                            $filestat = stat($filepath);
                            $fileInfo = [
                                "name" => $mediaName,
                                "size" => $filestat["size"],
                                "tmp_name" => $filepath
                            ];
                            $document->documentWrite($fileInfo, "uid", $uid);
                            $nbMedia++;
                        }
                    } else {
                        $nbChange++;
                    }
                }
            }
            $this->message->set(_("Import effectué"));
            $this->message->set(sprintf(_("Nombre d'échantillons créés : %s"), $nbCreate));
            $this->message->set(sprintf(_("Nombre d'échantillons modifiés : %s"), $nbChange));
            $this->message->set(sprintf(_("Nombre de documents rajoutés : %s"), $nbMedia));
            $this->message->set(sprintf(_("UID traités entre %1s et %2s"), $uidMin, $uidMax));
            $this->message->setSyslog(sprintf(_("Import ODK : UID traités entre %1s et %2s"), $uidMin, $uidMax));
            $db->transCommit();
        } catch (PpciException $e) {
            $db->transRollback();
            throw new PpciException($e->getMessage());
        } finally {
            /**
             * delete the folder
             */
            $this->recurseRmdir($folder);
        }
    }

    // Source - https://stackoverflow.com/a/18838141
    // Posted by Liko, modified by community. See post 'Timeline' for change history
    // Retrieved 2026-10-08, License - CC BY-SA 4.0

    function recurseRmdir(string $dir)
    {
        $files = array_diff(scandir($dir), array('.', '..'));
        foreach ($files as $file) {
            (is_dir("$dir/$file") && !is_link("$dir/$file")) ? $this->recurseRmdir("$dir/$file") : unlink("$dir/$file");
        }
        return rmdir($dir);
    }
}
