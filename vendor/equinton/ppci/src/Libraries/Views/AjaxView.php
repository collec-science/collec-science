<?php

namespace Ppci\Libraries\Views;
/**
 * Send an array in Json format, with html encoding
 */
class AjaxView extends DefaultView
{
    private $json = "";
    private $is_json = false;
    function setJson($json)
    {
        $this->json = $json;
        $this->is_json = true;
    }
    function send($param = "")
    {
        /**
         * Data encoding
         */
        if ($this->is_json) {
            $json = $this->json;
        } else {
            $data = array();
            foreach ($this->data as $key => $value) {
                $data[$key] = $this->encodehtml($value);
            }
            $json = json_encode($data);
        }
        /**
         * Send
         */
        ob_clean();
        echo $json;
        ob_flush();
        exit();
    }
}
