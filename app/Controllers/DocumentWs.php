<?php

namespace App\Controllers;

use App\Libraries\Document;
use App\Libraries\DocumentWs as LibrariesDocumentWs;
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
    function getListDocuments() {
        ob_clean();
        $documentWS = new LibrariesDocumentWs;
        return $this->respond($documentWS->getListFromObject());
    }
    function write() {
        ob_clean();
        $documentWS = new LibrariesDocumentWs;
        return $this->respond($documentWS->documentSet());
    }
}