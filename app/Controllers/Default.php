<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Default as LibrariesDefault;

class Default extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesDefault();
}
function index() {
return $this->lib->index();
}
}
