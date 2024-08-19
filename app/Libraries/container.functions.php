<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Xx extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $dataclass;

    private $keyName;

function __construct()
    {
        parent::__construct();
        $this->dataClass = new XXX();
        $this->keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

/**
 * Created : 16 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/containerFamily.class.php';
$cf = new ContainerFamily();
$this->vue->set($cf->getListe(2), "containerFamily");
require_once 'modules/classes/objectStatus.class.php';
$objectStatus = new ObjectStatus();
$this->vue->set($objectStatus->getListe(1), "objectStatus");
$this->vue->set($_SESSION["APPLI_code"], "APPLI_code");
include_once "modules/exportmodel/exportmodel.class.php";
$exportModel = new ExportModel();
$this->vue->set($exportModel->getListFromTarget("container"), "exportModels");
require_once "modules/classes/referent.class.php";
$referent = new Referent();
$this->vue->set($referent->getListe("referent_name"), "referents");
include_once 'modules/classes/eventType.class.php';
$eventType = new EventType();
$this->vue->set($eventType->getListeFromCategory("container"), "eventType");
include_once 'modules/classes/movementReason.class.php';
$mv = new MovementReason();
$this->vue->set($mv->getListe(2), "movementReason");
$this->vue->set($_SESSION["collections"], "collections");
include_once "modules/classes/collection.class.php";
$collection = new Collection();
$this->vue->set($collection->getAllCollections(), "collectionsSearch");
