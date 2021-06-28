<?php

/**
 * Default page
 */
if (isset($_SESSION["login"])) {
  include_once "modules/classes/collection.class.php";
  $collection = new Collection($bdd, $ObjetBDDParam);
  $vue->set($collection->getNbsampleByCollection(), "collections");
}
$vue->set("main.tpl", "corps");
