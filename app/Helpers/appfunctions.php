<?php
/**
 * Sort list files on name
 *
 * @param string $a
 * @param string $b
 * @return int
 */
function cmp($a, $b)
{
	return strcmp($a["name"], $b["name"]);
}

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