<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\SampleWs as LibrariesSampleWs;

class SampleWs extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesSampleWs();
}
function detail() {
return $this->lib->detail();
}
function write() {
return $this->lib->write();
}
function delete() {
return $this->lib->delete();
}
function detail() {
return $this->lib->detail();
}
function getListUIDS() {
return $this->lib->getListUIDS();
}
function getList() {
return $this->lib->getList();
}
}
