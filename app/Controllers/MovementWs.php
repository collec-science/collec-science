<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\MovementWs as LibrariesMovementWs;
use CodeIgniter\API\ResponseTrait;
use CodeIgniter\RESTful\ResourceController;

class MovementWs extends ResourceController
{
    use ResponseTrait;
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesMovementWs();
    }
    function write()
    {
        ob_clean();
        return $this->respond($this->lib->write());
    }
}
