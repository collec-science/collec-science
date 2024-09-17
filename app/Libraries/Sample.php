<?php

namespace App\Libraries;

use App\Models\Booking;
use App\Models\Borrower;
use App\Models\Borrowing;
use App\Models\Campaign;
use App\Models\Collection;
use App\Models\Container;
use App\Models\ContainerFamily;
use App\Models\Country;
use App\Models\Document;
use App\Models\Event;
use App\Models\EventType;
use App\Models\ExportModel;
use App\Models\Import;
use App\Models\Label;
use App\Models\Metadata;
use App\Models\MimeType;
use App\Models\Movement;
use App\Models\MovementReason;
use App\Models\ObjectClass;
use App\Models\ObjectIdentifier;
use App\Models\ObjectStatus;
use App\Models\Printer;
use App\Models\Referent;
use App\Models\Sample as ModelsSample;
use App\Models\SampleInitClass;
use App\Models\Samplesearch;
use App\Models\SampleType;
use App\Models\SamplingPlace;
use App\Models\Subsample;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Sample extends PpciLibrary
{
    /**
     * @var ModelsSample
     */
    protected PpciModel $dataclass;

    private $keyName;
    private $isDelete = false;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsSample();
        $this->keyName = "uid";
        if (isset($_REQUEST["uid"]) && strlen($_REQUEST["uid"]) > 0) {
            $this->id = $_REQUEST["uid"];
        }
        $_SESSION["moduleParent"] = "sample";
    }

    function list()
    {
        $this->vue = service('Smarty');
        $_SESSION["moduleListe"] = "sampleList";
        /**
         * Display the list of all records of the table
         */
        if (!$this->isDelete && !isset($_REQUEST["is_action"])) {
            $_SESSION["searchSample"]->setParam($_REQUEST);
        }
        $this->vue->set("sampleList", "moduleFrom");
        /**
         * Get the content of a recorded request
         */
        $samplesearch = new Samplesearch();
        $samplesearch_id = $_REQUEST["samplesearch_id"];
        if ($samplesearch_id > 0) {
            $dsamplesearch = $samplesearch->lire($samplesearch_id);
            $_SESSION["searchSample"]->setParamFromJson($dsamplesearch["samplesearch_data"]);
        }
        $dataSearch = $_SESSION["searchSample"]->getParam();
        /**
         * Storage of the request
         */
        if (!empty($_REQUEST["samplesearch_name"])) {
            $dsamplesearch = array(
                "samplesearch_id" => 0,
                "samplesearch_name" => $_REQUEST["samplesearch_name"],
                "samplesearch_data" => json_encode($dataSearch),
                "samplesearch_login" => $_SESSION["login"]
            );
            if ($_REQUEST["samplesearch_collection"] == 1) {
                $dsamplesearch["collection_id"] = $_REQUEST["collection_id"];
            }
            $samplesearch_id = $samplesearch->ecrire($dsamplesearch, $dsamplesearch["collection_id"]);
        }
        /**
         * Delete a request
         */
        if ($_REQUEST["samplesearchDelete"] == 1 && $samplesearch_id > 0) {
            $samplesearch->delete($_REQUEST["samplesearch_id"]);
            $samplesearch_id = 0;
        }
        $this->vue->set($samplesearch_id, "samplesearch_id");
        /**
         * Get the list of recorded researches
         */
        $this->vue->set($samplesearch->getListFromCollections($_SESSION["collections"]), "samplesearches");
        /**
         * Search samples
         */
        if ($_SESSION["searchSample"]->isSearch() == 1) {
            try {
                $this->dataclass->resetParam();
                $data = $this->dataclass->sampleSearch($dataSearch);
                $this->vue->set($this->dataclass->getNbSamples($dataSearch), "totalNumber");
                $this->vue->set($data, "samples");
                $this->vue->set(1, "isSearch");
            } catch (PpciException $e) {
                $this->message->set(_("Un problème est survenu lors de l'exécution de la requête. Contactez votre administrateur pour obtenir un diagnostic"));
                $this->message->setSyslog($e->getMessage());
            }
        }
        $this->vue->set($dataSearch, "sampleSearch");
        $this->vue->set("gestion/sampleList.tpl", "corps");
        $this->vue->set($_SESSION["consultSeesAll"], "consultSeesAll");
        /**
         * Ajout des listes deroulantes
         */
        $this->setRelatedTablesToView($this->vue);
        /**
         * Ajout de la selection des modeles d'etiquettes
         */
        if (isset($_REQUEST["label_id"])) {
            $this->vue->set($_REQUEST["label_id"], "label_id");
        }
        $label = new Label;
        $this->vue->set($label->getListe(2), "labels");

        $printer = new Printer;
        $this->vue->set($printer->getListe(2), "printers");
        if (isset($_REQUEST["printer_id"])) {
            $this->vue->set($_REQUEST["printer_id"], "printer_id");
        }
        /**
         * Map default data
         */
        foreach (array("mapDefaultX", "mapDefaultY", "mapDefaultZoom") as $field) {
            $this->vue->set($_SESSION["dbparams"][$field], $field);
        }
        /**
         * Generate data for markers on the map
         */
        $dataMap["markers"] = array();
        foreach ($data as $row) {
            if (!empty($row["wgs84_x"]) && !empty($row["wgs84_y"])) {
                $dataMap["markers"][] = array("latlng" => array($row["wgs84_y"], $row["wgs84_x"]), "uid" => $row["uid"], "identifier" => $row["identifier"]);
            }
        }
        $this->vue->set(json_encode($dataMap), "markers");
        $this->vue->htmlVars[] = "markers";
        /**
         * Add multiple documents
         */
        $document = new Document();
        $this->vue->set($document->getMaxUploadSize(), "maxUploadSize");
        $this->vue->set($_SESSION["collections"][$dataSearch["collection_id"]]["external_storage_enabled"], "externalStorageEnabled");
        /**
         * Get the list of authorized extensions
         */
        $mimeType = new MimeType();
        $this->vue->set($mimeType->getListExtensions(false), "extensions");
        return $this->vue->send();
    }
    function searchAjax()
    {
        $this->vue = service('AjaxView');
        $this->vue->set($this->dataclass->sampleSearch($_REQUEST));
        return $this->vue->send();
    }
    function getFromId()
    {
        $this->vue = service('AjaxView');
        $this->vue->set($this->dataclass->readFromId($_REQUEST["sample_id"]));
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        $this->vue->set("sampleDisplay", "moduleFrom");
        /**
         * Display the detail of the record
         */
        $data = $this->dataclass->lire($this->id);
        $this->vue->set($data, "data");
        /*
         * Récupération des métadonnées dans un tableau pour l'affichage
         */
        $metadata = json_decode($data["metadata"], true);
        $is_modifiable = $this->dataclass->verifyCollection($data);
        if (!empty($metadata) && ($is_modifiable || $_SESSION["consultSeesAll"] == 1)) {
            $this->vue->set($metadata, "metadata");
        }
        /**
         * Recuperation des identifiants associes
         */
        $oi = new ObjectIdentifier();
        $this->vue->set($oi->getListFromUid($data["uid"]), "objectIdentifiers");
        /**
         * Recuperation des contenants parents
         */
        $container = new Container();
        $this->vue->set($container->getAllParents($data["uid"]), "parents");
        /**
         * Recuperation des evenements
         */
        $event = new Event();
        $this->vue->set($event->getListeFromUid($data["uid"]), "events");
        $eventType = new EventType();
        $this->vue->set($eventType->getListeFromCategory("sample", $data["collection_id"]), "eventType");
        /**
         * Recuperation des mouvements
         */
        $movement = new Movement();
        $this->vue->set($movement->getAllMovements($this->id), "movements");
        /**
         * Recuperation des echantillons associes
         */
        $this->vue->set($this->dataclass->getSampleassociated($data["uid"]), "samples");
        /**
         * Recuperation des reservations
         */
        $booking = new Booking();
        $this->vue->set($booking->getListFromParent($data["uid"], 'date_from desc'), "bookings");
        /**
         * Recuperation des sous-echantillonnages
         */
        $subSample = new Subsample();
        if ($data["multiple_type_id"] > 0) { 
            $this->vue->set($subSample->getListFromSample($data["sample_id"]), "subsample");
        }
        /**
         * For composite samples, get the parents
         */
        $this->vue->set($subSample->getParents($data["sample_id"]), "sampleparents");
        /**
         * Get the list of borrowings
         */
        $borrowing = new Borrowing();
        $this->vue->set($borrowing->getFromUid($data["uid"]), "borrowings");
        /**
         * Verification que l'echantillon peut etre modifie
         */
        if ($is_modifiable) {
            $this->vue->set(1, "modifiable");
        }
        $this->vue->set($_SESSION["dbparams"]["APPLI_code"], "APPLI_code");
        /**
         *
         * Recuperation des documents
         */
        if ($is_modifiable || $_SESSION["consultSeesAll"] == 1) {
            $document = new Document();
            $this->vue->set($document->getListFromField("uid", $data["uid"]), "dataDoc");
            $this->vue->set($document->getMaxUploadSize(), "maxUploadSize");
            $this->vue->set($_SESSION["collections"][$data["collection_id"]]["external_storage_enabled"], "externalStorageEnabled");
            /**
             * Get the list of authorized extensions
             */
            $mimeType = new MimeType();
            $this->vue->set($mimeType->getListExtensions(false), "extensions");
        }

        /**
         * Ajout des listes complémentaires
         */
        $this->setRelatedTablesToView($this->vue);
        /**
         * Affichage
         */
        $this->vue->set($_SESSION["consultSeesAll"], "consultSeesAll");
        /**
         * Map default data
         */
        foreach (array("mapDefaultX", "mapDefaultY", "mapDefaultZoom") as $field) {
            $this->vue->set($_SESSION["dbparams"][$field], $field);
        }
        $this->vue->set("sample", "moduleParent");
        $this->vue->set("gestion/sampleDisplay.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        /**
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $data = $this->dataRead($this->id, "gestion/sampleChange.tpl");
        if ($data["sample_id"] > 0 && !$this->dataclass->verifyCollection($data)) {
            $this->message->set(_("Vous ne disposez pas des droits nécessaires pour modifier cet échantillon"), true);
            return $this->display();
        } else {
            /**
             * Recuperation des informations concernant l'echantillon parent
             */
            if ($data["parent_sample_id"] > 0) {
                $dataParent = $this->dataclass->readFromId($data["parent_sample_id"]);
            } else {
                if ($_REQUEST["parent_uid"] > 0) {
                    $dataParent = $this->dataclass->lire($_REQUEST["parent_uid"]);
                }
            }

            if ($dataParent["sample_id"] > 0) {
                $this->vue->set($dataParent, "parent_sample");
                if ($dataParent["sample_id"] > 0) {
                    if ($data["sample_id"] == 0) {
                        $data["parent_sample_id"] = $dataParent["sample_id"];
                        /**
                         * Pre-positionnement des informations de base
                         */
                        $data["collection_id"] = $dataParent["collection_id"];
                        $data["wgs84_x"] = $dataParent["wgs84_x"];
                        $data["wgs84_y"] = $dataParent["wgs84_y"];
                        $data["location_accuracy"] = $dataParent["location_accuracy"];
                        $data["metadata"] = $dataParent["metadata"];
                        $data["sampling_place_id"] = $dataParent["sampling_place_id"];
                        $data["referent_id"] = $dataParent["referent_id"];
                        $data["identifier"] = $dataParent["identifier"];
                        $data["campaign_id"] = $dataParent["campaign_id"];
                        $data["country_id"] = $dataParent["country_id"];
                        $data["country_origin_id"] = $dataParent["country_origin_id"];
                        $data["uuid"] = $this->dataclass->getUUID();
                    }
                    $this->vue->set($data, "data");
                }
            } else {

                if ($data["sample_id"] == 0 && ($_SESSION["last_sample_id"] > 0 || $_REQUEST["last_sample_id"] > 0)) {
                    $_REQUEST["last_sample_id"] > 0 ? $lid = $_REQUEST["last_sample_id"] : $lid = $_SESSION["last_sample_id"];
                    /**
                     * Recuperation des dernieres donnees saisies
                     */
                    $dl = $this->dataclass->lire($lid);
                    $data["wgs84_x"] = $dl["wgs84_x"];
                    $data["wgs84_y"] = $dl["wgs84_y"];
                    $data["location_accuracy"] = $dl["location_accuracy"];
                    $data["collection_id"] = $dl["collection_id"];
                    $data["sample_type_id"] = $dl["sample_type_id"];
                    $data["sampling_date"] = $dl["sampling_date"];
                    $data["sampling_place_id"] = $dl["sampling_place_id"];
                    $data["metadata"] = $dl["metadata"];
                    $data["multiple_value"] = $dl["multiple_value"];
                    $data["expiration_date"] = $dl["expiration_date"];
                    $data["referent_id"] = $dl["referent_id"];
                    $data["campaign_id"] = $dl["campaign_id"];
                    $data["country_id"] = $dl["country_id"];
                    $data["country_origin_id"] = $dl["country_origin_id"];
                    if (empty($data["country_id"])) {
                        $data["country_id"] = $_SESSION["countryDefaultId"];
                    }
                    if ($_REQUEST["is_duplicate"] == 1) {
                        $data["parent_sample_id"] = $dl["parent_sample_id"];
                        $data["sample_type_id"] = $dl["sample_type_id"];
                        $data["identifier"] = $dl["identifier"];
                        $data["uuid"] = $this->dataclass->getUUID();
                        if ($data["parent_sample_id"] > 0) {
                            $dataParent = $this->dataclass->readFromId($data["parent_sample_id"]);
                            $this->vue->set($dataParent, "parent_sample");
                        }
                    }
                    $this->vue->set($data, "data");
                }
            }
            $this->setRelatedTablesToView($this->vue);
            $this->vue->set(1, "mapIsChange");
            MapInit::setDefault($this->vue);
            return $this->vue->send();
        }
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                /**
                 * Stockage en session du dernier echantillon modifie,
                 * pour recuperation des informations rattachees pour duplication ou autre
                 */
                $_SESSION["last_sample_id"] = $this->id;
                return $this->display();
            } else {
                return $this->change();
            }
        } catch (PpciException) {
            return $this->change();
        }
    }
    function delete()
    {
        /*
     * delete record
     */
        try {
            $this->dataDelete($_REQUEST["uid"]);
            $this->isDelete = true;
            return $this->list();
        } catch (PpciException $e) {
            return $this->change();
        }
    }
    function deleteMulti()
    {
        /**
         * Delete all records in uid array
         */
        if (count($_POST["uids"]) > 0) {
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $db = $this->dataclass->db;
            $db->transBegin();
            try {
                foreach ($uids as $uid) {
                    $this->dataDelete($uid, true);
                }
                $db->transCommit();
                $this->message->set(_("Suppression effectuée"));
            } catch (PpciException $e) {
                $this->message->set(_("La suppression des échantillons a échoué"), true);
                $this->message->set($e->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            }
        } else {
            $this->message->set(_("Pas d'échantillons sélectionnés"), true);
        }
    }
    function referentAssignMulti()
    {
        /**
         * change all referents for records in uid array
         */
        if (count($_POST["uids"]) > 0) {
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $object = new ObjectClass();
            $db = $this->dataclass->db;
            $db->transBegin();
            try {
                foreach ($uids as $uid) {
                    $this->dataclass->setReferent($uid, $object, $_REQUEST["referent_id"]);
                }
                $db->transCommit();
                $this->message->set(_("Affectation effectuée"));
                /**
                 * Forçage du retour
                 */
                $t_module["retourok"] = $_POST["lastModule"];
            } catch (PpciException | \Exception $oe) {
                $this->message->set(_("Erreur d'écriture dans la base de données"), true);
                if ($db->transEnabled) {
                    $db->transRollback();
                }
                $t_module["retourko"] = $_POST["lastModule"];
            }
        } else {
            $this->message->set(_("Aucun échantillon n'a été sélectionné"), true);
        }
    }
    function eventAssignMulti()
    {
        /**
         * Create an event for all selected samples
         */
        if (count($_POST["uids"]) > 0) {
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $event = new Event();
            $de = $event->getDefaultValues();
            $de["event_date"] = $_POST["event_date"];
            $de["due_date"] = $_POST["due_date"];
            $de["event_type_id"] = $_POST["event_type_id"];
            $de["event_comment"] = $_POST["event_comment"];
            $db = $this->dataclass->db;
            $db->transBegin();
            try {
                foreach ($uids as $uid) {
                    $de["uid"] = $uid;
                    $event->ecrire($de);
                }
                $db->transCommit();
                $this->message->set(_("Création des événements effectuée"));
                /**
                 * Forçage du retour
                 */
                $t_module["retourok"] = $_POST["lastModule"];
            } catch (PpciException $oe) {
                $this->message->set(_("Erreur d'écriture dans la base de données"), true);
                if ($db->transEnabled) {
                    $db->transRollback();
                }
                $t_module["retourko"] = $_REQUEST["lastModule"];
            } catch (\Exception $e) {
                $this->message->set(
                    _("La création des événements a échoué"),
                    true
                );
                $this->message->set($e->getMessage());
                $t_module["retourko"] = $_REQUEST["lastModule"];
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            }
        }
    }
    function lendingMulti()
    {
        /**
         * Lend the samples to a borrower
         */
        if (count($_POST["uids"]) > 0 && $_POST["borrower_id"] > 0) {
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $borrowing = new Borrowing();
            $movement = new Movement();
            try {
                $db = $this->dataclass->db;
                $db->transBegin();
                $datejour = date($_SESSION["date"]["maskdate"]);
                foreach ($uids as $uid) {
                    $borrowing->setBorrowing(
                        $uid,
                        $_POST["borrower_id"],
                        $_POST["borrowing_date"],
                        $_POST["expected_return_date"]
                    );
                    /**
                     * Generate an exit movement
                     */
                    $movement->addMovement($uid, null, 2, 0, $_SESSION["login"], null, _("Objet prêté"));
                }
                $db->transCommit();
                $this->message->set(_("Opération de prêt enregistrée"));
            } catch (PpciException $me) {
                $this->message->set(_("Erreur lors de la génération du mouvement de sortie"), true);
                $this->message->set($me->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            } catch (\Exception $e) {
                $this->message->set(_("Un problème est survenu lors de l'enregistrement du prêt"), true);
                $this->message->set($e->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            }
        } else {
            $this->message->set(_("Aucun échantillon n'a été sélectionné, ou l'emprunteur n'a pas été renseigné"), true);
        }
    }
    function exitMulti()
    {
        if (count($_POST["uids"]) > 0) {
            $movement = new Movement();
            try {
                $db = $this->dataclass->db;
                $db->transBegin();
                foreach ($_POST["uids"] as $uid) {
                    $movement->addMovement($uid, null, 2, 0, $_SESSION["login"], null, null);
                }
                $db->transCommit();
            } catch (PpciException $me) {
                $this->message->set(_("Erreur lors de la génération du mouvement de sortie"), true);
                $this->message->set($me->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            } catch (\Exception $e) {
                $this->message->set(_("Un problème est survenu lors de la génération des mouvements"), true);
                $this->message->set($e->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            }
        } else {
            $this->message->set(_("Aucun échantillon n'a été sélectionné"), true);
        }
    }
    function entryMulti()
    {
        if (count($_POST["uids"]) > 0 && $_POST["container_uid"] > 0) {
            $movement = new Movement();
            try {
                $db = $this->dataclass->db;
                $db->transBegin();
                foreach ($_POST["uids"] as $uid) {
                    if ($_POST["container_uid"] == $uid) {
                        throw new PpciException(sprintf(_("L'objet %s ne peut être stocké dans lui-même", $uid)));
                    }
                    $movement->addMovement($uid, null, 1, $_POST["container_uid"], $_SESSION["login"], $_POST["storage_location"], null, null, $_POST["column_number"], $_POST["line_number"]);
                }
                $db->transCommit();
            } catch (PpciException $me) {
                $this->message->set(_("Erreur lors de la génération du mouvement d'entrée"), true);
                $this->message->set($me->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            } catch (\Exception $e) {
                $this->message->set(_("Un problème est survenu lors de la génération des mouvements"), true);
                $this->message->set($e->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            }
        } else {
            $this->message->set(_("Aucun échantillon n'a été sélectionné"), true);
        }
    }
    function export()
    {
        $this->vue = service("CsvView");
        try {
            $this->vue->set(
                $this->dataclass->getForExport(
                    $this->dataclass->generateArrayUidToString($_REQUEST["uids"])
                )
            );
            $this->vue->regenerateHeader();
            return $this->vue->send();
        } catch (PpciException $e) {
            unset($this->vue);
            $this->vue = service("Smarty");
            $this->message->set($e->getMessage(), true);
        }
    }
    function importStage1()
    {
        $this->vue = service("Smarty");
        $this->vue->set("gestion/sampleImport.tpl", "corps");
        $this->vue->set(";", "separator");
        $this->vue->set(0, "utf8_encode");
        return $this->vue->send();
    }
    function importStage2()
    {
        $this->vue = service("Smarty");
        unset($_SESSION["filename"]);
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            try {
                /**
                 * Verify the encoding
                 */
                $encodings = array("UTF-8", "iso-8859-1", "iso-8859-15");
                $currentEncoding = mb_detect_encoding(file_get_contents($_FILES['upfile']['tmp_name']), $encodings, true);
                if ($currentEncoding != "UTF-8" && $_REQUEST["utf8_encode"] == 0 || $currentEncoding == "UTF-8" && $_REQUEST["utf8_encode"] == 1) {
                    throw new PpciException(_("L'encodage du fichier ne correspond pas à celui que vous avez indiqué"));
                }
                /**
                 * Deplacement du fichier dans le dossier temporaire
                 */
                $filename =  $this->appConfig->APP_temp . '/' . bin2hex(openssl_random_pseudo_bytes(4));
                $_SESSION["realfilename"] = $filename;
                if (copy($_FILES['upfile']['tmp_name'], $filename)) {
                    try {
                        $fields = array(
                            "dbuid_origin",
                            "identifier",
                            "sample_type_name",
                            "collection_name",
                            "object_status_name",
                            "wgs84_x",
                            "wgs84_y",
                            "sample_creation_date",
                            "sampling_date",
                            "expiration_date",
                            "multiple_value",
                            "sampling_place_name",
                            "metadata",
                            "identifiers",
                            "dbuid_parent",
                            "referent_name",
                            "location_accuracy",
                            "campaign_name",
                            "uuid",
                            "country_code",
                            "country_origin_code",
                            "comment"
                        );
                        $import = new Import($filename, $_REQUEST["separator"], $_REQUEST["utf8_encode"], $fields);
                        $data = $import->getContentAsArray();
                        $import->fileClose();

                        /**
                         * Verification si l'import peut etre realise
                         */
                        $line = 1;
                        foreach ($data as $row) {
                            if (count($row) > 0) {
                                try {
                                    $this->dataclass->verifyBeforeImport($row);
                                } catch (PpciException $e) {
                                    $this->message->set(sprintf(_('Ligne %1$s : %2$s'), $line, $e->getMessage()), true);
                                    $module_coderetour = -1;
                                }
                                $line++;
                            }
                        }
                        if ($module_coderetour == -1) {
                            /*
                             * Suppression du fichier temporaire
                             */
                            unset($filename);
                            unset($_SESSION["realfilename"]);
                        } else {

                            /*
                             * Extraction de tous les libelles des tables de reference
                             */
                            $this->vue->set($this->dataclass->getAllNamesFromReference($data), "names");
                            /*
                             * Recuperation de tous les libelles connus dans la base de donnees
                             */
                            $sic = new SampleInitClass();
                            $this->vue->set($sic->init(), "dataClass");
                            $this->vue->set($filename, "realfilename");
                            $this->vue->set($_REQUEST["separator"], "separator");
                            $this->vue->set($_REQUEST["utf8_encode"], "utf8_encode");
                            $this->vue->set(2, "stage");
                            $this->vue->set($_FILES['upfile']['name'], "filename");
                            $this->vue->set("gestion/sampleImport.tpl", "corps");
                        }
                    } catch (PpciException $e) {
                        $this->message->set($e->getMessage(), true);
                    }
                } else {
                    $this->message->set(_("Impossible de recopier le fichier importé dans le dossier temporaire"), true);
                }
            } catch (\Exception $e) {
                $this->message->set($e->getMessage(), true);
            }
        }
        return $this->importStage1();
    }

    function setCountry()
    {
        try {
            if (count($_POST["uids"]) == 0) {
                throw new PpciException(_("Pas d'échantillons sélectionnés"));
            }
            if (empty($_POST["country_id"])) {
                throw new PpciException(_("Pas de pays sélectionné"));
            }
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $this->dataclass->setCountry($_POST["uids"], $_POST["country_id"]);
            $this->message->set(_("Opération effectuée"));
        } catch (PpciException $oe) {
            $this->message->setSyslog($oe->getMessage());
            $this->message->set(_("Une erreur est survenue pendant la mise à jour du pays"), true);
            $this->message->set($oe->getMessage());
        }
    }
    function setCollection()
    {
        try {
            if (count($_POST["uids"]) == 0) {
                throw new PpciException(_("Pas d'échantillons sélectionnés"));
            }
            if (empty($_POST["collection_id_change"])) {
                throw new PpciException(_("Pas de collection sélectionnée"));
            }
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $this->dataclass->setCollection($_POST["uids"], $_POST["collection_id_change"]);
            $this->message->set(_("Opération effectuée"));
        } catch (PpciException $oe) {
            $this->message->setSyslog($oe->getMessage());
            $this->message->set(_("Une erreur est survenue pendant la mise à jour de la collection"), true);
            $this->message->set($oe->getMessage());
        }
    }
    function setCampaign()
    {
        try {
            if (count($_POST["uids"]) == 0) {
                throw new PpciException(_("Pas d'échantillons sélectionnés"));
            }
            if (empty($_POST["campaign_id"])) {
                throw new PpciException(_("Pas de campagne sélectionnée"));
            }
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);

            $this->dataclass->setCampaign($_POST["uids"], $_POST["campaign_id"]);
            $this->message->set(_("Opération effectuée"));
        } catch (PpciException $oe) {
            $this->message->setSyslog($oe->getMessage());
            $this->message->set(_("Une erreur est survenue pendant la mise à jour de la campagne"), true);
            $this->message->set($oe->getMessage());
        }
    }
    function setStatus()
    {
        try {
            if (count($_POST["uids"]) == 0) {
                throw new PpciException(_("Pas d'échantillons sélectionnés"));
            }
            if (empty($_POST["object_status_id"])) {
                throw new PpciException(_("Pas de statut sélectionné"));
            }
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $object = new ObjectClass();
            $object->setStatus($uids, $_POST["object_status_id"]);
            $this->message->set(_("Opération effectuée"));
        } catch (PpciException $oe) {
            $this->message->setSyslog($oe->getMessage());
            $this->message->set(_("Une erreur est survenue pendant la mise à jour du statut"), true);
            $this->message->set($oe->getMessage());
        }
    }
    function setParent()
    {
        try {
            if (count($_POST["uids"]) == 0) {
                throw new PpciException(_("Pas d'échantillons sélectionnés"));
            }
            if (empty($_POST["parent_sample_id"])) {
                throw new PpciException(_("Pas de parent sélectionné"));
            }
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $this->dataclass->setParent($uids, $_POST["parent_sample_id"]);
            $this->message->set(_("Opération effectuée"));
        } catch (PpciException $oe) {
            $this->message->setSyslog($oe->getMessage());
            $this->message->set(_("Une erreur est survenue pendant la mise à jour du parent"), true);
            $this->message->set($oe->getMessage());
        }
    }
    function getChildren()
    {
        $this->vue = service("AjaxView");
        $this->vue->set($this->dataclass->getChildren($_REQUEST["uid"]));
        return $this->vue->send();
    }

    function setRelatedTablesToView($vue)
    {
        $vue->set($_SESSION["collections"], "collections");
        $collection = new Collection();
        $vue->set($collection->getAllCollections(), "collectionsSearch");
        $sampleType = new SampleType();
        $vue->set($sampleType->getListe(2), "sample_type");
        $objectStatus = new ObjectStatus();
        $vue->set($objectStatus->getListe(1), "objectStatus");
        $samplingPlace = new SamplingPlace();
        $vue->set($samplingPlace->getListFromCollection(), "samplingPlace");
        $metadata = new Metadata();
        $vue->set($metadata->getListSearchable(), "metadatas");
        $referent = new Referent();
        $vue->set($referent->getListe(2), "referents");
        $mv = new MovementReason();
        $vue->set($mv->getListe(2), "movementReason");
        $vue->set($_SESSION["dbparams"]["APPLI_code"], "APPLI_code");
        $borrower = new Borrower();
        $vue->set($borrower->getListe(2), "borrowers");
        $vue->set(date($_SESSION["date"]["maskdate"]), "borrowing_date");
        $vue->set(date($_SESSION["date"]["maskdate"]), "expected_return_date");
        $exportModel = new ExportModel();
        $vue->set($exportModel->getListFromTarget("sample"), "exportModels");
        $eventType = new EventType();
        $vue->set($eventType->getListeFromCategory("sample"), "eventType");
        $campaign = new Campaign();
        $vue->set($campaign->getListe(2), "campaigns");
        $cf = new ContainerFamily();
        $vue->set($cf->getListe(2), "containerFamily");
        $country = new Country();
        $vue->set($country->getListe(2), "countries");
        $label = new Label;
        $vue->set($label->getListe(2), "labels");
    }
}
