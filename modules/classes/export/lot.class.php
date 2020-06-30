<?php
class Lot extends ObjetBDD
{
  public $sample;
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

  function createLot($collection_id, $uids) {
    if (count($uids) > 0) {
      $id = $this->ecrire(array("collection_id"=>$collection_id));

      if ($id > 0) {
        if (! is_object($this->sample)) {
          include_once "modules/classes/sample.class.php";
          $this->sample = new Sample($this->connection, $this->paramori);
        }
        $samples = $this->sample->getIdsFromUids($uids, $collection_id);
        $this->ecrireTableNN("lot_sample","lot_id", "sample_id", $id, $samples);
      }
    }
  }
}
