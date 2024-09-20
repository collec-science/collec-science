<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\SamplingPlace as LibrariesSamplingPlace;

class SamplingPlace extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesSamplingPlace();
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
function import() {
return $this->lib->import();
}
function getFromCollection() {
return $this->lib->getFromCollection();
}
function getCoordinate() {
return $this->lib->getCoordinate();
}
}
