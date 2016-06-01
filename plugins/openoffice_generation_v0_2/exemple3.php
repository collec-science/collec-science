<?php

// Chargement de la classe principale
require_once ('calc/classes/OpenOfficeSpreadsheet.class.php');

// Création du fichier OpenOffice Spreadsheet
$calc = new OpenOfficeSpreadsheet('span.ods');
$sheet = new Table();
$pict = new Picture();
// Création de la feuille
$sheet = $calc->addSheet('Span');

$cell1 = $sheet->getCell(1, 1);
$cell1->setContent('span1');
$cell1->setSpannedCols(9);
$cell1->setBackgroundColor('#CCCCCC');

$cell2 = $sheet->getCell(10, 3);
$cell2->setContent('span2');
$cell2->setSpannedRows(3);
$cell2->setBackgroundColor('#CCCCCC');

$cell3 = $sheet->getCell(4, 3);
$cell3->setContent('span3');
$cell3->setSpannedCols(2);
$cell3->setBackgroundColor('#CCCCCC');

$cell4 = $sheet->getCell(9, 5);
$cell4->setContent('span3');
$cell4->setSpannedCols(4);
$cell4->setBackgroundColor('#FF0000');

$cell4->setFontFamily('Balloon');
$cell4->setFontSize('19pt');

$cellPict = $sheet->getCell(3, 9);

$pict = $sheet->addPicture('c:/wamp/www/openoffice/openoffice/test.gif');
$pict->setBottomRightCorner('1.422cm', '0.451cm', $cellPict);
$pict->setSVG('0.557cm', '0.186cm');
$pict->setSize('3.122cm', '2.974cm');

$choix =  1;
switch ($choix) {
	case 1:
		echo $calc->saveXML('content');
		break;
	case 2:
		$calc->save();
		break;
	case 3:
		$calc->output();
		break;
	default:
		$calc->save();
}

?>