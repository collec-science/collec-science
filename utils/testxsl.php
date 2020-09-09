<?php
/**
 * test the configuration of a xsl file with data in a xml file
 */
if (empty ($argv[1]) || empty ($argv[2]) ) {
  echo "usage: php testxsl.php file.xml transform.xsl".PHP_EOL;
  die;
}
$xml = new DOMDocument;
$xml->load($argv[1]);

$xsl = new DOMDocument;
$xsl->load($argv[2]);

$proc = new XSLTProcessor;
$proc->importStyleSheet($xsl);

echo $proc->transformToXML($xml);
