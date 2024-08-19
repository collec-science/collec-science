<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Xx extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $dataclass;

    private $keyName;

function __construct()
    {
        parent::__construct();
        $this->dataClass = new XXX();
        $this->keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

if ($_REQUEST["moduleFrom"] == "containerDisplay" && $_REQUEST["containerUid"] > 0) {
  $t_module["retourok"] = "containerDisplay";
  $_REQUEST["uid"] = $_REQUEST["containerUid"];
} else {
  $t_module["retourok"] = "sampleList";
}
$module_coderetour = 1;
