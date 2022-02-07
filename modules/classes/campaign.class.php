<?php
class Campaign extends ObjetBDD
{
    private $sql = "select campaign_id, campaign_name, campaign_from, campaign_to,
                    referent_id, referent_name, uuid
                    from campaign
                    left outer join referent using (referent_id)";
    private $document;
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
            "referent_id" => array("type" => 1),
            "campaign_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "campaign_from" => array("type" => 2),
            "campaign_to" => array("type" => 2),
            "uuid" => array("type" => 0, "default" => "getUUID")
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Get the detail of a campaign
     *
     * @param int $id
     * @return array
     */
    function getDetail($id)
    {
        $where = " where campaign_id = :id";
        return $this->lireParamAsPrepared($this->sql . $where, array("id" => $id));
    }

    /**
     * overload of getListe to add the referent
     *
     * @param string $order
     * @return array
     */
    function getListe($order = "")
    {
        if (strlen($order) > 0) {
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
                    where campaign_id = :campaign_id";
            $this->executeAsPrepared($sql, array("campaign_id" => $id));
            /**
             * Documents
             */
            if (!isset($this->document)) {
                include_once "modules/classes/document.class.php";
                $this->document = new Document($this->connection, $this->paramori);
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
        $sql = "select campaign_id from campaign where $field = :name";
        $data = $this->lireParamAsPrepared($sql, array("name" => $$val));
        if (!empty($data)) {
            return $data["campaign_id"];
        } else {
            return NULL;
        }
    }
}
