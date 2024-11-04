<?php

namespace App\Libraries;

use App\Models\Booking;
use App\Models\Borrower;
use App\Models\Borrowing;
use App\Models\Campaign;
use App\Models\Collection;
use App\Models\Container as ModelsContainer;
use App\Models\ContainerFamily;
use App\Models\Country;
use App\Models\Document;
use App\Models\Event;
use App\Models\EventType;
use App\Models\ExportModel;
use App\Models\MimeType;
use App\Models\Movement;
use App\Models\MovementReason;
use App\Models\ObjectClass;
use App\Models\ObjectIdentifier;
use App\Models\ObjectStatus;
use App\Models\Referent;
use App\Models\Sample;
use App\Models\SampleInitClass;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Libraries\Views\AjaxView;
use Ppci\Models\PpciModel;

class Container extends PpciLibrary
{
    /**
     * @var ModelsContainer
     */
    protected PpciModel $dataclass;


    private $isDelete = false;
    private $activeTab;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsContainer();
        $this->keyName = "uid";
        if (isset($_REQUEST["uid"]) && strlen($_REQUEST["uid"]) > 0) {
            $this->id = $_REQUEST[$this->keyName];
        }
        $_SESSION["moduleParent"] = "container";
    }


    function list()
    {
        $this->vue = service('Smarty');
        $this->vue->set("containerList", "moduleFrom");
        $_SESSION["moduleListe"] = "containerList";
        /*
         * Display the list of all records of the table
         */
        if (!($this->isDelete) && !isset($_REQUEST["is_action"])) {
            $_SESSION["searchContainer"]->setParam($_REQUEST);
        }
        $dataSearch = $_SESSION["searchContainer"]->getParam();
        if ($_SESSION["searchContainer"]->isSearch() == 1) {
            $data = $this->dataclass->containerSearch($dataSearch);
            $this->vue->set($data, "containers");
            $this->vue->set(1, "isSearch");
        }
        $this->vue->set($dataSearch, "containerSearch");
        $this->vue->set("gestion/containerList.tpl", "corps");
        $borrower = new Borrower();
        $this->vue->set($borrower->getListe(2), "borrowers");
        $this->vue->set(date($_SESSION["date"]["maskdate"]), "borrowing_date");
        $this->vue->set(date($_SESSION["date"]["maskdate"]), "expected_return_date");
        /*
         * Ajout des listes deroulantes
         */
        $this->setRelatedTablesToView();
        /*
         * Ajout de la selection des modeles d'etiquettes
         */
        $label = new Label;
        $label->setRelatedTablesToView($this->vue);
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        /*
         * Display the detail of the record
         */
        if (isset($this->id)) {
            $data = $this->dataclass->lire($this->id);
            $this->vue->set($data, "data");
            $this->vue->set("containerDisplay", "moduleFrom");
            $this->vue->set($this->id, "containerUid");
            /*
         * Recuperation des identifiants associes
         */
            $oi = new ObjectIdentifier();
            $this->vue->set($oi->getListFromUid($data["uid"]), "objectIdentifiers");
            /*
         * Recuperation des contenants parents
         */
            $this->vue->set($this->dataclass->getAllParents($data["uid"]), "parents");
            /*
         * Recuperation des contenants et des échantillons contenus
         */
            $dcontainer = $this->dataclass->getContentContainer($data["uid"]);
            if ($_REQUEST["allSamples"] == 1) {
                $sample = new Sample();
                $dsample = $sample->getAllSamplesFromContainer($data["uid"]);
                $this->message->set(_("Affichage avec la liste de tous les échantillons présents dans le contenant, y compris dans les contenants inclus"));
            } else {
                $dsample = $this->dataclass->getContentSample($data["uid"]);
            }
            $this->vue->set($dcontainer, "containers");
            $this->vue->set($dsample, "samples");
            /*
         * Preparation du tableau d'occupation du container
         */
            $this->vue->set($this->dataclass->generateOccupationArray($dcontainer, $dsample, $data["columns"], $data["lines"], $data["first_line"], $data["first_column"]), "containerOccupation");
            $this->vue->set($data["lines"], "nblignes");
            $this->vue->set($data["columns"], "nbcolonnes");
            $this->vue->set($data["first_line"], "first_line");
            $this->vue->set($data["first_column"], "first_column");
            $this->vue->set($data["line_in_char"], "line_in_char");
            $this->vue->set($data["column_in_char"], "column_in_char");
            /*
         * Recuperation des evenements
         */
            $event = new Event();
            $this->vue->set($event->getListeFromUid($data["uid"]), "events");
            /*
         * Recuperation des mouvements
         */
            $movement = new Movement();
            $this->vue->set($movement->getAllMovements($this->id), "movements");
            /*
         * Recuperation des reservations
         */
            $booking = new Booking();
            $this->vue->set($booking->getListFromParent($data["uid"], 'date_from desc'), "bookings");
            /*
         * Recuperation des documents
         */
            $document = new Document();
            $this->vue->set($document->getListFromField("uid", $data["uid"]), "dataDoc");
            $this->vue->set($document->getMaxUploadSize(), "maxUploadSize");
            $this->vue->set($_SESSION["collections"][$data["collection_id"]]["external_storage_enabled"], "externalStorageEnabled");
            /**
             * Get the list of authorized extensions
             */
            $mimeType = new MimeType();
            $this->vue->set($mimeType->getListExtensions(false), "extensions");
            $this->vue->set("event_id", "parentKeyName");
            $this->vue->set($this->dataclass->verifyCollection($data), "modifiable");
            /*
         * Ajout de la selection des modeles d'etiquettes
         */
            $label = new Label;
            $label->setRelatedTablesToView($this->vue);
            /*
         * Ajout de la liste des referents, pour operations de masse sur les echantillons
         */
            $referent = new Referent();
            $this->vue->set($referent->getListe(2), "referents");
            /**
             * Recuperation des types d'evenements
             */
            $eventType = new EventType();
            $this->vue->set($eventType->getListe(1), "eventType");
            /**
             * Get the list of borrowings
             */
            $borrowing = new Borrowing();
            $this->vue->set($borrowing->getFromUid($data["uid"]), "borrowings");
            /**
             * Get the list of borrowers
             */
            $borrower = new Borrower();
            $this->vue->set($borrower->getListe(2), "borrowers");
            $this->vue->set(date($_SESSION["date"]["maskdate"]), "borrowing_date");
            $this->vue->set(date($_SESSION["date"]["maskdate"]), "expected_return_date");

            /**
             * Lists for actions on samples
             */
            $this->vue->set($_SESSION["collections"], "collections");
            $campaign = new Campaign();
            $this->vue->set($campaign->getListe(2), "campaigns");
            $cf = new ContainerFamily();
            $this->vue->set($cf->getListe(2), "containerFamily");
            $country = new Country();
            $this->vue->set($country->getListe(2), "countries");
            $objectStatus = new ObjectStatus();
            $this->vue->set($objectStatus->getListe(1), "objectStatus");
            MapInit::setDefault($this->vue);
        }
        /**
         * Affichage
         */
        $this->vue->set("container", "moduleParent");
        $this->vue->set("gestion/containerDisplay.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead($this->id, "gestion/containerChange.tpl");
        if ($_REQUEST["container_parent_uid"] > 0 && is_numeric($_REQUEST["container_parent_uid"])) {
            $container_parent = $this->dataclass->lire($_REQUEST["container_parent_uid"]);
            $this->vue->set($container_parent["uid"], "container_parent_uid");
            $this->vue->set($container_parent["identifier"], "container_parent_identifier");
        }
        $this->setRelatedTablesToView();
        MapInit::setDefault($this->vue);
        $this->vue->set(1, "mapIsChange");
        /*
         * Recuperation des referents
         */
        $referent = new Referent();
        $this->vue->set($referent->getListe(2), "referents");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                if ($_REQUEST["container_parent_uid"] > 0 && is_numeric($_REQUEST["container_parent_uid"])) {
                    $movement = new Movement();
                    $data = array(
                        "uid" => $this->id,
                        "movement_date" => date($_SESSION["MASKDATELONG"]),
                        "movement_type_id" => 1,
                        "login" => $_SESSION["login"],
                        "container_id" => $this->dataclass->getIdFromUid($_REQUEST["container_parent_uid"]),
                        "movement_id" => 0,
                        "line_number" => 1,
                        "column_number" => 1,

                    );
                    $movement->ecrire($data);
                }
                return true;
            } else {
                return false;
            }
        } catch (PpciException) {
            return false;
        }
    }

    function deleteMulti()
    {
        /*
         * Delete all records in uid array
         */
        if (count($_POST["uids"]) > 0) {
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            try {
                $db = $this->dataclass->db;
                $db->transBegin();
                foreach ($uids as $uid) {
                    $this->dataDelete($uid, true);
                }
                $db->transCommit();
                $this->message->set(_("Suppression effectuée"));
                return true;
            } catch (PpciException $e) {
                $this->message->set($e->getMessage() . " ($uid)");
                if ($db->transEnabled) {
                    $db->transRollback();
                }
                return true;
            }
        } else {
            $this->message->set(_("Pas de contenants sélectionnés"), true);
            return true;
        }
    }
    function delete()
    {
        /*
         * delete record
         */
        try {
            $this->dataDelete($this->id);
            $this->isDelete = true;
            return true;
        } catch (PpciException $e) {
            return false;
        }
    }


    function getFromType()
    {
        /*
         * Recherche la liste a partir du type
         */
        $this->vue = service('AjaxView');
        $this->vue->set($this->dataclass->getFromType($_REQUEST["container_type_id"]));
        return $this->vue->send();
    }
    function getFromUid()
    {
        /*
         * Lecture d'un container a partir de son uid
         */
        $this->vue = service('AjaxView');
        $this->vue->set($this->dataclass->lire($_REQUEST["uid"]));
        return $this->vue->send();
    }
    function exportGlobal()
    {
        if (!empty($_REQUEST["uids"])) {
            $data = $this->dataclass->generateExportGlobal($_REQUEST["uids"]);
            $this->vue = service('JsonFileView');
            $this->vue->setParam(
                array(
                    "content_type" => "application/json",
                    "filename" => "export-" . date('Y-m-d-His') . ".json"
                )
            );
            $this->vue->set($data);
            return $this->vue->send();
        } else {
            $this->message->set(_("Aucun contenant n'a été sélectionné, l'exportation n'est pas possible"), true);
            return $this->list();
        }
    }
    function importStage1()
    {
        $this->vue = service('Smarty');
        $this->vue->set("gestion/containerImport.tpl", "corps");
        $this->vue->set(0, "utf8_encode");
        return $this->vue->send();
    }
    function importStage2()
    {
        unset($_SESSION["filename"]);
        $this->vue = service('Smarty');
        $this->vue->set("gestion/containerImport.tpl", "corps");
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            /*
             * Deplacement du fichier dans le dossier temporaire
             */
            $filename = $this->appConfig->APP_temp . '/' . bin2hex(openssl_random_pseudo_bytes(4));
            if (copy($_FILES['upfile']['tmp_name'], $filename)) {
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
                     * Get the content of the file
                     */
                    $handle = fopen($filename, "r");
                    $jdata = fread($handle, filesize($filename));
                    fclose($handle);

                    $data = json_decode($jdata, true);
                    if ($data["export_version"] != 1) {
                        throw new PpciException(
                            _("La version du fichier importé ne correspond pas à la version attendue")
                        );
                    }
                } catch (PpciException $e) {
                    $this->message->set($e->getMessage(), true);
                    unlink($filename);
                    unset($_SESSION["realfilename"]);
                }

                $this->vue->set($this->dataclass->getAllNamesFromReference($data), "names");
                $sic = new SampleInitClass();
                $this->vue->set($sic->init(), "dataClass");
                $_SESSION["realfilename"] = $filename;

                $this->vue->set($_REQUEST["utf8_encode"], "utf8_encode");
                $this->vue->set(2, "stage");
                $this->vue->set($_FILES['upfile']['name'], "filename");
            } else {
                $this->message->set(_("Impossible de recopier le fichier importé dans le dossier temporaire"), true);
            }
        } else {
            $this->message->set(_("Pas de fichier téléchargé"), true);
        }
        $this->vue->set("gestion/containerImport.tpl", "corps");
        return $this->vue->send();
    }
    function importStage3()
    {
        $realfilename = $_SESSION["realfilename"];

        if (file_exists($realfilename)) {
            try {
                /**
                 * Open the file
                 */
                $handle = fopen($realfilename, "r");
                $jdata = fread($handle, filesize($realfilename));
                fclose($handle);
                unset($_SESSION["realfilename"]);
                unlink($realfilename);

                $data = json_decode($jdata, true);
                $sic = new SampleInitClass();
                $db = $this->dataclass->db;
                $db->transBegin();
                $this->dataclass->importExternal($data, $sic, $_POST);
                $result = $this->dataclass->getUidMinMax();
                $db->transCommit();
                $this->message->set(sprintf(_("Import effectué. %s objets traités"), $result["number"]));
                $this->message->set(sprintf(_("Premier UID généré : %s"), $result["min"]));
                $this->message->set(sprintf(_("Dernier UID généré : %s"), $result["max"]));
            } catch (PpciException) {
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            } catch (\Exception $e1) {
                $this->message->set($e1->getMessage(), true);
            }
        }
        return $this->importStage1();
    }

    function lendingMulti()
    {
        /**
         * Lend the containers to a borrower
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
            } catch (PpciException | \Exception $me) {
                $this->message->set(_("Erreur lors de la génération du mouvement de sortie"), true);
                $this->message->set($me->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            }
        }
        return true;
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
            } catch (PpciException | \Exception $me) {
                $this->message->set(_("Erreur lors de la génération du mouvement de sortie"), true);
                $this->message->set($me->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            }
        } else {
            $this->message->set(_("Aucun contenant n'a été sélectionné"), true);
        }
        return true;
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
            $this->message->set(_("Aucun objet n'a été sélectionné, ou aucun contenant pour le stockage n'a été indiqué"), true);
        }
        return true;
    }

    function getOccupationAjax()
    {
        $this->vue = service('AjaxView');
        $data = $this->dataclass->lire($this->id);
        $dcontainer = $this->dataclass->getContentContainer($this->id);
        $dsample = $this->dataclass->getContentSample($this->id);
        $dgrid = array();
        $grid = $this->dataclass->generateOccupationArray($dcontainer, $dsample, $data["columns"], $data["lines"], $data["first_line"], $data["first_column"]);
        foreach ($grid as $line) {
            $gl = array();
            foreach ($line as $cell) {
                $gc = array();
                foreach ($cell as $item) {
                    $gc[] = $item;
                }
                $gl[] = $gc;
            }
            $dgrid["lines"][] = $gl;
        }
        $dgrid["lineNumber"] = $data["lines"];
        $dgrid["columnNumber"] = $data["columns"];
        $dgrid["firstLine"] = $data["first_line"];
        $dgrid["firstColumn"] = $data["first_column"];
        $dgrid["column_in_char"] = $data["column_in_char"];
        $dgrid["line_in_char"] = $data["line_in_char"];
        $this->vue->set($dgrid);
        return $this->vue->send();
    }

    function verifyCyclic()
    {
        $this->vue = service('Smarty');
        $this->vue->set("gestion/containerVerifyCyclic.tpl", "corps");
        return $this->vue->send();
    }
    function verifyCyclicExec()
    {
        $this->vue = service('Smarty');
        $this->vue->set("gestion/containerVerifyCyclic.tpl", "corps");
        $this->vue->set($this->dataclass->getCyclicMovements(), "data");
        $this->vue->set(1, "exec");
        return $this->vue->send();
    }
    function setStatus()
    {
        try {
            if (count($_POST["uids"]) == 0) {
                throw new PpciException(_("Pas de contenants sélectionnés"));
            }
            if (empty($_POST["object_status_id"])) {
                throw new PpciException(_("Pas de statut sélectionné"));
            }
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $object = new ObjectClass();
            $object->setStatus($_POST["uids"], $_POST["object_status_id"]);
        } catch (PpciException $oe) {
            $this->message->setSyslog($oe->getMessage());
            $this->message->set(_("Une erreur est survenue pendant la mise à jour du statut"), true);
            $this->message->set($oe->getMessage());
        }
        return true;
    }
    function referentMulti()
    {
        try {
            if (count($_POST["uids"]) == 0) {
                throw new PpciException(_("Pas de contenants sélectionnés"));
            }
            if (empty($_POST["referent_id"])) {
                throw new PpciException(_("Pas de référent sélectionné"));
            }
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $object = new ObjectClass();
            $db = $this->dataclass->db;
            $db->transBegin();
            foreach ($uids as $uid) {
                $object->setReferent($uid, $_POST["referent_id"]);
            }
            $db->transCommit();
            $this->message->set(_("Opération effectuée"));
        } catch (PpciException $oe) {
            $this->message->setSyslog($oe->getMessage());
            $this->message->set(_("Une erreur est survenue pendant l'assignation du référent"), true);
            $this->message->set($oe->getMessage());
            if ($db->transEnabled) {
                $db->transRollback();
            }
        }
        return true;
    }
    function getChildren()
    {
        $this->vue = service('AjaxView');
        $this->vue->set($this->dataclass->getChildrenContainer($_REQUEST["uid"]));
        return $this->vue->send();
    }
    function setCollection()
    {
        try {
            if (count($_POST["uids"]) == 0) {
                throw new PpciException(_("Pas de contenants sélectionnés"));
            }
            if (empty($_POST["collection_id_change"])) {
                throw new PpciException(_("Pas de collection sélectionnée"));
            }
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $this->dataclass->setCollection($_POST["uids"], $_POST["collection_id_change"]);
        } catch (PpciException $oe) {
            $this->message->setSyslog($oe->getMessage());
            $this->message->set(_("Une erreur est survenue pendant la mise à jour de la collection"), true);
            $this->message->set($oe->getMessage());
        }
        return true;
    }

    function setRelatedTablesToView()
    {
        $cf = new ContainerFamily();
        $this->vue->set($cf->getListe(2), "containerFamily");
        $objectStatus = new ObjectStatus();
        $this->vue->set($objectStatus->getListe(1), "objectStatus");
        $this->vue->set($_SESSION["dbparams"]["APPLI_code"], "APPLI_code");
        $exportModel = new ExportModel();
        $this->vue->set($exportModel->getListFromTarget("container"), "exportModels");
        $referent = new Referent();
        $this->vue->set($referent->getListe("referent_name"), "referents");
        $eventType = new EventType();
        $this->vue->set($eventType->getListeFromCategory("container"), "eventType");
        $mv = new MovementReason();
        $this->vue->set($mv->getListe(2), "movementReason");
        $this->vue->set($_SESSION["collections"], "collections");
        $collection = new Collection();
        $this->vue->set($collection->getAllCollections(), "collectionsSearch");
    }
    /**
     * Verify if a slot is full - ajax service
     *
     */
    function isSlotFull()
    {
        /**
         * @var AjaxView
         */
        $this->vue = service("AjaxView");
        if (!empty($_REQUEST["uid"]) && !empty($_REQUEST["line"]) && !empty($_REQUEST["column"])) {
            $this->vue->set(["isFull" => $this->dataclass->isSlotFull($_REQUEST["uid"], $_REQUEST["line"], $_REQUEST["column"])]);
        } else {
            $this->vue->set(["isFull" => 0]);
        }
        return $this->vue->send();
    }
}
