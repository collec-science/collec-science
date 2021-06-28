<?php

/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2015, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 3 juin 2015
 */
class LdapException extends Exception
{
}

class DroitException extends Exception
{
}

class Aclappli extends ObjetBDD
{

    function __construct($bdd, $param = array())
    {
        $this->table = "aclappli";
        $this->colonnes = array(
            "aclappli_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "appli" => array(
                "requis" => 0
            ),
            "applidetail" => array(
                "type" => 0
            )
        );
        parent::__construct($bdd, $param);
    }
}

class Aclaco extends ObjetBDD
{

    function __construct($bdd, $param = array())
    {
        $this->table = "aclaco";
        $this->colonnes = array(
            "aclaco_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "aclappli_id" => array(
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1
            ),
            "aco" => array(
                "requis" => 0
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Surcharge de la fonction write pour ecrire les logins associes
     * (non-PHPdoc)
     *
     * @see ObjetBDD::write()
     */
    function ecrire($data)
    {
        $id = parent::ecrire($data);
        if ($id > 0) {
            $this->ecrireTableNN("aclacl", "aclaco_id", "aclgroup_id", $id, $data["groupes"]);
        }
        return $id;
    }

    /**
     * Surcharge de la fonction supprimer pour effacer les droits rattaches
     * (non-PHPdoc)
     *
     * @see ObjetBDD::supprimer()
     */
    function supprimer($id)
    {
        if ($id > 0) {
            /*
             * Suppression des droits rattaches
             */
            $this->ecrireTableNN("aclacl", "aclaco_id", "aclgroup_id", $id, array());
            return parent::supprimer($id);
        } else {
            return false;
        }
    }

    /**
     * Retourne la liste des logins associes a un ACO
     *
     * @param string $aco
     *            : aco a tester
     * @return tableau : liste des logins trouves
     */
    function getLogins($aco)
    {
        if (strlen($this->encodeData($aco)) > 0) {
            $sql = "with recursive first_level (login, aco, aclgroup_id, aclgroup_id_parent) as (
					(select login, 	aco, aclgroup_id, aclgroup_id_parent
						from acllogin
						natural join acllogingroup
						natural join aclgroup
						natural join aclacl
						natural join aclaco
					)
					union all (select login, aco.aco, g.aclgroup_id, g.aclgroup_id_parent
						from first_level fl, aclgroup g, aclacl acl, aclaco aco
						where acl.aclgroup_id = g.aclgroup_id
						and acl.aclaco_id = aco.aclaco_id
						and g.aclgroup_id = fl.aclgroup_id_parent)
					)
					select distinct login from first_level
					where aco = '" . $aco . "'
					order by login";
            return $this->getListeParam($sql);
        }
    }
}
