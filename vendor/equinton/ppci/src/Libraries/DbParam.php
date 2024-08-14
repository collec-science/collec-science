<?php
namespace Ppci\Libraries;

class Dbparam extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataClass = new \Ppci\Models\Dbparam();        
    }
    function list()
    {
        $vue = service("Smarty");
        $vue->set($this->dataClass->getListe(2), "data");
		$vue->set("ppci/dbparamListChange.tpl", "corps");
        $vue->set($_SESSION["locale"], "locale");
        return $vue->send();
    }
    function writeGlobal() {
        try {
            $this->dataClass->ecrireGlobal($_REQUEST);
            $this->message->set(_("Enregistrement effectué"));
            /*
             * Reinitialisation de l'indicateur pour forcer le rechargement
             */
            $_SESSION["dbparamok"] = false;
            $this->log->setLog($_SESSION["login"], get_class($this->dataClass) . "-writeGlobal");
            return $this->list();
        } catch (\Exception $e) {
            $this->message->set(_("Problème lors de l'écriture dans la base de données"),true);
            $this->message->setSyslog($e->getMessage());
            return $this->list();
        }
    }
}