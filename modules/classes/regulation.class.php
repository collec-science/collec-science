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
    /**
     * Get the list of all regulations
     * attached or not to a campaign
     *
     * @param int $campaign_id
     * @return array
     */
    function getAllForCampaign($campaign_id)
    {
        $sql = "select r.regulation_id, regulation_name, campaign_id
                from regulation r
                left outer join campaign_regulation cr on (
                    r.regulation_id = cr.regulation_id
                    and cr.campaign_id = :campaign_id)
                order by regulation_name";
        return $this->getListeParamAsPrepared($sql, array("campaign_id" => $campaign_id));
    }
    /**
     * Get the list of regulations attached to a campaign
     *
     * @param int $campaign_id
     * @return array
     */
    function getListFromCampaign($campaign_id)
    {
        $sql = "select regulation_id, regulation_name from regulation
                join campaign_regulation using (regulation_id)
                where campaign_id = :campaign_id
                order by regulation_name";
        return $this->getListeParamAsPrepared($sql, array("campaign_id" => $campaign_id));
    }
}
