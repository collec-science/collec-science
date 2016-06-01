<?php
/**
 * class phpcas
 * classe simplifiée pour l'utilisation d'un serveur CAS
 *
 * @author Vivien Pochon
 * @version 1.0 01/06/2007
 */
class phpCAS {

	var $CAS_version;
	var $CAS_address;
	var $CAS_port;
	var $CAS_uri;
	var $user;

	function phpCAS() {

	}


	function setDebug(){

	}

	/**
	 * creer un client du server CAS
	 *
	 * @param version du serveur CAS
	 * @param adresse du serveur CAS
	 * @param port du serveur CAS
	 * @param uri du serveur CAS
	 */
	function client($CAS_version,$CAS_address,$CAS_port,$CAS_uri){

		$this->CAS_version=$CAS_version;
		$this->CAS_address=$CAS_address;
		$this->CAS_port=$CAS_port;
		$this->CAS_uri=$CAS_uri;
		

		$serviceCAS ='http://'.$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'];

		$url = explode("?", $serviceCAS);
		// récupération du ticket (retour du serveur CAS)
		if (!isset($_GET['ticket'])) {
			// pas de ticket : on redirige le navigateur web vers le serveur CAS
			$adresse = 'Location: https://'. $CAS_address.':'.$CAS_port.$CAS_uri . '/login?service='.$url[0];
			header($adresse);
			exit() ;

		}
	}

	/**
	 * Teste si l'authentification est correcte
	 *
	 * @return retourne TRUE si authentification correction, FALSE si incorrecte
	 */
	function forceAuthentication(){
		// un ticket a été transmis, on essaie de le valider auprès du serveur CAS
		$serviceCAS ='http://'.$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'];
		$url = explode("?", $serviceCAS);
		$file = 'https://'.$this->CAS_address.':'.$this->CAS_port.$this->CAS_uri . '/serviceValidate?service='.$url[0].'&ticket=' . $_GET['ticket'];
		$fpage = fopen ($file, 'r');
		if ($fpage) {

			while (!feof ($fpage)) { $page .= fgets ($fpage, 1024);}

			// analyse de la réponse du serveur CAS

			if (preg_match('|<cas:authenticationSuccess>.*</cas:authenticationSuccess>|mis',$page)) {

				if(preg_match('|<cas:user>(.*)</cas:user>|',$page,$match)){
				$this->user=$match[1];
				return TRUE;
				}

			}

		}
		return FALSE;
	}

	/**
	 * renvoie le login de l'utilisateur
	 *
	 * @return login
	 */
	function getUser(){
		return $this->user;
	}

	/**
	 * methode utilisée pour la deconnexion du serveur CAS
	 * @param chemin relatif de la page a transmettre au serveur CAS(qui apparaitra apres l'identification)
	 */
	function logout($url = "")
	{

		$cas_url='https://'.$this->CAS_address.':'.$CAS_port.$this->CAS_uri .'/logout';

   
		$base_url=explode("/",$_SERVER['REQUEST_URI'] );
		$base_url='http://'.$_SERVER['SERVER_NAME'].'/'.$base_url[1].'/';

		$url='?service='.$base_url.$url;
		header('Location: '.$cas_url . $url);

		session_unset();
		session_destroy();
		 
		$str='<html><head><title>__TITLE__</title></head><body><h1>__TITLE__</h1>';
		echo(str_replace('__TITLE__', "Deconnexion Demande",$str));

		$str='<p>Vous auriez du etre redirige vers le serveur CAS. Cliquez <a href="__CAS_URL__">ici</a></p>';
		echo(str_replace('__CAS_URL__', $cas_url, $str));

		$str='<hr><address>phpCAS __PHPCAS_VERSION__ utilisant le serveur <a href="__SERVER_BASE_URL__">__SERVER_BASE_URL__</a> (CAS __CAS_VERSION__)</a></address></body></html>';
		$str=(str_replace('__PHPCAS_VERSION__', $this->CAS_version, $str));
		$str=(str_replace('__SERVER_BASE_URL__', $this->CAS_address, $str));
		$str=(str_replace('__CAS_VERSION__', $this->CAS_version, $str));
		echo $str;
		exit();
	}

}
?>