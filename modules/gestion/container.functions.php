<?php

/**
 * Created : 16 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/containerFamily.class.php';
$cf = new ContainerFamily($bdd, $ObjetBDDParam);
$vue->set($cf->getListe(2), "containerFamily");
require_once 'modules/classes/objectStatus.class.php';
$objectStatus = new ObjectStatus($bdd, $ObjetBDDParam);
$vue->set($objectStatus->getListe(1), "objectStatus");
$vue->set($_SESSION["APPLI_code"], "APPLI_code");
include_once "modules/exportmodel/exportmodel.class.php";
$exportModel = new ExportModel($bdd, $ObjetBDDParam);
$vue->set($exportModel->getListFromTarget("container"), "exportModels");
require_once "modules/classes/referent.class.php";
$referent = new Referent($bdd, $ObjetBDDParam);
$vue->set($referent->getListe("referent_name"), "referents");
