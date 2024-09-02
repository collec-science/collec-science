<?php

namespace App\Libraries;

use App\Libraries\Sample as LibrariesSample;
use App\Models\Collection;
use App\Models\Document as ModelsDocument;
use App\Models\MimeType;
use App\Models\Sample;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;



class Document extends PpciLibrary
{
	/**
	 * @var ModelsDocument
	 */
	protected PpciModel $dataclass;

	private $keyName;

	function __construct()
	{
		parent::__construct();
		$this->dataclass = new ModelsDocument();
		$this->keyName = "document_id";
		if (isset($_REQUEST[$this->keyName])) {
			$this->id = $_REQUEST[$this->keyName];
		}
	}

	function change()
	{
		$this->vue = service('Smarty');
		$this->dataRead($this->id, "gestion/documentChange.tpl", $_REQUEST["uid"]);
		/**
		 * Get the list of authorized extensions
		 */
		$mimeType = new MimeType();
		$this->vue->set($data = $mimeType->getListExtensions(false), "extensions");
		return $this->vue->send();
	}
	function write()
	{
		$writeOk = true;
		try {
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
					} else {
						$writeOk = false;
					}
				}
			}
		} catch (PpciException $e) {
			$this->message->set(_("Une erreur est survenue lors de l'écriture du document"), true);
			$this->message->set($e->getMessage());
			$this->message->setSyslog($e->getMessage());
		}
		return $writeOk;
	}

	function delete()
	{
		/*
		 * delete record
		 */
		try {
			$this->dataDelete($this->id);
			return true;
		} catch (PpciException $e) {
			$this->message->set($e->getMessage(), true);
			return false;
		}
	}
	function get()
	{
		/*
		 * Envoi du document au navigateur
		 * Generation du nom du document
		 */
		$this->vue = service("BinaryView");
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
			return $this->vue->send();
		}
	}
	function getSW()
	{
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
				throw new PpciException("Identifier not provided", 404);
			}
			empty($_REQUEST["uid"]) ? $uuid = $_REQUEST["uuid"] : $uuid = $_REQUEST["uid"];
			$data = $this->dataclass->getDetail($uuid, "uuid");
			if (count($data) == 0) {
				throw new PpciException("$uuid not found", 404);
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
				if (!$collectionOk) {
					throw new PpciException("Not sufficient rights for $uuid", 401);
				}
			} else {
				/**
				 * Verify if the collection is public
				 */
				$collection = new Collection();
				$dcollection = $collection->lire($data["collection_id"]);
				if (!$dcollection["public_collection"]) {
					throw new PpciException("Not a public collection for $uuid", 401);
				}
			}
			/**
			 * Get the content of the document
			 */
			$handle = $this->dataclass->getDocument($data["document_id"]);
			isset($_REQUEST["mode"]) ? $mode = $_REQUEST["mode"] : $mode = "inline";
			$this->vue = service("BinaryView");
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
		} catch (\Exception $e) {
			$error_code = $e->getCode();
			if ($error_code == 0) {
				$error_code = 520;
			}
			$data = array(
				"error_code" => $error_code,
				"error_message" => $e->getMessage()
			);
			$this->message->setSyslog($e->getMessage());
			return $this->getSWerror($data);
		}
	}

	function getSWerror($data)
	{
		$this->vue = service("AjaxView");
		$this->vue->set($data);
		return $this->vue->send();
	}
	function externalGetList()
	{
		/**
		 * Search the list of files into the external collection storage folder
		 * before associate files to the sample
		 */
		$listFiles = array();
		$this->vue = service("AjaxView");
		try {
			if ($_REQUEST["uid"] > 0) {
				/**
				 * Get the collection of the sample
				 */
				$sample = new Sample();
				$dsample = $sample->lire($_REQUEST["uid"]);
				if (!$sample->verifyCollection($dsample)) {
				}
			}
			$dir = $this->appConfig->external_document_path . "/" . $_SESSION["collections"][$dsample["collection_id"]]["external_storage_root"];
			if (strpos($_REQUEST["path"], "..")) {
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
		} catch (PpciException) {
		}

		helper('appfunctions');
		usort($listFiles, "cmp");
		$this->vue->set($listFiles);
		return $this->vue->send();
	}
	function externalAdd()
	{
		/**
		 * Add external files to the sample
		 */
		if ($_REQUEST["uid"] > 0) {
			/**
			 * Get the collection of the sample
			 */
			$sample = new Sample();
			$dsample = $sample->lire($_REQUEST["uid"]);
			try {
				if (!$sample->verifyCollection($dsample)) {
					throw new PpciException(_("Les droits ne sont pas suffisants pour l'échantillon considéré"));
				}
				foreach ($_REQUEST["files"] as $file) {
					/**
					 * Verify if the file exists
					 */
					if (!strpos($file, "..")) {
						$dir = $this->appConfig->external_document_path . "/" . $_SESSION["collections"][$dsample["collection_id"]]["external_storage_root"] . $file;
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
			} catch (PpciException $de) {
				$this->message->set($de->getMessage(), true);
			}
		}
		$sampleLib = new LibrariesSample;
		return $sampleLib->display();
	}
	function getExternal()
	{
		/**
		 * Send the file - vueBinaire
		 */
		$data = $this->dataclass->getDetail($this->id);
		helper("appfunctions");
		if (collectionVerify($data["collection_id"]) && $data["external_storage"] == 't') {
			$dir = $this->appConfig->external_document_path . "/" . $_SESSION["collections"][$data["collection_id"]]["external_storage_root"] . $data["external_storage_path"];
			$this->vue = service("BinaryView");
			$this->vue->setParam(
				array(
					"tmp_name" => $dir,
					"filename" => end(explode("/", $data["external_storage_path"])),
					"content_type" => $data["content_type"]
				)
			);
			return $this->vue->send();
		}
	}
}
