<?php
/**
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
/*
 * Recherche des projets
 */
$smarty->assign("projects", $_SESSION["projects"]);
/*
 * Recherche des types d'échantillons
 */
require_once 'modules/classes/sampleType.class.php';
$sampleType = new SampleType($bdd, $ObjetBDDParam);
$smarty->assign("sample_type", $sampleType->getListe(2));
?>