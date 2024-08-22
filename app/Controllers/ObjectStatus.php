<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ObjectStatus as LibrariesObjectStatus;

class ObjectStatus extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesObjectStatus();
}
function list() {
return $this->lib->list();
}
function change() {
return $this->lib->change();
}
function write() {
return $this->lib->write();
}
}
