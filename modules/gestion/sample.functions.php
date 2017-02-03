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
$vue->set($_SESSION["projects"],"projects");
/*
 * Recherche des types d'échantillons
 */
require_once 'modules/classes/sampleType.class.php';
$sampleType = new SampleType($bdd, $ObjetBDDParam);
$vue->set( $sampleType->getListe(2), "sample_type");
require_once 'modules/classes/objectStatus.class.php';
$objectStatus = new ObjectStatus($bdd, $ObjetBDDParam);
$vue->set($objectStatus->getListe(1), "objectStatus");
require_once 'modules/classes/samplingPlace.class.php';
$samplingPlace = new SamplingPlace($bdd, $ObjetBDDParam);
$vue->set($samplingPlace->getListe(1), "samplingPlace");
?>