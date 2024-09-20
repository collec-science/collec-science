<?php 
namespace App\Models;

class SearchSample extends SearchParam
{

    function __construct()
    {
        $this->param = array(
            "name" => "",
            "sample_type_id" => "",
            "collection_id" => "",
            "limit" => 100,
            "object_status_id" => 1,
            "uidsearch" => "",
            "uid_min" => 0,
            "uid_max" => 0,
            "sampling_place_id" => "",
            "metadata_field" => "",
            "metadata_value" => "",
            "select_date" => "",
            "referent_id" => "",
            "movement_reason_id" => "",
            "trashed" => 0,
            "SouthWestlon" => "",
            "SouthWestlat" => "",
            "NorthEastlon" => "",
            "NorthEastlat" => "",
            "campaign_id" => "",
            "country_id" => "",
            "country_origin_id" => "",
            "authorization_number" => "",
            "event_type_id" => "",
            "subsample_quantity_min" => "",
            "subsample_quantity_max" => "",
            "booking_type" => 0,
            "without_container" => 0,
            "collections" => array(),
            "metadatafilter" => ""
        );
        /**
         * Ajout des dates
         */
        $this->reinit();
        $this->paramNum = array(
            "sample_type_id" => 0,
            "collection_id",
            "object_status_id" => 1,
            "limit",
            "uidsearch",
            "uid_min",
            "uid_max",
            "sampling_place_id" => 0,
            "referent_id",
            "movement_reason_id",
            "trashed",
            "SouthWestlon",
            "SouthWestlat",
            "NorthEastlon",
            "NorthEastlat",
            "campaign_id",
            "country_id" => 0,
            "country_origin_id" => 0,
            "event_type_id",
            "subsample_quantity_min",
            "subsample_quantity_max",
            "booking_type" => 0,
            "without_container" => 0,
            "limit" => 100
        );
        $this->paramArray = array("collections");
        $this->paramCheckbox = array(
            "without_container" => 0
        );
        parent::__construct();
    }

    function reinit()
    {
        $ds = new \DateTime();
        $ds->modify("-1 year");
        $this->param["date_from"] = $ds->format($_SESSION["date"]["maskdate"]);
        $this->param["date_to"] = date($_SESSION["date"]["maskdate"]);
        $this->param["booking_from"] = date($_SESSION["date"]["maskdate"]);
        $this->param["booking_to"] = date($_SESSION["date"]["maskdate"]);
    }
}
