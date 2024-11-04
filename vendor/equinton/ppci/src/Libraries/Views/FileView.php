<?php
namespace Ppci\Libraries\Views;

class FileView extends DefaultView
{
    public array $param = array(
        "filename" => "export.txt", /* nom du fichier tel qu'il apparaitra dans le navigateur */
        "disposition" => "attachment", /* attachment : le fichier est telecharge, inline : le fichier est affiche */
        "content_type" => "", /* type mime */
        "tmp_name" => "", /* Name of the file to send */
    );

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
    /**
     * rewrite send for generate the file
     *
     * @param array $param: list of parameters of file
     * @return void
     */
    function send($param = [])
    {
        /**
         * @var array $param
         */
        if (count($param) > 0) {
            $this->setParam($param);
        }
        if (empty($this->data) && empty($this->param["tmp_name"])) {
            throw new \Ppci\Libraries\PpciException(_("Le nom du fichier à exporter n'a pas été renseigné et aucune donnée n'est disponible pour l'exportation"), true);
        }
        if (empty($this->param["content_type"]) && !empty($this->param["tmp_name"])) {
            $finfo = new \finfo(FILEINFO_MIME_TYPE);
            $this->param["content_type"] = $finfo->file($this->param["tmp_name"]);
        }
        if (empty($this->data)) {
            $this->data = file_get_contents($this->param["tmp_name"]);
        }
        ob_clean();
        header('Content-Type: ' . $this->param["content_type"]);
        header('Content-Transfer-Encoding: binary');
        if ($this->param["disposition"] == "attachment" && !empty($this->param["filename"])) {
            header('Content-Disposition: attachment; filename="' . basename($this->param["filename"]) . '"');
        } else {
            header('Content-Disposition: inline');
        }
        /*
         * Ajout des entetes de cache
         */
        header('Expires: 0');
        header('Cache-Control: must-revalidate');
        header('Pragma: no-cache');
        /*
         * Envoi au navigateur
         */
        $fp = fopen('php://output', 'w');
        fwrite($fp, $this->data);
        fclose($fp);
        ob_flush();
        exit();
    }
}