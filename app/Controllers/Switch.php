<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Switch as LibrariesSwitch;

class Switch extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesSwitch();
}
function index() {
return $this->lib->index();
}
}
