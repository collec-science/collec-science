<?php

namespace App\Controllers;

use App\Libraries\Document;
use CodeIgniter\API\ResponseTrait;
use CodeIgniter\RESTful\ResourceController;

class DocumentWs extends ResourceController
{
    use ResponseTrait;
    protected $lib;
    function __construct()
    {
        $this->lib = new Document;
    }
    function getDocument() {
        ob_clean();
        return $this->respond($this->lib->getSW());
    }
}