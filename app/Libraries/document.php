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
 * @author Eric Quinton
 * @copyright Copyright (c) 2014, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 7 avr. 2014
 */
include_once 'modules/classes/document.class.php';
$this->dataclass = new Document();
$this->keyName = "document_id";
$this->id = $_REQUEST[$this->keyName];

	function change(){
$this->vue=service('Smarty');
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 * moduleParent : nom du module a rappeler apres enregistrement
		 * parentType : nom de la table à laquelle sont rattaches les documents
		 * parentIdName : nom de la cle de la table parente
		 * parent_id : cle de la table parente
		 */
		$this->dataRead( $this->id, "gestion/documentChange.tpl", $_REQUEST["uid"]);
		/**
		 * Get the list of authorized extensions
		 */
		$mimeType = new MimeType();
		$this->vue->set($data = $mimeType->getListExtensions(false), "extensions");
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
		/*
		 * Preparation de files
		 */
		$files = array();
		$fdata = $_FILES['documentName'];
		if (is_array($fdata['name'])) {
			for ($i = 0; $i < count($fdata['name']); ++$i) {
				$files[] = array(
					'name' => $fdata['name'][$i],
					'type' => $fdata['type'][$i],
					'tmp_name' => $fdata['tmp_name'][$i],
					'error' => $fdata['error'][$i],
					'size' => $fdata['size'][$i]
				);
			}
		} else {
			$files[] = $fdata;
		}
		!empty($_REQUEST["parentKeyName"]) ? $parentKeyName = $_REQUEST["parentKeyName"] : $parentKeyName = "uid";
		if (isset($_REQUEST["uids"]) && $parentKeyName == "uid" && count($_REQUEST["uids"]) > 0) {
			$keys = $_REQUEST["uids"];
		} else {
			$keys = array($_REQUEST[$parentKeyName]);
		}
		foreach ($keys as $key) {
			foreach ($files as $file) {
				$this->id = $this->dataclass->documentWrite($file, $parentKeyName, $key, $_REQUEST["document_description"], $_REQUEST["document_creation_date"]);
				if ($this->id > 0) {
					$_REQUEST[$this->keyName] = $this->id;
					$module_coderetour = 1;
				} else {
					$module_coderetour = -1;
				}
			}
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
	function get() {
		/*
		 * Envoi du document au navigateur
		 * Generation du nom du document
		 */
		$tmp_name = $this->dataclass->prepareDocument($this->id, $_REQUEST["phototype"]);
		if (!empty($tmp_name) && is_file($tmp_name)) {
			/*
			 * Recuperation du type mime
			 */
			$data = $this->dataclass->getData($this->id);
			$param = array("tmp_name" => $tmp_name, "content_type" => $data["content_type"]);
			if ($_REQUEST["attached"] == 1) {
				$param["disposition"] = "attachment";
				$fn = explode('/', $tmp_name);
				$param["filename"] = $fn[count($fn) - 1];
			} else {
				$param["disposition"] = "inline";
			}
			$this->vue->setParam($param);
		} else {
			unset($this->vue);
			$module_coderetour = -1;
		}
		}
	function getSW() {
		/**
		 * Get the document from a web service or direct request
		 */
		$errors = array(
			500 => "Internal Server Error",
			401 => "Unauthorized",
			520 => "Unknown error",
			404 => "Not Found"
		);
		try {
			if (empty($_REQUEST["uid"]) && empty($_REQUEST["uuid"])) {
				throw new DocumentException("Identifier not provided", 404);
			}
			empty($_REQUEST["uid"]) ? $uuid = $_REQUEST["uuid"] : $uuid = $_REQUEST["uid"];
			$data = $this->dataclass->getDetail($uuid, "uuid");
			if (count($data) == 0) {
				throw new SampleException("$uuid not found", 404);
			}
			/**
			 * Search for collection
			 */
			if (isset($_SESSION["login"])) {
				$collectionOk = false;
				foreach ($_SESSION["collections"] as $value) {
					if ($data["collection_id"] == $value["collection_id"]) {
						$collectionOk = true;
						}
					}
				}
				if (!$collectionOk) {
					throw new DocumentException("Not sufficient rights for $uuid", 401);
				}
			} else {
				/**
				 * Verify if the collection is public
				 */
				require_once "modules/classes/collection.class.php";
				$collection = new Collection();
				$dcollection = $collection->lire($data["collection_id"]);
				if (!$dcollection["public_collection"]) {
					throw new DocumentException("Not a public collection for $uuid", 401);
				}
			}
			/**
			 * Get the content of the document
			 */
			$handle = $this->dataclass->getDocument($data["document_id"]);
			isset($_REQUEST["mode"]) ? $mode = $_REQUEST["mode"] : $mode = "inline";
			$this->vue->setParam(
				array(
					"filename" => $data["document_name"],
					"tmp_name" => $handle,
					"content_type" => $data["content_type"],
					"disposition" => $mode,
					"is_reference" => true,
					"handle" => $handle
				)
			);
		} catch (Exception $e) {
			$error_code = $e->getCode();
			if ($error_code == 0) {
				$error_code = 520;
			}
			$data = array(
				"error_code" => $error_code,
				"error_message" => $e->getMessage()
			);
			$module_coderetour = -1;
			$this->message->setSyslog($e->getMessage());
		}
		}
	function getSWerror() {
		$this->vue->set($data);
		}
	function externalGetList() {
		/**
		 * Search the list of files into the external collection storage folder
		 * before associate files to the sample
		 */
		if ($_REQUEST["uid"] > 0) {
			/**
			 * Get the collection of the sample
			 */
			include_once "modules/classes/sample.class.php";
			$sample = new Sample();
			$dsample = $sample->lire($_REQUEST["uid"]);
			if (!$sample->verifyCollection($dsample)) {
				}
			}
			$listFiles = array();
			$dir = $APPLI_external_document_path . "/" . $_SESSION["collections"][$dsample["collection_id"]]["external_storage_root"];
			if (strpos($_REQUEST["path"], "..")) {
				}
			}
			if (!empty($_REQUEST["path"]) && $_REQUEST["path"] != "#") {
				$dir .= $_REQUEST["path"];
			}
			$localPath = str_replace(array("..", "//"), array("", "/"), $_REQUEST["path"]);

			if (is_dir($dir) && !is_link($dir)) {
				if ($dh = opendir($dir)) {
					while (($file = readdir($dh)) !== false) {
						if ($file != ".." && $file != ".") {
							$f = array("name" => $file, "id" => str_replace("/", "", $localPath . "-" . $file), "value" => $localPath . '/' . $file, "folder" => false);
							if (filetype($dir . "/" . $file) == "dir") {
								$f["folder"] = true;
							}

							$listFiles[] = $f;
						}
					}
				}
			}
		}
		/**
		 * Sort list files on name
		 *
		 * @param string $a
		 * @param string $b
		 * @return int
		 */
		function cmp($a, $b)
		{
			return strcmp($a["name"], $b["name"]);
		}
		usort($listFiles, "cmp");
		$this->vue->set($listFiles);
		}
	function externalAdd() {
		/**
		 * Add external files to the sample
		 */
		if ($_REQUEST["uid"] > 0) {
			/**
			 * Get the collection of the sample
			 */
			include_once "modules/classes/sample.class.php";
			$sample = new Sample();
			$dsample = $sample->lire($_REQUEST["uid"]);
			try {
				if (!$sample->verifyCollection($dsample)) {
					throw new DocumentException(_("Les droits ne sont pas suffisants pour l'échantillon considéré"));
				}
				foreach ($_REQUEST["files"] as $file) {
					/**
					 * Verify if the file exists
					 */
					if (!strpos($file, "..")) {
						$dir = $APPLI_external_document_path . "/" . $_SESSION["collections"][$dsample["collection_id"]]["external_storage_root"] . $file;
						$dir = str_replace("//", "/", $dir);
						if (is_file($dir) && !is_link($dir)) {
							$dfile = array(
								"document_id" => 0,
								"uid" => $_REQUEST["uid"],
								"external_storage_path" => str_replace("//", "/", $file),
								"document_description" => $_REQUEST["document_description"],
								"document_creation_date" => $_REQUEST["document_creation_date"]
							);
							$this->dataclass->writeExternal($dsample["collection_id"], $dfile);
						}
					}
				}
				$module_coderetour = 1;
			} catch (DocumentException $de) {
				$this->message->set($de->getMessage(), true);
				$module_coderetour = -1;
			}
		}
		}
	function getExternal() {
		/**
		 * Send the file - vueBinaire
		 */
		$data = $this->dataclass->getDetail($this->id);
		if (collectionVerify($data["collection_id"]) && $data["external_storage"] == 1) {
			$dir = $APPLI_external_document_path . "/" . $_SESSION["collections"][$data["collection_id"]]["external_storage_root"] . $data["external_storage_path"];
			$this->vue->setParam(
				array(
					"tmp_name" => $dir,
					"filename" => end(explode("/", $data["external_storage_path"])),
					"content_type" => $data["content_type"]
				)
			);
		}
		}
}
