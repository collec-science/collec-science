<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Protocol as LibrariesProtocol;

class Protocol extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesProtocol();
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
function file() {
return $this->lib->file();
}
}
