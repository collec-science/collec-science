<?php
class Lot extends ObjetBDD
{
  public $sample, $export;

  private $sql = "select lot_id, collection_id, lot_date, collection_name
                  , count(*) as sample_number
                  from lot
                  join lot_sample using (lot_id)
                  join collection using (collection_id)";
  private $groupby = " group by lot_id, collection_id, lot_date, collection_name";
  /**
   * Constructor
   *
   * @param PDO $bdd: connection to the database
   * @param array $param: specific parameters
   */
  function __construct(PDO $bdd, $param = array())
  {
    $this->table = "lot";
    $this->colonnes = array(
      "lot_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "collection_id" => array("type" => 1, "requis" => 1),
      "lot_date" => array("type" => 3, "defaultValue" => "getDateHeure")
    );
    parent::__construct($bdd, $param);
  }

  function createLot($collection_id, $uids)
  {
    $id = 0;
    if (count($uids) > 0) {
      $id = $this->ecrire(array("collection_id" => $collection_id));

      if ($id > 0) {
        if (!is_object($this->sample)) {
          include_once "modules/classes/sample.class.php";
          $this->sample = new Sample($this->connection, $this->paramori);
        }
        $samples = $this->sample->getIdsFromUids($uids, $collection_id);
        $this->ecrireTableNN("lot_sample", "lot_id", "sample_id", $id, $samples);
      }
    }
    return $id;
  }

  /**
   * Overload of supprimer to delete all informations attached
   *
   * @param int $lot_id
   * @return void
   */
  function supprimer($lot_id)
  {
    if (!is_object($this->export)) {
      include_once "modules/classes/export/export.class.php";
      $this->export = new Export($this->connection, $this->paramori);
    }
    /**
     * Delete attached exports
     */
    $this->export->supprimerChamp($lot_id, "lot_id");
    /**
     * Delete samples reference
     */
    $sql = "delete from lot_sample where lot_id = :lot_id";
    $this->executeAsPrepared($sql, array("lot_id" => $lot_id));
    return parent::supprimer($lot_id);
  }

  /**
   * Get the detail of a lot
   *
   * @param integer $lot_id
   * @return array
   */
  function getDetail($lot_id)
  {
    $where = " where lot_id = :id";
    return $this->lireParamAsPrepared($this->sql . $where. $this->groupby, array("id" => $lot_id));
  }

  /**
   * Get all lots from a collection
   *
   * @param integer $collection_id
   * @return array
   */
  function getLotsFromCollection ($collection_id) {
    $where = " where collection_id = :id";
    return $this->getListeParamAsPrepared($this->sql . $where. $this->groupby, array("id" => $collection_id));
  }
}
