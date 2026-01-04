<?php

namespace App\Models;

use App\Models\Document as ModelsDocument;
use Ppci\Libraries\PpciException;
use Ppci\Models\Aclgroup;
use Ppci\Models\PpciModel;


class Campaign extends PpciModel
{
    private $sql = "select campaign_id, campaign_name, campaign_from, campaign_to,
                    referent_id, referent_name, referent_firstname, uuid, campaign_description
                    from campaign
                    left outer join referent using (referent_id)";
    private ModelsDocument $document;
    public Referent $referent;
    public Aclgroup $aclgroup;
    /**
     * __construct
     *
     * @param mixed $bdd
     * @param mixed $param
     *
     * @return mixed
     */
    function __construct()
    {
        $this->table = "campaign";
        $this->fields = array(
            "campaign_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "referent_id" => array("type" => 1),
            "campaign_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "campaign_from" => array("type" => 2),
            "campaign_to" => array("type" => 2),
            "uuid" => array("type" => 0),
            "campaign_description" => ["type" => 0]
        );
        parent::__construct();
    }

    /**
     * Get the detail of a campaign
     *
     * @param int $id
     * @return array
     */
    function getDetail($id)
    {
        $where = " where campaign_id = :id:";
        return $this->lireParamAsPrepared($this->sql . $where, array("id" => $id));
    }

    /**
     * overload of getListe to add the referent
     *
     * @param string $order
     * @return array
     */
    function getListe($order = ""): array
    {
        if (!empty($order)) {
            $order = " order by " . $order;
        }
        return $this->getListeParam($this->sql . $order);
    }

    /**
     * Overload supprimer function to delete all children of a campaign
     *
     * @param int $id
     * @return void
     */
    function supprimer($id)
    {
        if ($id > 0) {
            /**
             * Regulations
             */
            $sql = "delete from campaign_regulation
                    where campaign_id = :campaign_id:";
            $this->executeSql($sql, array("campaign_id" => $id),true);
            /**
             * Documents
             */
            if (!isset($this->document)) {
                $this->document = new ModelsDocument;
            }
            $this->document->deleteFromField($id, "campaign_id");
            parent::supprimer($id);
        }
    }
    /**
     * Get the campaign_id from its name
     *
     * @param string $name
     * @return integer|null
     */
    function getIdFromName(string $name): ?int
    {
        return $this->getId("campaign_name", $name);
    }
    /**
     * Get the id from uuid of t he campaign
     *
     * @param string $uuid
     * @return integer|null
     */
    function getIdFromUuid(string $uuid): ?int
    {
        return $this->getId("uuid", $uuid);
    }

    /**
     * Generic function for getting the id
     *
     * @param string $field
     * @param string $val
     * @return integer|null
     */
    function getId(string $field, string $val): ?int
    {
        $sql = "select campaign_id from campaign where $field = :name:";
        $data = $this->lireParamAsPrepared($sql, array("name" => $val));
        if (!empty($data)) {
            return $data["campaign_id"];
        } else {
            return NULL;
        }
    }
    function import(array $data)
    {
        if (empty($data["campaign_name"])) {
            throw new PpciException(_("Le nom de la campagne n'est pas indiqué"));
        }
        $id = $this->getIdFromName($data["campaign_name"]);
        if ($id > 0) {
            throw new PpciException(sprintf(_("La campagne %s existe déjà dans la base de données"), $data["campaign_name"]));
        }
        if (!empty($data["referent_name"])) {
            if (!isset($this->referent)) {
                $this->referent = new Referent;
            }
            $referents = $this->referent->getFromName($data["referent_name"], $data["referent_firstname"]);
            if (empty($referents)) {
                $referent_id = $this->referent->ecrire(
                    array(
                        "referent_id" => 0,
                        "referent_name" => $data["referent_name"],
                        "referent_firstname" => $data["referent_firstname"]
                    )
                );
            } else {
                $referent_id = $referents["referent_id"];
            }
            $data["referent_id"] = $referent_id;
        }
        $data["campaign_id"] = 0;
        $this->ecrire($data);
    }
    /**
     * Get the rights attributed to a campaign
     *
     * @param integer $id
     * @return array
     */
    function getRights(int $id): array
    {
        $sql = "select aclgroup_id, groupe 
                from campaign_group
                join aclgroup using (aclgroup_id)
                where campaign_id = :id:";
        return $this->getListeParamAsPrepared($sql, array("id" => $id));
    }
    /**
     * Get the list of groups associated or no to the campaign
     *
     * @param integer $id
     * @return array
     */
    function getAllGroupsFromCampaign(int $id): array
    {
        $data = $this->getRights($id);
        $dataGroup = array();
        foreach ($data as $value) {
            $dataGroup[$value["aclgroup_id"]] = 1;
        }
        if (!isset($this->aclgroup)) {
            $this->aclgroup = new Aclgroup;
        }
        $groupes = $this->aclgroup->getListe(2);
        foreach ($groupes as $key => $value) {
            $groupes[$key]["checked"] = $dataGroup[$value["aclgroup_id"]];
        }
        return $groupes;
    }
    /**
     * add the groups when write the data
     *
     * @param array $data
     * @return int
     */
    function write($data):int
    {
        $id = parent::write($data);
        if ($id > 0) {
            $this->ecrireTableNN("campaign_group", "campaign_id", "aclgroup_id", $id, $data["groupes"]);
        }
        return $id;
    }
}
