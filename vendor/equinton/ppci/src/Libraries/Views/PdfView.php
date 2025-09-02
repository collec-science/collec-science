<?php

namespace Ppci\Libraries\Views;

use Ppci\Libraries\PpciException;

/**
 * Send a PDF file
 */
class PdfView extends DefaultView
{
    private $filename;
    private $reference;

    /**
     * attachment|inline
     *
     * @var string
     */
    private $disposition = "attachment";

    /**
     * Undocumented function
     *
     * @param string $param
     * 
     * @return void
     */
    function send($param = "")
    {
        if (is_array($param)) {
            foreach ($param as $k => $v) {
                $this->$k = $v;
            }
        }
        if (!is_null($this->reference)) {
            header("Content-Type: application/pdf");
            if (!empty($this->filename)) {
                $filename = $this->filename;
            } else {
                $filename = $_SESSION["dbparams"]["APPLI_code"] . '-' . date('y-m-d') . ".pdf";
            }
            header('Content-Disposition: ' . $this->disposition . '; filename="' . $filename . '"');
            if (!rewind($this->reference)) {
                throw new PpciException('Problem to rewind resource');
            }
            if (!fpassthru($this->reference)) {
                throw new PpciException('Problem to send file');
            }
        } elseif (file_exists($this->filename)) {
            /*
             * get the content-type
             */
            $finfo = finfo_open(FILEINFO_MIME_TYPE);
            header('Content-Type: ' . finfo_file($finfo, $this->filename));
            finfo_close($finfo);

            /*
             * set disposition
             */
            header('Content-Disposition: ' . $this->disposition . '; filename="' . basename($this->filename) . '"');

            /*
             * Deactivate cache
             */
            header('Expires: 0');
            header('Cache-Control: must-revalidate');
            header('Pragma: public');
            header('Content-Length: ' . filesize($this->filename));

            ob_clean();
            flush();
            if (!empty($this->filename)) {
                readfile($this->filename);
                exit();
            } else {
                throw new PpciException(_("Le fichier ne peut pas être envoyé au navigateur"));
            }
        } else {
            throw new PpciException(_("Aucun contenu disponible"));
        }
    }

    /**
     * Set filename
     *
     * @param string $filename
     */
    function setFilename($filename)
    {
        $this->filename = $filename;
    }

    /**
     * Set the reference of the file, if it's already open
     *
     * @param $ref
     * @return void
     */
    function setFileReference($ref)
    {
        $this->reference = $ref;
    }

    /**
     * set the content disposition
     *
     * @param string $disp
     */
    function setDisposition($disp = "attachment")
    {
        $this->disposition = $disp;
    }
}
