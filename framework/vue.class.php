<?php
/**
 * Created : 22 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
/**
 * Classe de gestion des messages generes
 * dans l'application
 * 
 * @author quinton
 *        
 */
class Message {
	/**
	 * Tableau contenant l'ensemble des messages generes
	 * 
	 * @var array
	 */
	private $message = array ();
	function set($value) {
		$this->message [] = $value;
	}
	/**
	 * Retourne le tableau brut
	 */
	function get() {
		return $this->message;
	}
	/**
	 * Retourne le tableau formate avec saut de ligne entre
	 * chaque message
	 * 
	 * @return string
	 */
	function getAsHtml() {
		$data = "";
		$i = 0;
		foreach ( $this->message as $value ) {
			if ($i > 0)
				$data .= "<br>";
			$data .= htmlentities ( $value );
			$i ++;
		}
		return $data;
	}
}
/**
 * Classe non instanciable de base pour l'ensemble des vues
 * 
 * @author quinton
 *        
 */
class Vue {
	/**
	 * Donnees a envoyer (cas hors html)
	 *
	 * @var array
	 */
	protected $data = array ();
	
	/**
	 * Assigne une valeur
	 * 
	 * @param unknown $value        	
	 * @param string $variable        	
	 */
	function set($value, $variable = "") {
		$this->data = $value;
	}
	/**
	 * Declenche l'affichage
	 * 
	 * @param string $param        	
	 */
	function send($param = "") {
	}
	/**
	 * Fonction recursive d'encodage html
	 * des variables
	 * 
	 * @param string|array $data        	
	 * @return string
	 */
	function encodehtml($data) {
		if (is_array ( $data )) {
			foreach ( $data as $key => $value ) {
				$data [$key] = $this->encodehtml ( $value );
			}
		} else {
			$data = htmlspecialchars ( $data );
		}
		return $data;
	}
}
/**
 * Classe encapsulant l'appel a Smarty
 * 
 * @author quinton
 *        
 */
class VueSmarty extends Vue {
	/**
	 * instance smarty
	 * 
	 * @var Smarty
	 */
	private $smarty;
	/**
	 * Tableau des variables ne devant pas etre encodees
	 * avant envoi au navigateur
	 * 
	 * @var array
	 */
	private $htmlVars = array (
			"menu",
			"LANG",
			"message",
			"texteNews",
			"doc",
			"phpinfo" 
	);
	private $templateMain = "main.htm";

	/**
	 * Constructeur
	 * @param array $param : liste des parametres specifiques d'implementation
	 * @param array $var : liste des variables assignees systematiquement
	 */
	function __construct($param, $var) {
		/*
		 * Parametrage de la classe smarty
		 */
		$this->smarty = new Smarty();
		$this->smarty->template_dir = $param["templates"];
		$this->smarty->compile_dir = $param["templates_c"];
		//$this->smarty->config_dir = $SMARTY_config;
		$this->smarty->cache_dir = $param["cache_dir"];
		$this->smarty->caching = $param["cache"];
		if (isset($param["template_main"]))
			$this->templateMain = $param["template_main"];
		/*
		 * Traitement des assignations de variables standard
		 */
		foreach($var as $key => $value)
			$this->set($value, $key);
	}
	/**
	 *
	 * {@inheritdoc}
	 *
	 * @see Vue::set()
	 */
	function set($value, $variable = "") {
		$this->smarty->assign ( $variable, $value );
	}
	/**
	 *
	 * {@inheritdoc}
	 *
	 * @see Vue::send()
	 */
	function send() {
		global $message;
		/*
		 * Encodage des donnees avant envoi vers le navigateur
		 */
		foreach ( $this->smarty->getTemplateVars () as $key => $value ) {
			if (in_array ( $key, $this->htmlVars ) == false) {
				$this->smarty->assign ( $key, $this->encodehtml ( $value ) );
			}
		}
		/*
		 * Rrecuperation des messages
		 */
		$this->smarty->assign("message", $message->getAsHtml());
		/*
		 * Declenchement de l'affichage
		 */
		$this->smarty->display ( $this->templateMain );
	}
}
/**
 * Classe permettant l'envoi d'un fichier Json au navigateur,
 * en protocole Ajax
 * 
 * @author quinton
 *        
 */
class VueAjaxJson extends Vue {
	/**
	 *
	 * {@inheritdoc}
	 *
	 * @see Vue::send()
	 */
	function send($param = "") {
		/*
		 * Encodage des donnees
		 */
		$data = array ();
		foreach ( $this->data as $key => $value )
			$data [$key] = $this->encodehtml ( $value );
			/*
		 * Envoi au navigateur
		 */
		ob_clean ();
		echo json_encode ( $data );
		ob_flush ();
	}
}
class VueCsv extends Vue {
	private $filename ;
	
	function send($param="") {
		if (count ( $this->data ) > 0) {
			if (strlen($param) == 0)
				$param = $this->filename;
			if (strlen($param) == 0) 
				$param = "export-".date('Y-m-d').".csv";
			/*
			 * Preparation du fichier
			 */
			ob_clean ();
			header ( 'Content-Type: text/csv' );
			header ( 'Content-Disposition: attachment;filename=' . $param );
			$fp = fopen ( 'php://output', 'w' );
			/*
			 * Traitement de l'entete
			 */
			fputcsv ( $fp, array_keys ( $this->data[0] ) );
			/*
			 * Traitement des lignes
			 */
			foreach ($this->data as $value)
				fputcsv($fp, $value);
			fclose ($fp);
			ob_flush ();
		}
	}
	/**
	 * Affecte le nom du fichier d'export
	 * @param string $filename
	 */
	function setFilename($filename) {
		$this->filename = $filename;
	}
}

class VuePdf extends Vue {
	private $filename ;
	private $disposition = "attachment";
	/**
	 * $disposition : attachment|inline
	 * {@inheritDoc}
	 * @see Vue::send()
	 */
	function send() {
		if (strlen($this->filename) > 0) {
			if (file_exists($this->filename)) {
				/*
				 * Recuperation du content-type
				 */
				$finfo = finfo_open(FILEINFO_MIME_TYPE);
				header('Content-Type: ' . finfo_file($finfo, $this->filename));
				finfo_close($finfo);
				
				/*
				 * Mise a disposition
				 */
				header('Content-Disposition: '.$this->disposition.'; filename="'.basename($this->filename).'"');
				
				/*
				 * Desactivation du cache
				 */
				header('Expires: 0');
				header('Cache-Control: must-revalidate');
				header('Pragma: public');
				header('Content-Length: ' . filesize($this->filename));
				
				ob_clean();
				flush();
				readfile($this->filename);
			}
		}
	}
	/**
	 * Affecte le nom du fichier d'export
	 * @param string $filename
	 */
	function setFilename($filename) {
		$this->filename = $filename;
	}
	/**
	 * Affecte la disposition du fichier dans le navigateur
	 * @param string $disp
	 */
	function setDisposition($disp="attachment") {
		$this->disposition = $disp;
	}
	
}
?>