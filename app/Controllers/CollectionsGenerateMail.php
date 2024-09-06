<?php

namespace App\Controllers;

use App\Libraries\Collection;
use CodeIgniter\Controller;

class CollectionsGenerateMail extends Controller
{
    public function index()
    {
        $lib = new Collection;
        return $lib->generateMails();
    }
}
