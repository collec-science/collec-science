<?php
namespace Ppci\Libraries;

use Config\App;
use Ppci\Models\PpciModel;

class PpciLibrary
{
    protected $session;
    protected $message;
    protected PpciModel $dataClass;
    protected App $appConfig;
    protected $log;
    protected int $id;
    public $vue;
    protected PpciInit $init;

    function __construct()
    {
        $this->message = service('MessagePpci');
        //$this->init = service("PpciInit");
        $this->appConfig = config("App");
        $this->log = service("Log");
        //$this->init::Init();
    }

    /**
     * read data and assign it to Smarty
     * Assign template to Smarty
     *
     * @param [type] $id
     * @param [type] $smartyPage
     * @param integer $idParent
     * @return array
     */
    function dataRead($id, $smartyPage, $idParent = 0)
    {
        $this->vue = service("Smarty");
        try {
            $data = $this->dataClass->read($id, true, $idParent);
        } catch (\Exception $e) {
            $this->message->set(_("Erreur de lecture des informations dans la base de données"), true);
            $this->message->setSyslog($e->getMessage());
            throw new PpciException($e->getMessage());
        }
        /*
         * Affectation des donnees a smarty
         */
        $this->vue->set($data, "data");
        $this->vue->set($smartyPage, "corps");
        return $data;
    }
    function dataWrite(array $data, bool $isPartOfTransaction = false)
    {
        try {
            $id = $this->dataClass->write($data);
            if ($id > 0) {
                if (!$isPartOfTransaction) {
                    $this->message->set(_("Enregistrement effectué"));
                    $this->log->setLog($_SESSION["login"], get_class($this->dataClass) . "-write", $id);
                }
            } else {
                $this->message->set(
                    _(
                        "Un problème est survenu lors de l'enregistrement. Si le problème persiste, contactez votre support"
                    ),
                    true
                );
                $this->message->setSyslog(
                    sprintf(
                        _("La clé n'a pas été retournée lors de l'enregistrement dans %s"),
                        get_class($this->dataClass)
                    )
                );
                throw new PpciException();
            }
        } catch (\Exception $e) {
            if (strpos($e->getMessage(), "nique violation") !== false) {
                $this->message->set(
                    _("Un enregistrement portant déjà ce nom existe déjà dans la base de données."),
                    true
                );
            } else {
                $this->message->set($e->getMessage(), true);
            }
            $this->message->setSyslog($e->getMessage());
            throw new PpciException();
        }
        return $id;
    }

    function dataDelete($id, bool $isPartOfTransaction = false)
    {
        try {
            $ret = $this->dataClass->delete($id);
            if (!$isPartOfTransaction) {
                $this->message->set(_("Suppression effectuée"));
            }
            $this->log->setLog($_SESSION["login"], get_class($this->dataClass) . "-delete", $id);
            return true;
        } catch (\Exception $e) {
            $this->message->setSyslog($e->getMessage());
            /**
             * recherche des erreurs liees a une violation de cle etrangere
             */
            if (strpos($e->getMessage(), "[23503]") !== false) {
                $this->message->set(
                    _("La suppression n'est pas possible : des informations sont référencées par cet enregistrement"),
                    true
                );
            }
            if ($this->message->getMessageNumber() == 0) {
                $this->message->set(_("Problème lors de la suppression"), true);
            }
            $this->message->setSyslog($e->getMessage());
            if ($isPartOfTransaction) {
                throw new PpciException(sprintf("Suppression impossible de l'enregistrement %s"), $id);
            }
            return false;
        }
    }
}