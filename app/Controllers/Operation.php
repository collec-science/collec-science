<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Operation as LibrariesOperation;

class Operation extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesOperation();
}
function list() {
return $this->lib->list();
}
function change() {
return $this->lib->change();
}
function copy() {
return $this->lib->copy();
}
function write() {
return $this->lib->write();
}
function delete() {
return $this->lib->delete();
}
}
