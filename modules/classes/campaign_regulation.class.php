<?php

class CampaignRegulation extends ObjetBDD
{
    private $sql = "select campaign_regulation_id, campaign_id, regulation_id
                    ,authorization_number, authorization_date
                    ,regulation_name
                    from campaign_regulation
                    join regulation using (regulation_id)";
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
        $this->table = "campaign_regulation";
        $this->colonnes = array(
            "campaign_regulation_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "campaign_id" => array("type" => 1, "parentAttrib"=>1, "requis"=>1),
            "regulation_id" =>array("type"=>1, "requis"=>1),
            "authorization_number" => array("type" => 0),
            "authorization_date" => array("type" => 2)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Get the list of regulations from a campaign
     *
     * @param integer $campaign_id
     * @return array
     */
    function getListFromCampaign (int $campaign_id): array {
      $data = array();
      $where = " where campaign_id = :campaign_id";
      $data = $this->getListeParamAsPrepared($this->sql.$where, array("campaign_id"=>$campaign_id));
      return $data;
    }
}
