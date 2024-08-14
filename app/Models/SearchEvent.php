<?php

namespace App\Models;

class SearchEvent extends SearchParam
{

    function __construct()
    {
        $this->param = array(
            "is_done" => "0",
            "search_type" => "due_date",
            "collection_id" => 0,
            "event_type_id" => 0,
            "object_type_id" => 0,
            "object_type" => 1
        );
        $this->reinit();
        parent::__construct();
    }

    function reinit()
    {
        $ds = new \DateTime();
        $ds->modify("1 month");
        $this->param["date_to"] = $ds->format($_SESSION["date"]["maskdate"]);
        $ds->modify("-2 month");
        $this->param["date_from"] = $ds->format($_SESSION["date"]["maskdate"]);
        $this->param["search_type"] = "due_date";
    }
}
