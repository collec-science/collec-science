<?php


require_once ('calc/classes/OpenOfficeSpreadsheet.class.php');

$calc = new OpenOfficeSpreadsheet('essai.ods');

$sheet = $calc->addSheet('test');

$cell = $sheet->getCell(2, 2);
$cell->setContent('Ceci est un premier header tres long');

$sheet->setCellContent('Et hop', 3, 2);
$sheet->setCellContent('Le nombre de truc', 4, 2);
$sheet->setCellContent('Machin chose', 5, 2);

$cell2 = $sheet->getCell(6, 2);
$cell2->setContent('Dernier header');

$cellT1 = $sheet->getCell(4, 5);
$cellT1->setContent('Gras et italique');
$cellT1->setFontBold();
$cellT1->setFontItalic();

$cellT2 = $sheet->getCell(5, 5);
$cellT2->setContent('o');
$cellT2->setTextCenter();

$cell3 = $sheet->getCell(14, 8);

$sheet->setCellBackgroundColor('#EEEEEE', $cell, $cell3);
$sheet->setCellBorderAround('0.01cm solid #666666', $cell, $cell3);
$sheet->setCellColor('#FF0000', $cell, $cell3);

// Somme
$sheet->setCellContent('1', 1, 9);
$sheet->setCellContent('5', 2, 9);
$sheet->setCellContent('2', 1, 10);
$sheet->setCellContent('2', 2, 10);
$sheet->setCellContent('5', 3, 9);
$sheet->setCellContent('5', 4, 9);
$sheet->setCellContent('somme :', 3, 12);
$sheet->setFormulaSUM('a9:b10;c9', 4, 12);

$dec = $sheet->getCell(4, 12);
$dec->setDecimal(2);

$choix = 2;
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