<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class CollectionsGenerateMail extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $dataclass;

    

function __construct()
    {
        parent::__construct();
        $this->dataclass = new XXX();
        $this->keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
$_REQUEST["module"] = "collectionsGenerateMail";
include "framework/controller.php";