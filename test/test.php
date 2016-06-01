<?php
/**
 * @author Eric Quinton
 * 11 août 2009
 */



include ("test/testclass.php");
$param = array ("debug_mode"=>1);
$test = new Test($bdd,$param);
//$test->setDebugMode($OBJETBDD_debugmode);

$data = array(
"id"=>5,
"datemodif"=>"15/08/2009",
"champtexte"=>"Dupont",
"champtexte2"=>"abc",
"mel"=>"essai@societe.com"
);
////echo "<br>";

$res = $test->ecrire($data);
print_r ($test->getErrorData());
//echo hash("sha256","password");
//echo "<br>";
//print_r($_SERVER);
/*
$lignes=array(20,22);
$test->ecrireTableNN("test","id1","id2",2,$lignes);

//$test->lire(3);
//phpinfo();
?>