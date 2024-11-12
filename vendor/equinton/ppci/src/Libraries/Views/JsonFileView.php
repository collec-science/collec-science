<?php

namespace Ppci\Libraries\Views;
/**
 * Send a Json file
 */
class JsonFileView extends DefaultView
{
    private $filename = "";
    private $json = "";
    private $is_json = false;

    /**
     * set a Json content (manual programming)
     *
     * @param string $json
     */
    function setJson($json)
    {
        $this->json = $json;
        $this->is_json = true;
    }
    /**
     * rewrite if the data is mono-record
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
     * Generate the creation of Json file
     *
     * @param string $filename
     * @return void
     */
    function send($filename = "")
    {
        if (!empty($this->data)) {
            if (empty($filename)) {
                $filename = $this->filename;
            }
            if (empty($filename)) {
                $filename = "export-" . date('Y-m-d-His') . ".json";
            }
            /*
             * Encodage des donnees
             */
            if ($this->is_json) {
                $json = $this->json;
            } else {
                /*$data = array();
                foreach ($this->data as $key => $value) {
                    $data[$key] = $this->encodehtml($value);
                }*/
                $json = json_encode($this->data, JSON_UNESCAPED_UNICODE);
            }
            /*
             * Send
             */
            ob_clean();
            header('Content-Type: application/json');
            header('Content-Disposition: attachment;filename=' . $filename);
            $fp = fopen('php://output', 'w');
            echo $json;
            fclose($fp);
            ob_flush();
            exit();
        }
    }
    /**
     * Set the filename
     *
     * @param string $filename
     */
    function setFilename($filename)
    {
        $this->filename = $filename;
    }
}