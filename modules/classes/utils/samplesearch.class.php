<?php

class Samplesearch extends ObjetBDD
{
  private $sql = "select samplesearch_id, samplesearch_name, samplesearch_data,
                  samplesearch_login, collection_id, collection_name
                  from samplesearch
                  left outer join collection using (collection_id)";
  function __construct($bdd, $param = array())
  {
    $this->table = "samplesearch";
    $this->colonnes = array(
      "samplesearch_id" => array(
        "type" => 1,
        "key" => 1,
        "requis" => 1,
        "defaultValue" => 0
      ),
      "samplesearch_name" => array("requis" => 1),
      "samplesearch_data" => array("type" => 0),
      "samplesearch_login" => array("type" => 0, "defaultValue" => "getLogin"),
      "collection_id" => array("type" => 1)
    );
    parent::__construct($bdd, $param);
  }
  /**
   * Get the list of the sample searches for the current user or for the specified collection
   *
   * @param integer $collection_id
   * @return array|null
   */
  function getList(array $collections = array())
  {
    $where = " where samplesearch_login = :login";
    $param = array("login" => $this->getLogin());
    $i = 1;
    if (!empty($collections)) {
      $where .= " or collection_id in (";
      foreach ($collections as $collection) {
        if ($i > 1) {
          $where .= ",";
        }
        $where .= ":col$i";
        $param["col$i"] = $collection["collection_id"];
        $i++;
      }
      $where .= ")";
    }
    $order = " order by samplesearch_name";
    return $this->getListeParamAsPrepared($this->sql . $where . $order, $param);
  }

  /**
   * Delete a record after verification
   *
   * @param int $id
   * @return void
   */
  function delete($id)
  {
    $data = $this->lire($id);
    /**
     * Verify the login or the rights
     */
    $ok = false;
    if ($data["samplesearch_login"] == $_SESSION["login"]) {
      $ok = true;
    } else if (!empty($data["collection_id"])) {
      if ((collectionVerify($data["collection_id"]) && $_SESSION["droits"]["collection"] == 1) || $_SESSION["droits"]["param"] == 1) {
        $ok = true;
      }
    }
    if ($ok) {
      parent::supprimer($id);
    }
  }
}
