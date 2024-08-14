<?php

namespace Ppci\Libraries\Views;

/**
 * Send an array in csv format
 */
class CsvView extends DefaultView
{
    private $filename = "";
    private $delimiter = ";";

    private $header = array();

    /**
     * Rewrite when the data is mono-record
     *
     * @param array $value
     * @param string $variable
     * @return void
     */
    function set($value, $variable = "")
    {
        if (is_array($value[0])) {
            $this->data = $value;
        } else {
            $this->data[] = $value;
        }
    }

    /**
     * Create and send the csv file
     *
     * @param string $filename
     * @param string $delimiter
     * @return void
     */
    function send($filename = "", $delimiter = "")
    {
        if (!empty($this->data)) {
            if (empty($filename)) {
                $filename = $this->filename;
            }
            if (empty($filename)) {
                $filename = $_SESSION["dbparams"]["APPLI_code"] . "-" . date('Y-m-d-His') . ".csv";
            }
            if (empty($delimiter)) {
                $delimiter = $this->delimiter;
            }
            /*
             * Preparation du fichier
             */
            ob_clean();
            header('Content-Type: text/csv');
            header('Content-Disposition: attachment;filename=' . $filename);
            $fp = fopen('php://output', 'w');
            /*
             * Treatment of header
             */
            fputcsv($fp, array_keys($this->data[0]), $delimiter);
            /**
             * Treatment of rows
             */
            foreach ($this->data as $value) {
                fputcsv($fp, $value, $delimiter);
            }
            fclose($fp);
            ob_flush();
            exit();
        }
    }

    /**
     * Function that scans the data table to extract all the columns and recreate a table 
     * that can be used for csv export with all the possible columns
     */
    function regenerateHeader()
    {
        /*
         * Search all headers of columns
         */
        foreach ($this->data as $row) {
            foreach ($row as $key => $value) {
                if (!in_array($key, $this->header)) {
                    $this->header[] = $key;
                }
            }
        }
        /*
         * Reformats the array to include all available columns
         */
        $data = $this->data;
        $this->data = array();
        foreach ($data as $row) {
            $newline = array();
            foreach ($this->header as $key) {
                $newline[$key] = $row[$key];
            }
            $this->data[] = $newline;
        }
    }

    /**
     * set the filename
     *
     * @param string $filename
     */
    function setFilename($filename)
    {
        $this->filename = $filename;
    }

    /**
     * set the field delimiter
     *
     * @param string $delimiter
     */
    function setDelimiter($delimiter)
    {
        if ($delimiter == "tab") {
            $delimiter = "\t";
        }
        $this->delimiter = $delimiter;
    }
}
