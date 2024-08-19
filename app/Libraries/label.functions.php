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
/**
 * Created : 2 mai 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
if (isset($_REQUEST["label_id"])) {
    $this->vue->set($_REQUEST["label_id"], "label_id");
}
require_once 'modules/classes/label.class.php';
$label = new Label();
$this->vue->set($label->getListe(2), "labels");

require_once 'modules/classes/printer.class.php';
$printer = new Printer();
$this->vue->set($printer->getListe(2), "printers");
if (isset($_REQUEST["printer_id"])) {
    $this->vue->set($_REQUEST["printer_id"], "printer_id");
}
?>