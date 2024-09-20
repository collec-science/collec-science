<?php
namespace Ppci\Models;
class Aclappli extends PpciModel
{

    function __construct()
    {
        $this->table = "aclappli";
        $this->fields = array(
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
        parent::__construct();
    }
}