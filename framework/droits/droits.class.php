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

/**
 * ORM de gestion de la table acllogin
 *
 * @author quinton
 *        
 */
class Acllogin extends ObjetBDD
{

    function __construct($bdd, $param = array())
    {
        $this->table = "acllogin";
        $this->colonnes = array(
            "acllogin_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "login" => array(
                "requis" => 1
            ),
            "logindetail" => array(
                "type" => 0,
                "requis" => 1
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Retourne la liste des logins en indiquant s'ils sont ou non compris dans le groupe indiqué
     *
     * @param int $aclgroup_id
     * @return tableau|NULL
     */
    function getAllFromGroup($aclgroup_id)
    {
        $data = $this->getListe(3);
        if ($aclgroup_id > 0) {
            /*
             * Recuperation des logins associes
             */
            $sql = "select acllogin_id from acllogingroup where aclgroup_id = " . $aclgroup_id;
            $logins = $this->getListeParam($sql);
            $dataGroup = array();
            /*
             * Preparation de la liste pour etre exploitable
             */
            foreach ($logins as $key => $value) {
                $dataGroup[$value["acllogin_id"]] = 1;
            }
            /*
             * Rajout de l'information dans $data
             */
            foreach ($data as $key => $value) {
                $data[$key]["checked"] = $dataGroup[$value["acllogin_id"]];
            }
        }
        return $data;
    }

    /**
     * Ajoute ou modifie un login directement
     * Fonction créée pour alimenter les logins directement depuis la saisie des comptes
     *
     * @param string $login
     * @param string $name
     * @return int|void
     */
    function addLoginByLoginAndName($login, $name)
    {
        $login = $this->encodeData($login);
        $name = $this->encodeData($name);
        if (strlen($login) > 0 && strlen($name) > 0) {
            /*
             * Recherche d'un login correspondant
             */
            $sql = "select * from " . $this->table . " where login = '" . $login . "'";
            $data = $this->lireParam($sql);
            if (!$data["acllogin_id"] > 0) {
                $data["acllogin_id"] = 0;
            }
            $data["login"] = $login;
            $data["logindetail"] = $name;
            return $this->ecrire($data);
        } else {
            throw new ObjetBDDException(_("L'ajout d'un login à la table des comptes (gestion des droits) n'est pas possible : le login ou le nom ne sont pas fournis"));
        }
    }

    /**
     * Retourne la liste des droits attribues a un login
     *
     * @param unknown $login
     * @return array
     */
    function getListDroits($login, $appli, $ldapParam = array())
    {
        $droits = array();
        if (strlen($login) > 0 && strlen($appli) > 0) {
            $login = $this->encodeData($login);
            $appli = $this->encodeData($appli);
            /*
             * Recherche des groupes associes au login
             */
            $aclgroup = new Aclgroup($this->connection, $this->paramori);
            $groupes = $aclgroup->getGroupsFromLogin($login, $ldapParam);
            if (count($groupes) > 0) {
                /*
                 * Recherche des droits. Preparation de la clause IN
                 */
                $inclause = "";
                $comma = false;
                foreach ($groupes as $value) {
                    if ($value["aclgroup_id"] > 0) {
                        if ($comma) {
                            $inclause .= ", ";
                        } else {
                            $comma = true;
                        }
                        $inclause .= $value["aclgroup_id"];
                    }
                }
                $sql = "select distinct aco 
					from aclaco 
					join aclacl on (aclaco.aclaco_id = aclacl.aclaco_id)
					join aclappli on (aclappli.aclappli_id = aclaco.aclappli_id)
					where aclgroup_id in (" . $inclause . ")
					and appli = '" . $appli . "' 
					order by aco";
                $data = $this->getListeParam($sql);
                /*
                 * Mise en forme des droits
                 */
                $droits = array();
                foreach ($data as $value) {
                    $droits[$value[aco]] = 1;
                }
            }
        }
        return $droits;
    }
    /**
     * Retourne l'enregistrement correspondant au login
     * @param string $login
     * @return array
     */
    function getFromLogin($login)
    {
        if (strlen($login) > 0) {
            $sql = "select * from " . $this->table . " where login = :login";
            return $this->lireParamAsPrepared($sql, array("login" => $login));
        }
    }

    /**
     * Surcharge de la fonction supprimer pour effacer le login, s'il existe
     * {@inheritDoc}
     * @see ObjetBDD::supprimer()
     */
    function supprimer($id)
    {
        if ($id > 0) {
            /*
             * Lecture des donnees
             */
            $data = $this->lire($id);
            /*
             * Suppression du login dans les groupes
             */
            $sql = "delete from acllogingroup where acllogin_id = :id";
            $this->executeAsPrepared($sql, array("id" => $id));
            parent::supprimer($id);
            /*
             * Recherche s'il existe un login correspondant
             */
            require_once 'framework/identification/loginGestion.class.php';
            $loginGestion = new LoginGestion($this->connection, $this->paramori);
            $dlg = $loginGestion->getFromLogin($data["login"]);
            if ($dlg["id"] > 0) {
                $loginGestion->supprimer($dlg["id"]);
            }
        }
    }
}

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
        if (strlen($login) > 0) {
            $login = $this->encodeData($login);

            $sql = "select g.aclgroup_id, groupe, aclgroup_id_parent
					from " . $this->table . " g 
					join acllogingroup lg on (g.aclgroup_id = lg.aclgroup_id)
					join acllogin l on (lg.acllogin_id = l.acllogin_id)
					where login = '" . $login . "'";
            $groupes = $this->getListeParam($sql);
        }
        /*
         * Recherche des groupes LDAP
         */
        $groupesLdap = array();
        if ($ldapParam["groupSupport"]) {
            /*
             * Recuperation des attributs depuis l'annuaire LDAP
             * Attention : interroge l'annuaire en mode anonyme 
             -             et donc echoue si l'annuaire requiere un login/mot de passe pour une recherche
             */
            include_once "framework/ldap/ldap.class.php";
            $ldap = new Ldap($ldapParam["address"], $ldapParam["basedn"]);
            $conn = $ldap->connect();
            if ($conn > 0) {
                $attribut = array(
                    $ldapParam['commonNameAttrib'],
                    $ldapParam["mailAttrib"],
                    $ldapParam["groupAttrib"]
                );
                $filtre = "(" . $ldapParam["user_attrib"] . "=" . $_SESSION["login"] . ")"; // Attention...
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
                    $groups = $dataLdap[0][$ldapParam["groupAttrib"]];
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
                throw new LdapException("Connexion à l'annuaire LDAP impossible");
            }
        }
        /*
         * Fusion des groupes
         */
        $groupes = array_merge($groupes, $groupesLdap);
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
        if (strlen($groupe) > 0) {
            $groupe = $this->encodeData($groupe);
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
					where groupe = '" . $groupe . '"
					order by login';
            return $this->getListeParam($sql);
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
        $sql = "select aclgroup_id, groupe from " . $this->table . " where aclgroup_id_parent is null
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
            $sql = "select aclgroup_id, groupe, aclgroup_id_parent from " . $this->table . " 
					where aclgroup_id_parent = " . $parent_id . "
				order by groupe ";
            $group = $this->getListeParam($sql);
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
        $sql = "select * from aclgroup where groupe = '$groupName'";
        return $this->getListeParam($sql);
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
                /*
                 * Suppression des logins rattachés
                 */
                $this->ecrireTableNN("acllogingroup", "aclgroup_id", "acllogin_id", $id, array());
                return parent::supprimer($id);
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
            $sql = "select aclgroup_id from aclacl where aclaco_id = " . $aclaco_id;
            $groupes = $this->getListeParam($sql);
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

?>