<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Odk as LibrariesOdk;
use App\Libraries\OdkLine;
use App\Libraries\OdkSampletype;
use App\Libraries\PpciExtends;
use Ppci\Libraries\PpciException;

class Odk extends PpciController
{
    /**
     * @var LibrariesOdk
     */
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesOdk();
    }
    function list()
    {
        return $this->lib->list();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            return $this->display();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            return $this->list();
        } else {
            return $this->change();
        }
    }
    function display()
    {
        return $this->lib->display();
    }
    function writeComp()
    {
        $this->lib->writeComp();
        return $this->display();
    }
    function sampletypeWrite()
    {
        $odkSampletype = new OdkSampletype;
        $odkSampletype->write();
        return $this->display();
    }
    function sampletypeDelete()
    {
        $odkSampletype = new OdkSampletype;
        $odkSampletype->delete();
        return $this->display();
    }

    function calculate()
    {
        $this->lib->calculate();
        return $this->display();
    }

    function spreadsheet()
    {
        if (!$this->lib->createSpreadsheet()) {
            return $this->display();
        }
    }

    function linesWrite()
    {
        $odkLine = new OdkLine;
        $odkLine->writeLines();
        return $this->display();
    }

    function duplicate()
    {
        $this->lib->duplicate();
        return $this->list();
    }

    function import()
    {
        return $this->lib->import();
    }
    function importExec()
    {
        try {
            $zipinfo = $this->extractZip();
            $this->lib->importExec($_POST["odk_id"], $zipinfo["folder"], $zipinfo["filename"]);
        } catch (PpciException $e) {
            $this->message->set($e->getMessage());
        }
    }

    /**
     * Extract the uploaded zip file
     */
    function extractZip(string $formname = "odkfile")
    {
        $file = $this->request->getFile($formname);
        if (! $file->isValid()) {
            throw new PpciException($file->getErrorString() . '(' . $file->getError() . ')');
        }
        $zip = new \ZipArchive;
        $app = service("AppConfig");
        if ($zip->open($file->getTempName())) {
            $target = $app->APP_temp . "/" . uniqid("odk");
            $zip->extractTo($target);
            $filename = $file->getBasename(".zip");
            $zip->close();
        } else {
            throw new PpciException(_("Le fichier zip n'a pas pu être décompressé"));
        }
        return ["filename"=>$filename, "folder"=>$target];
    }
}
