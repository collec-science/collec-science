<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class MimeType extends PpciModel
{

    /**
     * Constructeur de la classe
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct()
    {
        $this->table = "mime_type";
        $this->fields = array(
            "mime_type_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "extension" => array(
                "type" => 0,
                "requis" => 1
            ),
            "content_type" => array(
                "type" => 0,
                "requis" => 1
            )
        );
        parent::__construct();
    }

    /**
     * Retourne le numero de type mime correspondant a l'extension
     *
     * @param string $extension
     * @return int
     */
    function getTypeMime($extension)
    {
        if (!empty($extension)) {
            $extension = strtolower($this->encodeData($extension));
            $sql = "select mime_type_id from mime_type where extension = :extension:";
            $res = $this->lireParamAsPrepared($sql, array("extension" => $extension));
            return $res["mime_type_id"];
        }
    }
    /**
     * Get the list of extensions, in array form or in string form with commas
     *
     * @param boolean $isArray
     * @return void
     */
    function getListExtensions($isArray = false)
    {
        $sql = "select extension from mime_type order by extension";
        $data = $this->getListeParam($sql);
        if (!$isArray) {
            $result = "";
            $comma = "";
            foreach ($data as $value) {
                $result .= $comma . $value["extension"];
                $comma = _(", ");
            }
            return $result;
        } else {
            return $data;
        }
    }
}
