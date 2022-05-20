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
            "referent_phone" => array("type" => 0),
            "referent_firstname" => array("type" => 0),
            "academical_directory" => array("type" => 0),
            "academical_link" => array("type" => 0),
            "referent_organization" => array("type" => 0)
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
    function getFromName($name, $firstname = "")
    {
        if (!empty($name)) {
            $sql = "select * from referent
                    where referent_name = :name";
            $data = array("name" => $name);
            if (!empty($firstname)) {
                $sql .= " and referent_firstname = :firstname";
                $data["firstname"] = $firstname;
            }
            return $this->lireParamAsPrepared($sql, $data);
        }
    }
    /**
     * Get the list of referents with only name and firstname in the same column
     *
     * @return array
     */
    function getListName()
    {
        $sql = "select referent_id,
        trim(referent_name || ' ' || coalesce(referent_firstname, ' ')) as referent_name
        from referent
        order by referent_name, referent_firstname";
        return $this->getListeParam($sql);
    }
}
