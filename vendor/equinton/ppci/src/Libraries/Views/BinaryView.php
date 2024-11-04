<?php
namespace Ppci\Libraries\Views;

class BinaryView extends DefaultView
{

    public array $param = array(
        "filename" => "", /* nom du fichier tel qu'il apparaitra dans le navigateur */
        "disposition" => "attachment", /* attachment : le fichier est telecharge, inline : le fichier est affiche */
        "tmp_name" => "", /* emplacement du fichier dans le serveur */
        "content_type" => "", /* type mime */
        "is_reference" => false, /* if true, tmp_name contains the handle of the opened file */
        "handle" => 0
    );

    function __construct(array $param = array())
    {
        $this->setParam($param);
    }
    /**
     * Met a jour les parametres necessaires pour l'export
     *
     * @param array $param
     */
    function setParam(?array $param)
    {
        if (is_array($param)) {
            foreach ($param as $key => $value) {
                $this->param[$key] = $value;
            }
        }
    }
    function set($value, $variable = "")
    {
        if (!empty($variable)) {
            $this->data[$variable] = $value;
        } else {
            $this->data = $value;
        }
    }
    /**
     *
     * Envoi du fichier au navigateur
     *
     * {@inheritdoc}
     *
     * @see Vue::send()
     */
    function send($param = "")
    {

        !empty($this->param["tmp_name"]) ? $isReference = false : $isReference = true;
        /*
         * Recuperation du content-type s'il n'a pas ete fourni
         */
        if (empty($this->param["content_type"])) {
            $finfo = new \finfo(FILEINFO_MIME_TYPE);
            if (!$finfo) {
                throw new \Ppci\Libraries\PpciException(_("Problème rencontré lors de l'ouverture de finfo"));
            }
            $this->param["content_type"] = $finfo->file($this->param["tmp_name"]);
        }
        header('Content-Type: ' . $this->param["content_type"]);
        header('Content-Transfer-Encoding: binary');
        if ($this->param["disposition"] == "attachment" && !empty($this->param["filename"])) {
            header('Content-Disposition: attachment; filename="' . basename($this->param["filename"]) . '"');
        } else {
            header('Content-Disposition: inline');
        }
        if (!$isReference) {
            header('Content-Length: ' . filesize($this->param["tmp_name"]));
        }
        /**
         * Ajout des entetes de cache
         */
        header('Expires: 0');
        header('Cache-Control: must-revalidate');
        header('Pragma: no-cache');
        /*
         * Envoi au navigateur
         */
        ob_clean();
        flush();
        if (!$isReference) {
            readfile($this->param["tmp_name"]);
        } else {
            fpassthru($this->param["handle"]);
        }
        exit();
    }
}
