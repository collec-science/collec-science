<?php
class Regulation extends ObjetBDD
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
        $this->table = "regulation";
        $this->colonnes = array(
            "regulation_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "regulation_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "regulation_comment" => array("type" => 0)
        );
        parent::__construct($bdd, $param);
    }
  }