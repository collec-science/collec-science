<?php
/**
 * Created : 17 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class VirusException extends Exception {
}
;
class FileException extends Exception {
}
;
function testScan($file) {
	echo "Analyse du fichier $file<br>";
	if (file_exists ( $file )) {
		if (extension_loaded ( 'clamav' )) {
			echo "Analyse avec clamav.so<br>";
			$retcode = cl_scanfile ( $file ["tmp_name"], $virusname );
			if ($retcode == CL_VIRUS) {
				$message = $file ["name"] . " : " . cl_pretcode ( $retcode ) . ". Virus found name : " . $virusname;
				throw new VirusException ( $message );
			}
		} else {
			/*
			 * Test avec clamscan
			 */
			$clamscan = "/usr/bin/clamscan";
			$clamscan_options = "-i --no-summary";
			echo "Analyse avec clamscan<br>";			
			if (file_exists ( $clamscan )) {
				exec ( "$clamscan $clamscan_options $file", $output );
				if (count ( $output ) > 0) {
					foreach ( $output as $value )
						$message .= $value . " ";
					throw new VirusException ( $message );
				}
			} else
				throw new FileException ( "clamscan not found" );
		}
	} else
		throw new FileException ( "$file not found" );
}

$nomfiletest = "/tmp/eicar.com.txt";
// $nomfiletest = "/tmp/test.txt";
try {
	testScan ( $nomfiletest );
	echo "Fichier sans virus reconnu par Clamav<br>";
} catch ( FileException $f ) {
	
	echo $f->getMessage () . "<br>";
} catch ( VirusException $v ) {
	echo $v->getMessage () . "<br>";
} finally {
	echo "Fin du test";
}
?>