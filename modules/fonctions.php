<?php

/**
 * Fonctions specifiques de l'application, chargees systematiquement
 */
/**
 * Verify if the collection is allowed (present in $_SESSION["collections"])
 *
 * @param integer $collection_id
 * @return boolean
 */
function collectionVerify(int $collection_id): bool
{
  $ok = false;
  foreach ($_SESSION["collections"] as $collection) {
    if ($collection["collection_id"] == $collection_id) {
      $ok = true;
      break;
    }
  }
  return $ok;
}
/**
 * Delete the group into all collections.
 * Function called from class
 *
 * @param integer $group_id
 * @return void
 */
function deleteChildrenForGroup(int $group_id)
{
  require_once "modules/classes/collection.class.php";
  global $bdd, $ObjetBDDParam;
  $collection = new Collection($bdd, $ObjetBDDParam);
  $collection->deleteGroup($group_id);
}
