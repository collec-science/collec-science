<?php

/**
 * Classe de gestion de la table referent
 * 
 * @var mixed
 */
class Referent extends ObjetBDD
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
        $this->table = "referent";
        $this->colonnes = array(
            "referent_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "referent_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "referent_email" => array("type" => 0),
            "address_name" => array("type" => 0),
            "address_line2" => array("type" => 0),
            "address_line3" => array("type" => 0),
            "address_city" => array("type" => 0),
            "address_country" => array("type" => 0),
            "referent_phone" => array("type" => 0)
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Recupere l'enregistrement a partir du nom du referent
     * 
     * @param string $name 
     * 
     * @return array 
     */
    function getFromName($name)
    {
        if (strlen($name) > 0) {
            $sql = "select * from referent 
                    where referent_name = :name";
            return $this->lireParamAsPrepared($sql, array("name" => $name));
        }
    }
}
?>