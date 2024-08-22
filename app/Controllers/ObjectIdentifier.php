<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ObjectIdentifier as LibrariesObjectIdentifier;

class ObjectIdentifier extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesObjectIdentifier();
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
