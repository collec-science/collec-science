<?php

namespace App\Libraries;

use App\Models\Movement;
use App\Models\MovementReason;
use App\Models\ObjectClass;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;
use Ppci\Libraries\Locale;

class MovementWs extends PpciLibrary
{
    /**
     * @var Movement
     */
    protected PpciModel $dataclass;

    private $keyName;
    private $errors = array(
        500 => "Internal Server Error",
        400 => "Bad request",
        401 => "Unauthorized",
        403 => "Forbidden",
        520 => "Unknown error",
        404 => "Not Found"
    );
    function __construct()
    {
        parent::__construct();
        $this->dataClass = new Movement();
        $this->keyName = "movement_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
        if (isset($_REQUEST["locale"])) {
            $localeLib = new Locale();
            $localeLib->setLocale($_REQUEST["locale"]);
        }
    }

    function write()
    {
        $object = new ObjectClass();
        try {
            $dataSent = $_POST;
            /**
             * Search the object to move
             */
            $obj = $object->search($dataSent["uid"], $dataSent["identifier"], $dataSent["uuid"]);
            if (!$obj["uid"] > 0) {
                throw new PpciException(_("Aucun objet n'a été trouvé à partir des identifiants fournis"), 400);
            }
            if (!($dataSent["movement_type"] == 1 || $dataSent["movement_type"] == 2)) {
                throw new PpciException(_("Le type de mouvement n'a pas été correctement renseigné"), 400);
            }
            /**
             * Search for the container
             */
            if ($dataSent["movement_type"] == 1) {
                $container = $object->search($dataSent["container_uid"], $dataSent["container_identifier"], $dataSent["container_uuid"]);
                if (!$container["container_id"] > 0) {
                    throw new PpciException(_("Le contenant n'a pas été trouvé"), 400);
                }
            } else {
                $container["uid"] = 0;
            }
            /**
             * Verify if the movement reason exists
             */
            if ($dataSent["movement_reason"] > 0) {
                $movementReason = new MovementReason();
                $reason = $movementReason->lire($dataSent["movement_reason"]);
                if (!$reason["movement_reason_id"] > 0) {
                    throw new PpciException(_("Le code du motif de déstockage n'a pas été trouvé"), 400);
                }
            }
            $this->dataclass->addMovement(
                $obj["uid"],
                null,
                $dataSent["movement_type"],
                $container["uid"],
                null,
                $dataSent["storage_location"],
                $dataSent["comment"],
                $dataSent["movement_reason"],
                $dataSent["column"],
                $dataSent["line"]
            );
            $retour = array(
                "error_code" => 200,
                "error_message" => "processed"
            );
            http_response_code(200);
        } catch (PpciException $e) {
            $error_code = $e->getCode();
            if (!isset($errors[$error_code])) {
                $error_code = 520;
            }
            $retour = array(
                "error_code" => $error_code,
                "error_message" => $this->errors[$error_code],
                "error_detail" => $e->getMessage()
            );
            http_response_code($error_code);
            $this->message->setSyslog($e->getMessage());
        } finally {
            $this->vue->setJson(json_encode($retour));
        }
    }
}
