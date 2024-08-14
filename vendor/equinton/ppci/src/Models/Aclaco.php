<?php
namespace Ppci\Models;

class Aclaco extends PpciModel
{

    function __construct()
    {
        $this->table = "aclaco";
        $this->fields = array(
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
        parent::__construct();
    }

    /**
     * Surcharge de la fonction write pour ecrire les logins associes
     * (non-PHPdoc)
     *
     */
    function write(array $data):int
    {
        $id = parent::write($data);
        if ($id > 0) {
            $this->writeTableNN("aclacl", "aclaco_id", "aclgroup_id", $id, $data["groupes"]);
        }
        return $id;
    }

    /**
     * Surcharge de la fonction supprimer pour effacer les droits rattaches
     * (non-PHPdoc)
     *
     * @see ObjetBDD::supprimer()
     */
    function delete($id = null, bool $purge = false)
    {
        if ($id > 0) {
            /*
             * Suppression des droits rattaches
             */
            $this->writeTableNN("aclacl", "aclaco_id", "aclgroup_id", $id, array());
            return parent::delete($id);
        } else {
            return false;
        }
    }

    /**
     * Retourne la liste des logins associes a un ACO
     *
     * @param string $aco
     * @return array : liste des logins trouves
     */
    function getLogins($aco)
    {
        if (!empty($aco)) {
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
					where aco = :aco:
					order by login";
            return $this->getListeParamAsPrepared($sql, array("aco" => $aco));
        }
    }
}
