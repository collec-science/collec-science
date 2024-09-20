<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Structure as LibrariesStructure;

class Structure extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesStructure();
}
function html() {
return $this->lib->html();
}
function gacl() {
return $this->lib->gacl();
}
function latex() {
return $this->lib->latex();
}
function schema() {
return $this->lib->schema();
}
}
