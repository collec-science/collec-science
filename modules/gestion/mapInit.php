<?php

/**
 * Created : 17 janv. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 * Initialisation des variables necessaires a l'affichage des cartes Openstreetmap
 */

foreach (array("mapDefaultX", "mapDefaultY", "mapDefaultZoom") as $field) {
    $vue->set($_SESSION[$field], $field);
}

?>