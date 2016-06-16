<?php
/**
 * Created : 16 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
 require_once 'modules/classes/containerFamily.class.php';
 $cf = new ContainerFamily($bdd, $ObjetBDDParam);
 $smarty->assign("containerFamily", $cf->getListe(2));
 require_once 'modules/classes/containerStatus.class.php';
 $cs = new ContainerStatus($bdd, $ObjetBDDParam);
 $smarty->assign("containerStatus", $cs->getListe(1));
 require_once 'modules/classes/containerType.class.php';
// $ct = new ContainerType($bdd, $ObjetBDDParam);
// $smarty->assign("containerType", $ct->getListe(2));
?>