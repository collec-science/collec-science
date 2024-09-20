<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\SampleWs as LibrariesSampleWs;
use App\Models\SearchSample;
use CodeIgniter\API\ResponseTrait;
use CodeIgniter\RESTful\ResourceController;

class SampleWs extends ResourceController
{
    use ResponseTrait;
    /**
     * @var SampleWs
     */
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesSampleWs();
        if (!isset($_SESSION["searchSample"])) {
            $_SESSION["searchSample"] = new SearchSample;
        }
        if (!empty($_SESSION["lastGet"])) {
            foreach ($_SESSION["lastGet"] as $k => $v) {
                if (!isset($_REQUEST[$k])) {
                    $_REQUEST[$k] = $v;
                }
                if (!isset($_GET[$k])) {
                    $_GET[$k] = $v;
                }
            }
        }
    }
    function detail()
    {
        ob_clean();
        return $this->respond($this->lib->detail());
    }
    function write()
    {
        ob_clean();
        return $this->respond($this->lib->write());
    }
    function supprimer()
    {
        ob_clean();
        return $this->respond($this->lib->delete());
    }
    function getListUIDS()
    {
        ob_clean();
        return $this->respond($this->lib->getListUIDS());
    }
    function getList()
    {
        $data = $this->lib->getList();
        ob_clean();
        return $this->respond($data);
    }
}
