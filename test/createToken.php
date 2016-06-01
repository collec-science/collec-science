<?php
include_once '../framework/identification/token.class.php';
/**
 * Pseudo-fonction pour demontrer la verification du login
 * @param string $login
 * @param string $password
 * @return boolean
 */
function verifyLogin($login, $password) {
	// script de verification du login
	return true;
}
/*
 * instanciation de la classe
 */
$tokenClass = new Token ();
if (! isset ( $_GET ["token"] ) && ! isset ( $_GET ["login"] )) {
	/*
	 * 1ere etape
	 * Formulaire de saisie du login
	 */
	echo '<html><form method="get" action="createToken.php">';
	echo 'login : <input name="login"><br>';
	echo 'password : <input type="password" name="password"><br>';
	echo '<input type="submit"></form></html>';
} else {
	if (isset ( $_GET ["login"] )) {
		/*
		 * 2nde etape
		 * generation du token et envoi au navigateur
		 */
		if (verifyLogin ( $_GET ["login"], $_GET ["password"] )) {
			
			try {
				/*
				 * Creation du token avec une duree de validite d'une heure
				 */
				$token = $tokenClass->createToken ( $_GET["login"], 3600 );
				echo $token."<br>";
				/*
				 * Preparation du formulaire de retour du test
				 */
				$contenu = json_decode ( $token, true );
				echo '<html><form method="get" action="createToken.php">';
				echo '<input name="token" value="' . $contenu ["token"] . '"><br>';
				echo '<input type="submit"></form></html>';
			} catch ( Exception $e ) {
				echo $e->getMessage ();
			}
		}
	} else {
		/*
		 * 3eme etape
		 * Traitement du token pour lire le contenu
		 */
		try {
			$login = $tokenClass->openToken ( $_GET ["token"] );
			echo "login : " . $login;
		} catch ( Exception $e ) {
			echo $e->getMessage ();
		}
	}
}


?>