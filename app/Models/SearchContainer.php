<?php 
namespace App\Models;

/**
 * Classe de recherche des contenants
 *
 * @author quinton
 *
 */
class SearchContainer extends SearchParam
{
    function __construct()
    {
        $this->param = array(
            "name" => "",
            "uidsearch" => "",
            "container_family_id" => "",
            "container_type_id" => "",
            "limit" => 100,
            "object_status_id" => 1,
            "uid_min" => 0,
            "uid_max" => 0,
            "select_date" => "",
            "date_from" => date($_SESSION["date"]["maskdate"]),
            "date_to" => date($_SESSION["date"]["maskdate"]),
            "trashed" => 0,
            "referent_id" => "",
            "event_type_id" => "",
            "movement_reason_id" => "",
            "collection_id" => ""
        );
        /**
         * Ajout des dates
         */
        $this->reinit();
        $this->paramNum = array(
            "container_family_id",
            "container_type_id",
            "limit",
            "object_status_id",
            "uidsearch",
            "uid_min",
            "uid_max",
            "trashed",
            "referent_id",
            "event_type_id",
            "movement_reason_id",
            "collection_id"
        );
        parent::__construct();
    }
    function reinit()
    {
        $ds = new \DateTime();
        $ds->modify("-1 year");
        $this->param["date_from"] = $ds->format($_SESSION["date"]["maskdate"]);
        $this->param["date_to"] = date($_SESSION["date"]["maskdate"]);
    }
}
