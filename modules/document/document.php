<?php
/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2014, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 7 avr. 2014
 */
include_once 'modules/classes/document.class.php';
$dataClass = new DocumentAppli( $bdd, $ObjetBDDParam );
$keyName = "document_id";
$id = $_REQUEST [$keyName];

switch ($t_module ["param"]) {
	case "list" :
		break;
	case "display" :
		/*
		 * Exemple de code a inserer dans le module display de la table parente :
		 * 	
		 * Gestion des documents
		 */
		/*
		require_once 'modules/classes/document.class.php';
		$document = new DocumentLie($bdd, $ObjetBDDParam,"article");
		$smarty->assign("dataDoc", $document->getListeDocument($id));
		$smarty->assign("moduleParent", "articleDisplay");
		$smarty->assign("parentIdName", "article_id");
		$smarty->assign("parent_id", $id);
		$smarty->assign("parentType", "article");
		/*
		 * Dans le template d'affichage (fichier moduleDisplay.tpl), rajouter l'instruction suivante :
		 */
		/*
		<br>
		<fieldset>
		<legend>Documents associés</legend>
		{include file="document/documentList.tpl"}
		</fieldset>
		*/
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 * moduleParent : nom du module a rappeler apres enregistrement
		 * parentType : nom de la table à laquelle sont rattaches les documents
		 * parentIdName : nom de la cle de la table parente
		 * parent_id : cle de la table parente
		 */
		dataRead ( $dataClass, $id, "document/documentChange.tpl" );
		$smarty->assign ( "moduleParent", $_REQUEST ["moduleParent"] );
		$smarty->assign ( "parentType", $_REQUEST ["parentType"] );
		$smarty->assign ( "parentIdName", $_REQUEST ["parentIdName"] );
		$smarty->assign ( "parent_id", $_REQUEST ["parent_id"] );
		break;
	case "write":
		/*
		 * write record in database
		 */
		if (strlen ( $_REQUEST ["parentType"] ) > 0) {
			/*
			 * Preparation de files
			 */
			$files=array();
			$fdata=$_FILES['documentName'];
			if(is_array($fdata['name'])){
				for($i=0;$i<count($fdata['name']);++$i){
					$files[]=array(
							'name'    =>$fdata['name'][$i],
							'type'  => $fdata['type'][$i],
							'tmp_name'=>$fdata['tmp_name'][$i],
							'error' => $fdata['error'][$i],
							'size'  => $fdata['size'][$i],
							"document_id"=>$id
					);
				}
			}else $files[]=$fdata;
			foreach ( $files as $file ) {
				$id = $dataClass->ecrire ( $file, $_REQUEST ["document_description"] );
				if ($id > 0) {
					$_REQUEST [$keyName] = $id;
					/*
					 * Ecriture de l'enregistrement en table liee
					 */
					$documentLie = new DocumentLie ( $bdd, $ObjetBDDParam, $_REQUEST ["parentType"] );
					$data = array (
							"document_id" => $id,
							$_REQUEST["parentIdName"] => $_REQUEST ["parent_id"] 
					);
					$documentLie->ecrire ( $data );
				}
			}
			$log -> setLog($_SESSION["login"], get_class($dataClass)."-write",$id);
		}
		/*
		 * Retour au module initial
		 */
		$module_coderetour = 1;
		$t_module ["retourok"] = $_REQUEST['moduleParent'];
		$_REQUEST[$_REQUEST["parentIdName"]] = $_REQUEST["parent_id"];
		break;
	case "delete":
		/*
		 * Supprime la reference dans la table de lien
		 */
		$documentLie = new DocumentLie($bdd, $ObjetBDDParam, $_REQUEST["parentType"]);
		$documentLie->supprimer($id);
		/*
		 * delete record
		 */
		dataDelete ( $dataClass, $id );
		/*
		 * Retour au module initial
		*/
		$t_module ["retoursuppr"] = $_REQUEST['moduleParent'];
		$t_module ["retourok"] = $_REQUEST['moduleParent'];
		$t_module ["retourko"] = $_REQUEST['moduleParent'];
		$_REQUEST[$_REQUEST["parentIdName"]] = $_REQUEST["parent_id"];
		break;
	case "get":
		/*
		 * Envoie vers le navigateur le document
		 */
		$_REQUEST["attached"] = 1 ? $attached = true : $attached = false;
		$dataClass->documentSent( $id, $_REQUEST["phototype"], $attached);
		break;
}

?>