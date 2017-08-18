<?php
/*
 * Module d'affichage de la documentation
 * Permet d'afficher dans le menu l'ensemble de la documentation,
 * a partir d'une seule page.
 *
 * Gere l'internationalisation
 * Utilise egalement l'attribut param1 de actions.xml
 */
$handle = @fopen ( "doc/" . $language . "/" . $t_module ["param1"], "r" );
$doc = "";
if ($handle) {
	while ( ! feof ( $handle ) ) {
		$buffer = fgets ( $handle, 4096 );
		$doc .= $buffer;
	}
	fclose ( $handle );
}
$vue->set ( $doc, "doc" );
$vue->set ( "documentation/index.tpl", "corps" );

?>