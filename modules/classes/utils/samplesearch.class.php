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
  function getList($collection_id = 0)
  {
    $where = " where samplesearch_login = :login";
    $param = array("login" => $this->getLogin());
    if ($collection_id > 0) {
      $where .= " or collection_id = :collection_id";
      $param["collection_id"] = $collection_id;
    }
    $order = " order by samplesearch_name";
    return $this->getListeParamAsPrepared($this->sql . $where . $order, $param);
  }
}
