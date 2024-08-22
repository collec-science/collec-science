<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Lexique as LibrariesLexique;

class Lexique extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesLexique();
}
function index() {
return $this->lib->index();
}
}
