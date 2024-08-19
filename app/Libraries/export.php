<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Xx extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $dataclass;

    private $keyName;

function __construct()
    {
        parent::__construct();
        $this->dataClass = new XXX();
        $this->keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
/**
 *
 */
include_once 'modules/classes/export/export.class.php';
$this->dataclass = new Export();
$this->keyName = "export_id";
$this->id = $_REQUEST[$this->keyName];


  function change(){
$this->vue=service('Smarty');
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
    $this->dataRead( $this->id, "export/exportChange.tpl", $_REQUEST["lot_id"]);
     require_once "modules/classes/export/lot.class.php";
    $lot = new Lot();
    $this->vue->set($lot->getDetail($_REQUEST["lot_id"]), "lot");
    require_once "modules/classes/export/exportTemplate.class.php";
    $template = new ExportTemplate();
    $this->vue->set($template->getListe("export_template_name"), "templates");
    }
      function write() {
    try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return $this->display();
            } else {
                return $this->change();
            }
        } catch (PpciException) {
            return $this->change();
        }
    }
    /*
		 * write record in database
		 */
    $this->id = $this->dataWrite( $_REQUEST);
    if ($this->id > 0) {
      $_REQUEST[$this->keyName] = $this->id;
    }
    }
  function delete(){
    /*
		 * delete record
		 */
     try {
            $this->dataDelete($this->id);
            return $this->list();
        } catch (PpciException $e) {
            return $this->change();
        }
    }
  function exec() {
    /**
     * Get the record of the lot
     */
    include_once "modules/classes/export/lot.class.php";
    $lot = new Lot();
    $dlot = $lot->lire($_REQUEST["lot_id"]);
    if ($dlot["collection_id"] > 0) {
      if (collectionVerify($dlot["collection_id"])) {
        try {
          $files = $this->dataclass->generate($this->id);
          /* Warning: only one file must be generated */
          if (file_exists($files[0]["filetmp"])) {
            /**
             * Get the contentType
             */
            include_once "modules/classes/document.class.php";
            $mimeType = new MimeType();
            $type_mime_id = $mimeType->getTypeMime($files[0]["filetype"]);
            if ($type_mime_id > 0) {
              $dmime = $mimeType->lire($type_mime_id);
              $param = array(
                "filename" => $files[0]["filename"],
                "tmp_name" => $files[0]["filetmp"],
                "content_type" => $dmime["content_type"]
              );
              $this->vue->setParam($param);
              /**
               * Update the export date
               */
              $this->dataclass->updateExportDate($this->id);
            } else {
              throw new ExportException(sprintf(_("Le type mime pour l'extension %s n'a pas été décrit dans la base de données"), $files[0]["filetype"]));
            }
          } else {
            $this->message->set(_("Une erreur indéterminée s'est produite lors de la génération du fichier"), true);
            $module_coderetour = -1;
          }
        } catch (ExportException $e) {
          $this->message->set($e->getMessage(), true);
          $module_coderetour = -1;
        }
      } else {
        $this->message->set(_("Vous ne disposez pas des droits suffisants sur la collection pour exporter le lot"), true);
        $module_coderetour = -1;
      }
    } else {
      $this->message->set(_("Le lot indiqué n'existe pas"), true);
      $module_coderetour = -1;
    }

    }
}
