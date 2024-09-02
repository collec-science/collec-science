<?php

namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;
use SimpleXMLElement;

class Export extends PpciModel
{
    private $sql = "select export_id, lot_id, export_date, export_template_id
                  , export_template_name
                  from export
                  join lot using (lot_id)
                  join export_template using (export_template_id)";
    public $lot, $exportTemplate, $datasetTemplate;
    private $temp = "writable/temp";

    /**
     * Constructor
     *
     * @param PDO $bdd: connection to the database
     * @param array $param: specific parameters
     */
    function __construct()
    {
        $this->table = "export";
        $this->fields = array(
            "export_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "lot_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "export_date" => array("type" => 3, "defaultValue" => "getDateHeure"),
            "export_template_id" => array("type" => 1, "requis" => 1)
        );
        $appConfig = service ("AppConfig");
        $this->temp= $appConfig->APP_temp;
        parent::__construct();
    }
    /**
     * Get the list of exports attached to a lot
     *
     * @param integer $lot_id
     * @return array
     */
    function getListFromLot($lot_id)
    {
        $where = " where lot_id = :id:";
        return $this->getListeParamAsPrepared($this->sql . $where, array("id" => $lot_id));
    }

    /**
     * create an export
     *
     * @param integer $export_id
     * @return array: list of generated files (only one row)
     */
    function generate(int $export_id): array
    {
        $dexport = $this->lire($export_id);
        /**
         * Get the list of dataset templates
         */
        if (!is_object($this->exportTemplate)) {
            $this->exportTemplate = new ExportTemplate;
        }
        $dtemplate = $this->exportTemplate->lire($dexport["export_template_id"]);
        $datasets = $this->exportTemplate->getListDatasets($dexport["export_template_id"]);
        /**
         * Get list of uids
         */
        if (!is_object($this->lot)) {
            $this->lot = new Lot;
        }
        $uids = $this->lot->getUidsAsString($dexport["lot_id"]);
        /**
         * Traitement des datasets
         */
        if (!is_object($this->datasetTemplate)) {
            $this->datasetTemplate = new DatasetTemplate;
        }

        /**
         * $files: list of generated files. Array with these fields
         * filetmp: name of temporary file in the system
         * filename: name of the file to send
         * filetype: type of the file (CSV, JSON, XML)
         */
        $files = array();
        foreach ($datasets as $dataset) {
            try {
                $data = $this->datasetTemplate->generateData($dataset["dataset_template_id"], $uids);
            } catch (\Exception $dte) {
                throw new PpciException($dte->getMessage());
            }
            $ddataset = $this->datasetTemplate->getDetail($dataset["dataset_template_id"]);
            /**
             * Generate the file
             */
            if (count($data) > 0) {
                $filetmp = tempnam($this->temp, $ddataset["export_format_name"]);
                $handle = fopen($filetmp, 'w');
                if ($ddataset["dataset_type_id"] == 4) {
                    fwrite($handle, $data[0]);
                } else {
                    switch ($ddataset["export_format_name"]) {
                        case "CSV":
                            $delimiter = $ddataset["separator"];
                            if ($delimiter == "tab") {
                                $delimiter = "\t";
                            }
                            /** first line, header */
                            fputcsv($handle, array_keys($data[0]), $delimiter);
                            foreach ($data as $value) {
                                fputcsv($handle, $value, $delimiter);
                            }
                            break;
                        case "JSON":
                            fwrite($handle, json_encode($data));
                            break;
                        case "XML":
                            /**
                             * @var SimpleXMLElement
                             */
                            $xml = new \SimpleXMLElement($ddataset["xmlroot"]);
                            if ($ddataset["dataset_type_id"] == 2) {
                                foreach ($data[0] as $k => $v) {
                                    if ($k == "collection_keywords") {
                                        $keywords = $xml->addchild("collection_keywords");
                                        foreach ($v as $keyword) {
                                            $keywords->addChild("keyword", $keyword["keyword"]);
                                        }
                                    } else {
                                        $xml->addChild($k, $v);
                                    }
                                }
                            } else {
                                $this->to_xml($xml, $data, $ddataset["xmlnodename"]);
                            }
                            /**
                             * Treatment of xsl transformation
                             */
                            if (!empty($ddataset["xslcontent"])) {
                                $xsl = new \DOMDocument;
                                $xsl->loadXML($ddataset["xslcontent"]);
                                $proc = new \XSLTProcessor;
                                $proc->importStyleSheet($xsl);
                                fwrite($handle, $proc->transformToXml($xml));
                            } else {
                                $xml->asXML($filetmp);
                            }
                            break;
                        default:
                            throw new PpciException(_("Impossible de générer le fichier, le type est inconnu ou non spécifié"));
                    }
                }
                fclose($handle);
                $files[] = array("filetmp" => $filetmp, "filename" => $ddataset["filename"], "filetype" => $ddataset["export_format_name"]);
            }
        }
        /**
         * If zipped, generate the zip file
         */
        if ($dtemplate["is_zipped"] == 1 || count($files) > 1) {
            $zip = new \ZipArchive;
            $zipname = tempnam($$this->temp, $dtemplate["filename"]);
            if ($zip->open($zipname, \ZipArchive::CREATE) === true) {
                foreach ($files as $file) {
                    $zip->addFile($file["filetmp"], $file["filename"]);
                }
                $zip->close();
                /**
                 * Destroy the temporary files
                 */
                foreach ($files as $file) {
                    unlink($file["filetmp"]);
                }
                /**
                 * reinit the array $files
                 */
                $files = array();
                $files[] = array("filetmp" => $zipname, "filename" => $dtemplate["filename"], "filetype" => "zip");
            } else {
                throw new PpciException(_("Impossible de créer le fichier zip"));
            }
        }
        return $files;
    }

    /**
     * Generate a xml content
     *
     * @param SimpleXMLElement $object
     * @param array $data
     * @param string $nodename: name of the node for each row
     * @return void
     */
    function to_xml(SimpleXMLElement $xml, array $data, $nodename = "")
    {
        foreach ($data as $key => $value) {
            /**
             * Transform each row to a $nodename object
             */
            if (is_numeric($key)) {
                $key = $nodename;
            }
            if (is_array($value)) {
                $new = $xml->addchild($nodename);
                $this->to_xml($new, $value, $nodename);
            } else {
                $xml->addChild($key, $value);
            }
        }
    }

    function updateExportDate($id)
    {
        $data = $this->lire($id);
        if (!$data["export_id"] > 0) {
            throw new PpciException(sprintf(_("L'export %s n'existe pas"), $id));
        }
        $this->autoFormatDate = false;
        $data["export_date"] = date("c");
        $this->ecrire($data);
    }
}
