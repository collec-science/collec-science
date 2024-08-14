<?php

namespace Ppci\Models;


/**
 * ORM de gestion de la table acllogin
 *
 * @author quinton
 *
 */
class Acllogin extends PpciModel
{

    function __construct()
    {
        $this->table = "acllogin";
        $this->fields = array(
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
            ),
            "totp_key" => array("type" => 0),
            "email" => ["type" => 0]
        );
        parent::__construct();
    }

    function delete($id = null, bool $purge = false)
    {
        /**
         * Delete from groups
         */
        $sql = "delete from acllogingroup where acllogin_id = :id:";
        $this->executeQuery($sql, ["id" => $id]);
        parent::delete($id);
    }
    function getListLogins()
    {
        $sql = "select acllogin_id, login, logindetail, email,
            case when totp_key is null then 0 else 1 end as totp_key
            from acllogin";
        return $this->getListeParam($sql);
    }

    /**
     * Retourne la liste des logins en indiquant s'ils sont ou non compris dans le groupe indiqué
     *
     * @param int $aclgroup_id
     * @return array
     */
    function getAllFromGroup($aclgroup_id)
    {
        $data = $this->getListe(3);
        if ($aclgroup_id > 0) {
            /*
             * Recuperation des logins associes
             */
            $sql = "select acllogin_id from acllogingroup where aclgroup_id = :id:";
            $logins = $this->getListeParam($sql, ["id" => $aclgroup_id]);
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
    function addLoginByLoginAndName($login, $name = null, $email = null)
    {
        if (is_null($name)) {
            $name = $login;
            $nameisnull = true;
        } else {
            $nameisnull = false;
        }
        if (!empty($login)) {
            /**
             * Recherche d'un login correspondant
             */
            $sql = "select acllogin_id, login, logindetail, email from acllogin where lower(login) = :login:";
            $data = $this->lireParamAsPrepared($sql, array("login" => strtolower($login)));
            if (!$data["acllogin_id"] > 0) {
                $data["acllogin_id"] = 0;
                $data["logindetail"] = $name;
            } else {
                if (!$nameisnull) {
                    $data["logindetail"] = $name;
                }
            }
            $data["login"] = strtolower($login);
            $data["email"] = strtolower($email);
            return $this->ecrire($data);
        } else {
            throw new \Ppci\Libraries\PpciException(_("L'ajout d'un login à la table des comptes (gestion des droits) n'est pas possible : le login n'est pas fourni"));
        }
    }
    /**
     * Surround of ecrire to reinit toip_key
     *
     * @param array $data
     * @return int
     */
    function ecrire(array $data): int
    {
        if ($data["totp_reset"] == 1) {
            $data["totp_key"] = "";
        }
        return parent::ecrire($data);
    }

    /**
     * Retourne la liste des droits attribues a un login
     *
     * @param string $login
     * @return array
     */
    function generateRights($login, $appli, $ldapParam = array())
    {
        $droits = array();
        if (!empty($login) && !empty($appli)) {
            /**
             * Recherche des groupes associes au login
             */
            $aclgroup = new Aclgroup();
            $groupes = $aclgroup->getGroupsFromLogin($login, $ldapParam);
            if (count($groupes) > 0) {
                /**
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
                    $droits[$value["aco"]] = 1;
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
        if (!empty($login)) {
            $sql = "select acllogin_id, login, logindetail, email from acllogin where lower(login) = :login:";
            return $this->lireParamAsPrepared($sql, array("login" => strtolower($login)));
        } else {
            return array();
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
            $sql = "delete from acllogingroup where acllogin_id = :id:";
            $this->executeQuery($sql, array("id" => $id));
            parent::supprimer($id);
            /*
             * Recherche s'il existe un login correspondant
             */
            $loginGestion = new LoginGestion();
            $dlg = $loginGestion->getFromLogin($data["login"]);
            if ($dlg["id"] > 0) {
                $loginGestion->supprimer($dlg["id"]);
            }
        }
    }
    /**
     * Search if the account use double authentification
     *
     * @return boolean
     */
    function isTotp(): bool
    {
        $isTotp = false;
        if (!empty($_SESSION["login"])) {
            $totpkey = $this->getTotpKey();
            if (!empty($totpkey)) {
                $isTotp = true;
            }
        }
        return $isTotp;
    }
    /**
     * Get the totp key for the current login
     *
     * @return string|null
     */
    function getTotpKey(): ?string
    {
        $sql = "select totp_key from acllogin where lower(login) = :login:";
        $data = $this->lireParamAsPrepared($sql, array("login" => $_SESSION["login"]));
        return ($data["totp_key"]);
    }
    /**
     * Retourne la liste des droits attribues a un login
     *
     * @param string $login
     * @return array
     */
    function getListDroits($login, $appli, $ldapParam = array())
    {
        $droits = array();
        if (!empty($login) && !empty($appli)) {
            $login = strtolower($login);
            /**
             * Recherche des groupes associes au login
             */
            $aclgroup = new Aclgroup();
            $groupes = $aclgroup->getGroupsFromLogin($login, $ldapParam);
            if (count($groupes) > 0) {
                /**
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
                    $droits[$value["aco"]] = 1;
                }
            }
        }
        return $droits;
    }
}
