<?php

/**
 * ORM de gestion de la table aclgroup
 *
 * @author quinton
 *
 */
class Aclgroup extends ObjetBDD
{

    function __construct($bdd, $param = array())
    {
        $this->table = "aclgroup";
        $this->colonnes = array(
            "aclgroup_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "groupe" => array(
                "requis" => 1
            ),
            "aclgroup_id_parent" => array(
                "type" => 1,
                "parentAttrib" => 1
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Recherche les groupes auquel appartient le login fourni en parametre
     *
     * @param string $login
     * @param $ldapParam =
     *            array(
     *            "address"=>"localhost",
     *            "port" => 389,
     *            "rdn" => "cn=manager,dc=example,dc=com",
     *            "basedn" => "ou=people,ou=example,o=societe,c=fr",
     *            "user_attrib" => "uid",
     *            "v3" => true,
     *            "tls" => false,
     *            "groupSupport"=>true,
     *            "groupAttrib"=>"supannentiteaffectation",
     *            "commonNameAttrib"=>"displayname",
     *            "mailAttrib"=>"mail",
     *            'attributgroupname' => "cn",
     *            'attributloginname' => "memberuid",
     *            'basedngroup' => 'ou=example,o=societe,c=fr'
     *            );
     * @return array
     */
    function getGroupsFromLogin($login, $ldapParam = array())
    {
        $groupes = array();
        if (!empty($login)) {

            $sql = "select g.aclgroup_id, groupe, aclgroup_id_parent
					from " . $this->table . " g
					join acllogingroup lg on (g.aclgroup_id = lg.aclgroup_id)
					join acllogin l on (lg.acllogin_id = l.acllogin_id)
					where login = :login";
            $groupes = $this->getListeParamAsPrepared($sql, array("login" => $login));
        }
        /*
         * Recherche des groupes LDAP
         */
        $groupesLdap = array();
        if ($ldapParam["groupSupport"]) {
            /*
             * Recuperation des attributs depuis l'annuaire LDAP
             */
            include_once "framework/ldap/ldap.class.php";
            $ldap = new Ldap($ldapParam);
            $conn = $ldap->connect();

            /**
             * Set the parameters
             */
            ldap_set_option($conn, LDAP_OPT_NETWORK_TIMEOUT, $ldapParam["timeout"]);
            ldap_set_option($conn, LDAP_OPT_TIMELIMIT, $ldapParam["timeout"]);
            ldap_set_option($conn, LDAP_OPT_TIMEOUT, $ldapParam["timeout"]);

            if ($conn > 0) {
                $attribut = array(
                    $ldapParam['commonNameAttrib'],
                    $ldapParam["mailAttrib"],
                    $ldapParam["groupAttrib"]
                );
                if ($ldapParam["ldapnoanonymous"]) {
                    if (! $ldap->login($ldapParam["ldaplogin"], $ldapParam["ldappassword"])) {
                        throw new LdapException(_("L'identification dans l'annuaire LDAP a échoué pour la récupération des groupes de l'utilisateur"));
                    }
                }
                $filtre =  "(" . $ldapParam["user_attrib"] . "=" . $_SESSION["login"] . ")";
                /*
                 * Attention : ne gere pas le cas de user_attrib vide lors d'une connexion a un Active Directory
                 *             avec le userPrincipalName (et eventuellement l'UPN Suffix defini)
                 */
                $dataLdap = $ldap->getAttributs($ldapParam["basedngroup"], $filtre, $attribut);
                if ($dataLdap["count"] > 0) {
                    $_SESSION["loginNom"] = $dataLdap[0][$ldapParam["commonNameAttrib"]][0];
                    $_SESSION["mail"] = $dataLdap[0][$ldapParam["mailAttrib"]][0];
                    /*
                     * Nettoyage des groupes (structure mixte)
                     */
                    $groups = $dataLdap[0][strtolower($ldapParam["groupAttrib"])];
                    foreach ($groups as $key => $value) {
                        if (is_numeric($key)) {
                            /*
                             * Recherche de l'identifiant du groupe
                             * Ajout du 29/11/16 : le meme groupe peut etre declare plusieurs fois
                             */
                            $search = $this->getGroupFromName($value);
                            foreach ($search as $value) {
                                if ($value["aclgroup_id"] > 0) {
                                    $groupesLdap[] = $value;
                                }
                            }
                        }
                    }
                }
            } else {
                throw new LdapException(_("Connexion à l'annuaire LDAP impossible"));
            }
        }
        /*
         * Fusion des groupes
         */
        $groupes = array_merge($groupes, $groupesLdap);
        /**
         * Récupération des groupes du serveur CAS
         */
        global $CAS_group_attribute, $CAS_get_groups;
        if (isset($_SESSION["CAS_attributes"][$CAS_group_attribute]) && $CAS_get_groups == 1) {
            $groupesCas = array();
            if (!is_array($_SESSION["CAS_attributes"][$CAS_group_attribute]) && !empty ($_SESSION["CAS_attributes"][$CAS_group_attribute])) {
                $_SESSION["CAS_attributes"][$CAS_group_attribute] = array($_SESSION["CAS_attributes"][$CAS_group_attribute]);
            }
            foreach ($_SESSION["CAS_attributes"][$CAS_group_attribute] as $value) {
                $search = $this->getGroupFromName($value);
                foreach ($search as $value) {
                    if ($value["aclgroup_id"] > 0) {
                        $groupesCas[] = $value;
                    }
                }
            }
            $groupes = array_merge($groupes, $groupesCas);
        }
        /*
         * Recuperation des groupes parents
         */
        foreach ($groupes as $key => $value) {
            if ($value["aclgroup_id_parent"] > 0) {
                $dataParent = $this->getParentGroups($value["aclgroup_id_parent"]);
                if (count($dataParent) > 0) {
                    $groupes = array_merge($groupes, $dataParent);
                }
            }
        }

        $_SESSION["groupes"] = $groupes;
        return $groupes;
    }

    /**
     * Fonction retournant tous les logins appartenant a un groupe
     *
     * @param unknown $groupe
     */
    function getLogins($groupe)
    {
        if (!empty($groupe)) {
            $sql = "with recursive first_level (login, groupe, aclgroup_id) as (
					(select login, 	groupe, aclgroup_id, aclgroup_id_parent
						from acllogin
						natural join acllogingroup
						natural join aclgroup
					)
					union all
					(select login, g.groupe, g.aclgroup_id, g.aclgroup_id_parent
						from first_level fl, aclgroup g
						where g.aclgroup_id = fl.aclgroup_id_parent)
					)
					select login from first_level
					where groupe = :groupe
					order by login";
            return $this->getListeParamAsPrepared($sql, array("groupe" => $groupe));
        }
    }

    /**
     * Retourne les groupes parents du groupe considere
     *
     * @param int $id
     * @return array
     */
    function getParentGroups($id)
    {
        $data = array();
        if ($id > 0) {
            $sql = "select aclgroup_id, aclgroup_id_parent, groupe from aclgroup
					where aclgroup_id = " . $id;
            $data = $this->getListeParam($sql);
            foreach ($data as $value) {
                if ($value["aclgroup_id_parent"] > 0) {
                    $dataParent = $this->getParentGroups($value["aclgroup_id_parent"]);
                    if (count($dataParent) > 0) {
                        $data = array_merge($data, $dataParent);
                    }
                }
            }
        }
        return $data;
    }

    /**
     * Recupere la liste des groupes, classes par arborescence
     *
     * @return array
     */
    function getGroups()
    {
        /*
         * Selection des groupes "racine"
         */
        $sql = "select aclgroup_id, groupe from aclgroup where aclgroup_id_parent is null
				order by groupe ";
        $group0 = $this->getListeParam($sql);
        $data = array();
        foreach ($group0 as $key => $value) {
            $data[] = array(
                "aclgroup_id" => $value["aclgroup_id"],
                "groupe" => $value["groupe"],
                "aclgroup_id_parent" => "",
                "level" => 0
            );
            /*
             * Recherche des groupes enfants
             */
            $dataChild = $this->getChildGroups($value["aclgroup_id"], 1);
            if (count($dataChild) > 0) {
                $data = array_merge($data, $dataChild);
            }
        }
        /*
         * Recuperation du nombre de logins associes par groupe
         */
        $sql = "select count(*) as nblogin, aclgroup_id
				from acllogingroup
				group by aclgroup_id";
        $nb = $this->getListeParam($sql);
        /*
         * Mise en forme du tableau
         */
        $datanb = array();
        foreach ($nb as $value) {
            $datanb[$value["aclgroup_id"]] = $value["nblogin"];
        }
        /*
         * Rajout du nombre a la liste
         */
        foreach ($data as $key => $value) {
            $data[$key]["nblogin"] = $datanb[$value["aclgroup_id"]];
        }
        return $data;
    }

    /**
     * Fonction récursive permettant de récupérer la liste des groupes inclus dans le groupe fourni
     *
     * @param int $parent_id
     * @param number $level
     * @return array:|NULL
     */
    private function getChildGroups($parent_id, $level = 1)
    {
        if ($parent_id > 0) {
            $data = array();
            $sql = "select aclgroup_id, groupe, aclgroup_id_parent from aclgroup
					where aclgroup_id_parent = :parent_id
				order by groupe ";
            $group = $this->getListeParamAsPrepared($sql, array("parent_id" => $parent_id));
            foreach ($group as $value) {
                $data[] = array(
                    "aclgroup_id" => $value["aclgroup_id"],
                    "groupe" => $value["groupe"],
                    "aclgroup_id_parent" => $value["aclgroup_id_parent"],
                    "level" => $level
                );
                /*
                 * Recuperation des enfants
                 */
                $dataChild = $this->getChildGroups($value["aclgroup_id"], $level + 1);
                if (count($dataChild) > 0) {
                    $data = array_merge($data, $dataChild);
                }
            }
            return $data;
        } else {
            return null;
        }
    }

    function getGroupFromName($groupName)
    {
        $sql = "select * from aclgroup where groupe = :groupName";
        return $this->getListeParamAsPrepared($sql, array("groupName" => $groupName));
    }

    /**
     * Surcharge de la fonction write pour ecrire les logins associes
     * (non-PHPdoc)
     *
     * @see ObjetBDD::write()
     */
    function ecrire($data)
    {
        if ($data["aclgroup_id"] > 0 && $data["aclgroup_id"] == $data["aclgroup_id_parent"]) {
            throw new DroitException(_("Un groupe ne peut être son propre parent"));
        }
        $id = parent::ecrire($data);
        if ($id > 0) {
            $this->ecrireTableNN("acllogingroup", "aclgroup_id", "acllogin_id", $id, $data["logins"]);
        }
        return $id;
    }

    /**
     * Surcharge de la fonction supprimer pour tester la presence de fils et supprimer
     * les logins rattaches
     * (non-PHPdoc)
     *
     * @see ObjetBDD::supprimer()
     */
    function supprimer($id)
    {
        if ($id > 0) {
            /*
             * Recherche de groupes fils
             */
            $dataFils = $this->getChildGroups($id);
            if (count($dataFils) > 0) {
                throw new DroitException(_("Suppression du groupe impossible : d'autres groupes lui sont rattachés"));
            } else {
                try {
                    /**
                     * Suppression des logins rattachés
                     */
                    $this->ecrireTableNN("acllogingroup", "aclgroup_id", "acllogin_id", $id, array());
                    /**
                     * Delete others records attached to the group
                     */
                    if (function_exists("deleteChildrenForGroup")) {
                        deleteChildrenForGroup($id);
                    }
                    return parent::supprimer($id);
                } catch (Exception $e) {
                    global $message;
                    $message->set(_("La suppression du groupe a échoué. Consultez les logs pour en connaître la raison"), true);
                    $message->setSyslog($e->getMessage());
                    return false;
                }
            }
        } else {
            return false;
        }
    }

    /**
     * Retourne la liste des groupes, avec l'attribut checked à 1 si
     * le groupe dispose de l'acl fourni en paramètre
     *
     * @param int $aclaco_id
     * @return number|NULL
     */
    function getGroupsFromAco($aclaco_id)
    {
        $data = $this->getGroups();
        if ($aclaco_id > 0) {
            /*
             * Recuperation des logins associes
             */
            $sql = "select aclgroup_id from aclacl where aclaco_id = :aclaco_id";
            $groupes = $this->getListeParamAsPrepared($sql, array("aclaco_id" => $aclaco_id));
            $dataGroup = array();
            /*
             * Preparation de la liste pour etre exploitable
             */
            foreach ($groupes as $value) {
                $dataGroup[$value["aclgroup_id"]] = 1;
            }
            /*
             * Rajout de l'information dans $data
             */
            foreach ($data as $key => $value) {
                $data[$key]["checked"] = $dataGroup[$value["aclgroup_id"]];
            }
        }
        return $data;
    }
}
