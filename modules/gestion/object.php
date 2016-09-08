<?php
/**
 * Created : 16 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/object.class.php';
$dataClass = new Object ( $bdd, $ObjetBDDParam );
$keyName = "uid";
$id = $_REQUEST [$keyName];
switch ($t_module ["param"]) {
	case "getDetailAjax" :
		/**
		 * Retourne le detail d'un objet a partir de son uid
		 * (independamment du type : sample ou container)
		 */
		$vue->set ( $dataClass->getDetail ( $id, $_REQUEST ["is_container"] ) );
		break;
	case "printLabel" :
		/*
		 * Test de generation des qrcodes
		 */
		$data = $dataClass->generateQrcode ( $_REQUEST ["uid"] );
		/*
		 * Generation du fichier xml
		 */
		if (count ( $data ) > 0) {
			try {
				$xml_id = bin2hex ( openssl_random_pseudo_bytes ( 6 ) );
				/*
				 * Preparation du fichier xml
				 */
				$doc = new DOMDocument ( '1.0', 'utf-8' );
				$objects = $doc->createElement ( "objects" );
				
				foreach ( $data as $object ) {
					$item = $doc->createElement ( "object" );
					foreach ( $object as $key => $value ) {
						if (strlen ( $key ) > 0 && strlen ( $value ) > 0) {
							$elem = $doc->createElement ( $key, $value );
							$item->appendChild ( $elem );
						}
					}
					$objects->appendChild ( $item );
				}
				$doc->appendChild ( $objects );
				$doc->save ( $APPLI_nomDossierStockagePhotoTemp . '/' . $xml_id . ".xml" );
				// $data = $dataClass->getForPrint ( $_REQUEST ["uid"] );
				$vue->set ( $data );
				$vue->setFilename ( "printlabel.csv" );
			} catch ( Exception $e ) {
				unset ( $vue );
				$module_coderetour = - 1;
				$message->set ( $e->getMessage () );
				if ($APPLI_modeDeveloppement == true)
					$message->set ( $e->getTraceAsString () );
			}
		} else {
			unset ( $vue );
			$module_coderetour = - 1;
		}
}
?>