<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Subsample as LibrariesSubsample;

class Subsample extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesSubsample();
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
