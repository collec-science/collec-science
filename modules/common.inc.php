<?php
/**
 * Code execute systematiquement a chaque appel, apres demarrage de la session
 * Utilise notamment pour recuperer les instances de classes stockees en 
 * variables de session
 */
if (! isset ( $_SESSION ["searchContainer"] ))
	$_SESSION ["searchContainer"] = new SearchContainer ();
if (! isset ( $_SESSION ["searchSample"] ))
	$_SESSION ["searchSample"] = new SearchSample ();
	$vue->set($APPLI_titre , "APPLI_titre");
?>