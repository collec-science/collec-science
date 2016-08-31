<?php
/**
 * Created : 16 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
 require_once 'modules/classes/containerFamily.class.php';
 $cf = new ContainerFamily($bdd, $ObjetBDDParam);
 $vue->set($cf->getListe(2),"containerFamily");
/* require_once 'modules/classes/containerType.class.php';
 $ct = new ContainerType($bdd, $ObjetBDDParam);
 $smarty->assign("containerType", $ct->getListe(2));*/
 require_once 'modules/classes/objectStatus.class.php';
 $objectStatus = new ObjectStatus($bdd, $ObjetBDDParam);
 $vue->set($objectStatus->getListe(1), "objectStatus");
?>