<?php
class Campaign extends ObjetBDD
{
    /**
     * __construct
     *
     * @param mixed $bdd
     * @param mixed $param
     *
     * @return mixed
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "campaign";
        $this->colonnes = array(
            "campaign_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "campaign_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "campaign_from" => array("type" => 2),
            "campaign_to" => array("type"=>2)
        );
        parent::__construct($bdd, $param);
    }
  }