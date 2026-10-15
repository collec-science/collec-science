<?php

namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;

class Csv extends PpciLibrary
{
    private $separator = ",";
    private $utf8_encode = false;
    private $handle;
    private $header = array();

    function openfile(string $filename, $separator = ",", $utf8_encode = false)
    {
        if ($separator == "tab" || $separator == "t") {
            $separator = "\t";
        }
        $this->separator = $separator;
        $this->utf8_encode = $utf8_encode;
        /*
         * open file
         */
        $this->header = [];
        if ($this->handle = fopen($filename, 'r')) {
            if (bomEraser($this->handle)) {
                $this->utf8_encode = false;
            }
            $data = $this->readLine();
            $range = 0;
            /*
             * get header
             */
            for ($range = 0; $range < count($data); $range++) {
                $this->header[$range] = $data[$range];
            }
        } else {
            throw new PpciException(sprintf(_("%s non trouvé ou non lisible"), $filename));
        }
    }
    function readLine()
    {
        if ($this->handle) {
            $data = fgetcsv($this->handle, 0, $this->separator);
            if ($data !== false && $this->utf8_encode) {
                $data =  mb_convert_encoding($data, 'UTF-8', 'ISO-8859-15, ISO-8859-1, Windows-1252');;
            }
            return $data;
        } else {
            return false;
        }
    }
    /**
     * read the file and return it in an array
     *
     * @return mixed[][]
     */
    function getContentAsArray()
    {
        $data = array();
        $nb = count($this->header);
        while (($line = $this->readLine()) !== false) {
            if (!empty($line)) {
                $dl = array();
                for ($i = 0; $i < $nb; $i++) {
                    $dl[$this->header[$i]] = $line[$i];
                }
                $data[] = $dl;
            }
        }
        return $data;
    }

    /**
     * close the file
     */
    function fileClose()
    {
        if ($this->handle) {
            fclose($this->handle);
        }
    }
}
