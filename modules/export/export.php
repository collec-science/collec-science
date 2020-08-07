<?php
include_once 'modules/classes/export/export.class.php';
$dataClass = new Export($bdd, $ObjetBDDParam);
$keyName = "export_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
  case "change":
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
    dataRead($dataClass, $id, "export/exportChange.tpl", $_REQUEST["lot_id"]);
    require_once "modules/classes/export/lot.class.php";
    $lot = new Lot($bdd, $ObjetBDDParam);
    $vue->set($lot->getDetail($_REQUEST["lot_id"]), "lot");
    require_once "modules/classes/export/exportTemplate.class.php";
    $template = new ExportTemplate($bdd, $ObjetBDDParam);
    $vue->set($template->getListe("export_template_name"), "templates");
    break;
  case "write":
    /*
		 * write record in database
		 */
    $id = dataWrite($dataClass, $_REQUEST);
    if ($id > 0) {
      $_REQUEST[$keyName] = $id;
    }
    break;
  case "delete":
    /*
		 * delete record
		 */
    dataDelete($dataClass, $id);
    break;
  case "exec":
    /**
     * Get the record of the lot
     */
    include_once "modules/classes/export/lot.class.php";
    $lot = new Lot($bdd, $ObjetBDDParam);
    $dlot = $lot->lire($_REQUEST["lot_id"]);
    if ($dlot["collection_id"] > 0) {
      if (collectionVerify($dlot["collection_id"])) {
        try {
        $files = $dataClass->generate($id);
        /* Warning: only one file must be generated */
        if (file_exists($files[0]["filetmp"])) {
        /**
         * Get the contentType
         */
        include_once "modules/classes/document.class.php";
        $mimeType = new MimeType($bdd);
        $dmime = $mimeType->getTypeMime($files[0]["filetype"]);
        if ($dmime["mime_type_id"] > 0) {
          $param = array(
            "filename"=>$files[0]["filename"],
            "tmp_name"=>$files[0]["filetmp"],
            "content_type"=>$dmime["content_type"]
          );
          $vue->setParam($param);
        } else {
          throw new ExportException(sprintf(_("Le type mime pour l'extension %s n'a pas été décrit dans la base de données"), $files[0]["filetype"]));
        }
        } else {
          $message->set(_("Une erreur indéterminée s'est produite lors de la génération du fichier"), true);
          $module_coderetour = -1;
        }

        } catch (ExportException $e) {
          $message->set($e->getMessage, true);
          $module_coderetour = -1;
        }
      } else {
        $message->set(_("Vous ne disposez pas des droits suffisants sur la collection pour exporter le lot"), true);
        $module_coderetour = -1;
      }
    } else {
      $message->set(_("Le lot indiqué n'existe pas"), true);
      $module_coderetour = -1;
    }
    
    break;
}
