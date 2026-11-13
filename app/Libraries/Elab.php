<?php

namespace App\Libraries;

use App\Models\Collection;
use App\Models\Sample;
use App\Models\SampleType;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;

class Elab extends PpciLibrary
{

    function display()
    {
        $this->vue = service('Smarty');
        if (!empty($_POST["collection_id"])) {
            $this->vue->set($_POST["collection_id"], "collection_id");
            $this->vue->set($_POST["sample_type_id"], "sample_type_id");
        }
        $collection = new Collection;
        $this->vue->set($collection->getCollectionsFromLogin(), "collections");
        $this->vue->set("gestion/elab.tpl", "corps");
        $this->vue->help(_("gestion/importer-des-échantillons-créés-avec-elabftw.html"));
        return $this->vue->send();
    }

    function generateModel()
    {
        $metadata = [];
        $sampleTypeId = $_POST["sample_type_id"];
        if (!empty($sampleTypeId)) {
            $sampleType = new SampleType;
            $d = $sampleType->read($sampleTypeId);
            if (!empty($d["multiple_value"])) {
                $metadata["quantity"] = [
                    "type" => "number",
                    "unit" => $d["multiple_unit"],
                    "value" => "",
                    "description" => _("Quantité présente dans l'échantillon")
                ];
            }
            $metadata["parent_identifier"] = [
                "type" => "string",
                "value" => "",
                "description" => _("Identifiant métier de l'échantillon parent")
            ];
            $mdschema = json_decode($d["metadata_schema"], true);
            if (!empty($mdschema)) {

                foreach ($mdschema as $md) {
                    $field = [];
                    $field["value"] = $md["defaultValue"];
                    $field["description"] = $md["description"];
                    /**
                     * types
                     */
                    $field["type"] = $md["type"];
                    if ($md["type"] == "string" || $md["type"] == "textarea") {
                        $field["type"] = "text";
                    } elseif ($md["type"] == "array") {
                        $field["allow_multiple_values"] = true;
                    }
                    if ($md["multiple"] == "yes") {
                        $field["allow_multiple_values"] = true;
                    }
                    if (!empty($md["measureUnit"])) {
                        $field["unit"] = $md["measureUnit"];
                    }
                    if (!empty($md["choiceList"])) {
                        $field["options"] = $md["choiceList"];
                    }
                    $field["required"] = $md["required"];
                    $metadata["metadata"][$md["name"]] = $field;
                }
            }

            $model = json_encode($metadata, JSON_UNESCAPED_UNICODE);
            $this->vue = service('Smarty');
            $this->vue->set($model, "model");
        }
        return $this->display();
    }
    function import(string $file)
    {
        $sample = new Sample;
        $csv = new Csv;
        $sampleType = new SampleType;
        $sampleTypes = $sampleType->getListReverse();
        $db = $sample->db;
        $line = 2;
        $uidMin = 0;
        $uidMax = 0;
        try {
            /**
             * Verify the collection
             */
            if (!array_key_exists($_POST["collection_id"], $_SESSION["collections"])) {
                throw new PpciException(_("La collection de destination n'est pas autorisée"));
            }
            $db->transBegin();
            $csv->openfile($file);
            $content = $csv->getContentAsArray();
            $csv->fileClose();
            foreach ($content as $row) {
                $dsample = [];
                $dsample["identifier"] = $row["title"];
                $dsample["collection_id"] = $_POST["collection_id"];
                $dsample["object_status_id"] = 1;
                /**
                 * Search if sample exists
                 */
                $dsample["uid"] = $sample->getUid("identifier", $row["title"], $_POST["collection_id"]);
                $dsample["sampling_date"] = $sample->formatDateDBtoLocal($row["date"]);
                $dsample["sample_creation_date"] = $dsample["sampling_date"];
                $dsample["object_comment"] = $row["body"];
                if (!empty($row["category_title"])) {
                    $dsample["sample_type_id"] = $sampleTypes[$row["category_title"]];
                } else {
                    $dsample["sample_type_id"] = $_POST["sample_type_id"];
                }
                if (strlen($row["quantity"]) > 0) {
                    $dsample["multiple_value"] = $row["quantity"];
                }
                /**
                 * Treatment of metadata
                 */
                $meta = json_decode($row["metadata"], true);
                /**
                 * search from parent
                 */
                if (!empty($meta["parent_identifier"]["value"])) {
                    $parentId = $sample->getIdFromIdentifier($meta["parent_identifier"]["value"]);
                    if (empty($parentId)) {
                        throw new PpciException(sprintf(_("Ligne %s : le parent n'est pas connu dans la base de données"), $line));
                    } else {
                        $dsample["parent_sample_id"] = $parentId;
                    }
                }
                $dmetadata = [];
                foreach ($meta["metadata"] as $k => $v) {
                    if (strlen($v["value"]) > 0) {
                        if ($v["type"] == "select") {
                            $dmetadata[$k] = $v["options"][$v["value"] - 1];
                        } else {
                            $dmetadata[$k] = $v["value"];
                        }
                    }
                }
                $dsample["metadata"] = json_encode($dmetadata, JSON_UNESCAPED_UNICODE);
                $uid = $sample->write($dsample);
                if ($line == 2) {
                    $uidMin = $uid;
                }
                $uidMax = $uid;
                $line++;
            }
            $db->transCommit();
            $this->message->set(sprintf(_("%s échantillons créés"), $line - 2));
            $this->message->set(sprintf(_("UID compris entre %1s et %2s"), $uidMin, $uidMax));
            $this->log->setLog($_SESSION["login"], "elabFTWImport", "UID min: $uidMin, UID max: $uidMax");
            log_message("error", "elabFTWImport - UID min: $uidMin, UID max: $uidMax");
        } catch (PpciException $e) {
            $db->transRollback();
            $this->message->set($e->getMessage(), true);
        }
    }
}
