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
 function collectionVerify(int $collection_id) : bool {
   $ok = false;
   foreach ($_SESSION["collections"] as $collection) {
     if ($collection["collection_id"] == $collection_id) {
       $ok = true;
       break;
     }
   }
   return $ok;
 }

?>