<?php
/**
 * Created : 5 sept. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
class ImportException extends Exception {
    
}

 class Import {
     private $separator = ",";
     private $utf8_encode = false;
     private $handle;
     private $fileColumn = array();
     public $minuid, $maxuid;
     function initFile($filename, $separator = ",", $utf8_encode = false)
     {
         if ($separator == "tab") {
             $separator = "\t";
         }
             $this->separator = $separator;
             /*
              * Ouverture du fichier
              */
             if ($this->handle = fopen($filename, 'r')) {
                 $data = $this->readLine();
                 $range = 0;
                 /*
                  * Preparation des entetes
                  */
                 for ($range = 0; $range < count($data); $range ++) {
                     $this->fileColumn[$range] = $data[$range];
                 }
                
             }else {
                 throw new ImportException("$filename not found or not readable");
             }
     }
     /**
      * Lit une ligne dans le fichier
      *
      * @return array|NULL
      */
     function readLine()
     {
         if ($this->handle) {
             $data = fgetcsv($this->handle, 0, $this->separator);
             if ($data !== false) {
                 if ($this->utf8_encode) {
                     foreach ($data as $key => $value)
                         $data[$key] = utf8_encode($value);
                 }
             }
             return $data;
         } else
             return null;
     }
     
     /**
      * Ferme le fichier
      */
     function fileClose()
     {
         if ($this->handle)
             fclose($this->handle);
     }
 }
?>