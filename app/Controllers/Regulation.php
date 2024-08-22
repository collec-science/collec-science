<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Regulation as LibrariesRegulation;

class Regulation extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesRegulation();
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
function delete() {
return $this->lib->delete();
}
}
