<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Request as LibrariesRequest;

class Request extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesRequest();
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
function exec() {
return $this->lib->exec();
}
function execList() {
return $this->lib->execList();
}
function write() {
return $this->lib->write();
}
function copy() {
return $this->lib->copy();
}
}
