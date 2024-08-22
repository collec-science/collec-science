<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Referent as LibrariesReferent;

class Referent extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesReferent();
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
function getFromName() {
return $this->lib->getFromName();
}
function getFromId() {
return $this->lib->getFromId();
}
function copy() {
return $this->lib->copy();
}
}