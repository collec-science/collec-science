<?php 
namespace App\Models;

class SearchMovement extends SearchParam
{

    function __construct()
    {
        $this->param = array(
            "login" => ""
        );
        $this->reinit();
        parent::__construct();
    }

    function reinit()
    {
        $ds = new \DateTime();
        $ds->modify("-1 month");
        $this->param["date_start"] = $ds->format($_SESSION["date"]["maskdate"]);
        $this->param["date_end"] = date($_SESSION["date"]["maskdate"]);
    }
}
