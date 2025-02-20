<?php
namespace Ppci\Libraries;

class Dbparam extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataclass = new \Ppci\Models\Dbparam();        
    }
    function list()
    {
        $vue = service("Smarty");
        $vue->set($this->dataclass->getListe(2), "data");
		$vue->set("ppci/dbparamListChange.tpl", "corps");
        $vue->set($_SESSION["locale"], "locale");
        return $vue->send();
    }
    function writeGlobal() {
        try {
            $this->dataclass->ecrireGlobal($_REQUEST);
            $this->message->set(_("Enregistrement effectué"));
            /*
             * Reinitialisation de l'indicateur pour forcer le rechargement
             */
            $_SESSION["dbparamok"] = false;
            $this->log->setLog($_SESSION["login"], get_class($this->dataclass) . "-writeGlobal");
            return $this->list();
        } catch (\Exception $e) {
            $this->message->set(_("Problème lors de l'écriture dans la base de données"),true);
            $this->message->setSyslog($e->getMessage(),true);
            return $this->list();
        }
    }
}