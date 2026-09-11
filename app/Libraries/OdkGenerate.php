<?php

namespace App\Libraries;

use App\Models\Odk;
use App\Models\OdkChoice;
use App\Models\OdkLine;
use App\Models\OdkSampletype;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use PhpOffice\PhpSpreadsheet\Writer\Ods;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use Ppci\Libraries\PpciLibrary;
use Ppci\Libraries\PpciException;

class OdkGenerate extends PpciLibrary
{

    private array $lines = [];
    private array $choices = [];
    private array $identifiers = [];
    private array $referents = [];
    private array $stations = [];
    private array $samples = [];
    private array $dataOdk = [];

    public Odk $odk;
    public OdkLine $odkLine;
    public OdkChoice $odkChoice;
    public OdkSampletype $odkSample;

    function __construct()
    {
        parent::__construct();
        $this->odkLine = new OdkLine;
        $this->odkChoice = new OdkChoice;
        $this->odk = new Odk;
        $this->odkSample = new OdkSampletype;
    }

    function calculate(int $id)
    {
        $db = $this->odk->db;
        try {
            $db->transBegin();
            $this->dataOdk = $this->odk->read($id);
            if (empty($this->dataOdk)) {
                throw new PpciException(_("Le modèle de formulaire n'existe pas"));
            }
            $this->reset($id);
            /**
             * Read data from $id
             */
            $this->identifiers = $this->odk->getIdentifiers($id);
            $this->referents = $this->odk->getReferents($id);
            $this->stations = $this->odk->getStations($id);
            $this->samples = $this->odkSample->getListFromOdk($id);

            /**
             * Create lines
             */
            $this->generateSampling();
            $this->generateSamples();
            /**
             * End - write data in database
             */
            $this->writeLines($id);
            $this->writeChoices($id);
            $db->transCommit();
            return true;
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            $db->transRollback();
            return false;
        }
    }

    /**
     * Method reset: clear all lines and choices from database
     *
     * @param int $id 
     *
     * @return void
     */
    function reset(int $id)
    {
        $tables = ["odk_line", "odk_choice"];
        $param = ["id" => $id];
        foreach ($tables as $table) {
            $sql = "DELETE from $table where odk_id = :id:";
            $this->odk->executeSQL($sql, $param, true);
        }
    }

    function writeLines(int $id)
    {
        $order = 10;
        foreach ($this->lines as $line) {
            $line["odk_id"] = $id;
            $line["odk_line_id"] = 0;
            $line["line_order"] = $order;
            $order += 10;
            $this->odkLine->write($line);
        }
    }

    function writeChoices(int $id)
    {
        foreach ($this->choices as $choice) {
            $choice["odk_id"] = $id;
            $choice["odk_choice_id"] = 0;
            $this->odkChoice->write($choice);
        }
    }

    function addLine(string $type, ?string $name = "", ?string $label = "", ?string $hint = "", ?string $appearance = "", ?string $default = "", ?string $relevant = "", ?array $others = [])
    {

        $line = ["line_type" => $type];
        $fields = ["name", "label", "hint", "appearance", "default", "relevant"];
        foreach ($fields as $field) {
            if (strlen($$field) > 0) {
                $line["line_$field"] = $$field;
            }
        }
        foreach ($others as $k => $v) {
            $line["line_$k"] = $v;
        }
        $this->lines[] = $line;
    }

    function addChoice(string $listName, string $name, string $label, ?string $filter = "")
    {
        $choice = [
            "list_name" => $listName,
            "choice_name" => $name,
            "choice_label" => $label,
            "choice_filter" => $filter
        ];
        $this->choices[] = $choice;
    }

    function generateSampling()
    {
        $this->openGroup("general", _("Point de prélèvement"));
        $this->addLine("date", "sampling_date", "Date de prélèvement", "", "no-calendar", "today()");
        if (!empty($this->referents)) {
            $this->addLine("select one referent", "referent_id", _("Référent des échantillons"));
            foreach ($this->referents as $referent) {
                $this->addChoice("referent", $referent["referent_id"], trim($referent["referent_name"] . " " . $referent["referent_firstname"]));
            }
        }
        if (!empty($this->stations)) {
            $this->addLine("select one station", "sampling_place_id", _("Station"));
            foreach ($this->stations as $station) {
                $this->addChoice("station", $station["sampling_place_id"], $station["sampling_place_name"]);
            }
        }
        $this->addLine("geopoint", "geopoint", "GPS", "", "quick maps");
        $this->closeGroup();
    }

    function generateSamples()
    {
        $this->addLine("begin repeat", "samples", _("Échantillons"));
        $this->openGroup("sampling", _("Détail de l'échantillon \${identifier}"));

        $this->addLine("select one sample_type_id", "sample_type_id", "Type d'échantillon");
        /**
         * subsampling
         */
        if ($this->dataOdk["with_subsampling"] == 1) {
            $this->addLine("select one is-subsampling", "is_subsampling", _("Sous-échantillon ?"), _("Sous-échantillon de l'échantillon récolté précédemment qui n'est pas un sous-échantillon"), "columns-pack", 0);
            $this->addChoice("is-subsampling", 0, _("non"));
            $this->addChoice("is-subsampling", 1, _("oui"));
        }
        /**
         * identifier
         */
        $this->addLine("text", "identifier", _("Identifiant métier"), "", "", 'jr:choice-name(${sample_type_id}, "identifier_prefix")');
        $unit = 'jr:choice-name(${sample_type_id}, "multiple_unit")';
        $this->addLine("calculate", "hint-quantity", "", "", "", "", "", ["calculation" => $unit]);
        $relevant = 'jr:choice-name(${sample_type_id}, "multiple_type_id") = 1';
        $this->addLine("decimal", "multiple_value", _("Quantité"), '${hint-quantity}', "", "", $relevant);
        $prefix = [];
        $md_list = [];
        $md_list_relevant = [];
        /**
         * Add list of sample types in choice
         */
        foreach ($this->samples as $sample) {
            $this->addChoice("sample_type_id", $sample["sample_type_id"], $sample["sample_type_name"]);
        }
        /**
         * Add list of default identifiers in choice
         */
        foreach ($this->samples as $sample) {
            if (strlen($sample["identifier_prefix"]) > 0) {
                $this->addChoice("identifier_prefix", $sample["sample_type_id"], $sample["identifier_prefix"]);
            }
        }
        /**
         * add if necessary quantity and metadata
         */
        foreach ($this->samples as $sample) {
            if (!empty($sample["multiple_unit"])) {
                $this->addChoice("multiple_unit", $sample["sample_type_id"], $sample["multiple_unit"]);
            }
            $this->addChoice("quantity", $sample["sample_type_id"], $sample["multiple_type_id"] > 0 ? 1 : 0);
            /**
             * get metadata
             */
            $metadatas = json_decode($sample["metadata_schema"], true);

            foreach ($metadatas as $metadata) {
                $md_list[$metadata["name"]] = [
                    "type" => $metadata["type"],
                    "required" => $metadata["required"],
                    "description" => $metadata["description"],
                    "choiceList" => $metadata["choiceList"],
                    "multiple" => $metadata["multiple"],
                    "default" => $metadata["defaultValue"],
                    "helper" => $metadata["helper"]
                ];
                $md_list_relevant[$metadata["name"]][] = $sample["sample_type_id"];
            }
        }
        /**
         * generate lines for metadata
         */
        if (!empty($md_list)) {
            $this->openGroup("metadata", _("Métadonnées"));
            $mdPerformed = [];
            foreach ($md_list as $name => $md) {
                if (!in_array($name, $mdPerformed)) {
                    $mdline = [];
                    if ($md["type"] == "string" || $md["type"] == "textarea" || $md["type"] == "url") {
                        $mdline["type"] = "text";
                    } else if ($md["type"] == "number") {
                        $mdline["type"] = "decimal";
                    } else if ($md["type"] == "date") {
                        $mdline["type"] = "date";
                        $mdline["appearance"] = "no-calendar";
                    } else {
                        /**
                         * list of values
                         */
                        if ($md["multiple"] == "yes") {
                            $mdline["type"] = "select_multiple md_$name";
                        } else {
                            $mdline["type"] = "select_one md_$name";
                        }
                        /**
                         * create the list choice
                         */
                        foreach ($md["choiceList"] as $val) {
                            if (strlen($val) > 0) {
                                $this->addChoice("md_$name", $val, $val);
                            }
                        }
                    }
                    /**
                     * add relevant
                     */
                    $i = 0;
                    $rel = '';
                    foreach ($md_list_relevant[$name] as $val) {
                        if ($i > 0) {
                            $rel .= " or ";
                        }
                        $rel .= '${sample_type_id} = "' . $val . '"';
                        $i++;
                    }
                    $mdline["relevant"] = $rel;
                    $mdPerformed[] = $name;
                    /**
                     * add line
                     */
                    $this->addLine(
                        $mdline["type"],
                        "md_$name",
                        $name,
                        $md["helper"],
                        $mdline["appearance"],
                        $md["default"],
                        $mdline["relevant"],
                        ["required" => $md["required"]]
                    );
                }
            }
            $this->closeGroup();
        }
        /**
         * media records
         */
        $medias = [
            "picture" => ["type" => "image", "label" => _("Photos"), "label2" => _("Ajoutez une photo")],
            "sound" => ["type" => "audio", "label" => _("Enregistrements sonores"), "label2" => _("Ajoutez un enregistrement sonore")],
            "video" => ["type" => "video", "label" => _("Vidéos"), "label2" => _("Ajoutez une vidéo")]
        ];
        $mediaRelevant = [];
        foreach ($this->samples as $sample) {
            foreach ($medias as $k => $media) {
                if ($sample["with_$k"] == 1) {
                    $mediaRelevant[$k][]  = $sample["sample_type_id"];
                }
            }
        }
        foreach ($mediaRelevant as $k => $r) {
            $this->addLine("blank");
            $media = $medias[$k];
            $rel = "";
            /**
             * calculate relevant
             */
            $i = 0;

            foreach ($r as $val) {
                if ($i > 0) {
                    $rel .= " or ";
                }
                $rel .= '${sample_type_id} = "' . $val . '"';
                $i++;
            }
            $this->addLine("begin repeat", "$k" . "s", $media["label"], "", "", "", $rel);
            $this->addLine($media["type"], $k, $media["label2"]);
            $this->addLine("end repeat");
        }
        /**
         * End of the treatment of the samples
         */
        $this->closeGroup();
        $this->addLine("end repeat");
    }

    function openGroup(string $name, string $label)
    {
        $this->addLine("begin group", $name, $label);
    }

    function closeGroup()
    {
        $this->addLine("end group");
        $this->addLine("blank");
    }

    function createSpreadsheet(int $id)
    {
        $this->dataOdk = $this->odk->read($id);
        if (empty($this->dataOdk)) {
            throw new PpciException(_("Le modèle de formulaire n'existe pas"));
        }
        $this->lines = $this->odkLine->getListFromParent($id, "line_order asc");
        if (empty($this->lines)) {
            throw new PpciException(_("Le formulaire n'a pas été calculé"));
        }
        $this->choices = $this->odkChoice->getListFromParent($id, "odk_choice_id asc");
        $spreadsheet = new Spreadsheet;
        $survey = new Worksheet($spreadsheet, "survey");
        $choices = new Worksheet($spreadsheet, "choices");
        $settings = new Worksheet($spreadsheet, "settings");
        /**
         * set the survey tab
         */
        $r = 1;
        foreach ($this->lines as $line) {
            if ($r == 1) {
                $c = 1;
                foreach ($line as $k => $v) {
                    /**
                     * add title if it's the first row
                     */
                    if (substr($k, 0, 5) == "line_" && $k != "line_order") {
                        $survey->setCellValue([$c, $r], substr($k, 5));
                        $c++;
                    }
                }
            }
            $r++;
            /**
             * treatment of each line
             */
            if ($line["line_type"] != "blank") {
                $c = 1;
                foreach ($line as $k => $v) {

                    if (substr($k, 0, 5) == "line_" && $k != "line_order") {
                        if (strlen($v) > 0) {
                            $survey->setCellValue([$c, $r], $v);
                        }
                        $c++;
                    }
                }
            }
        }
        /**
         * set the choice tab
         */
        $r = 1;
        $colsTitle = ["list_name", "name", "label", "filter"];
        $cols = ["list_name", "choice_name", "choice_label", "choice_filter"];
        $c = 1;
        /**
         * Title line
         */
        foreach ($colsTitle as $col) {
            $choices->setCellValue([$c, $r], $col);
            $c++;
        }

        foreach ($this->choices as $row) {
            $r++;
            $c = 1;
            foreach ($cols as $col) {
                $choices->setCellValue([$c, $r], $row[$col]);
                $c++;
            }
        }
        /**
         * set the settings tab
         */
        $colsTitle = ["form_title", "form_id", "version", "instance_name", "allow_choice_duplicates"];
        $c = 1;
        /**
         * Title line
         */
        foreach ($colsTitle as $col) {
            $settings->setCellValue([$c, 1], $col);
            $c++;
        }
        $settings->setCellValue([1, 2], $this->dataOdk["odk_name"]);
        $settings->setCellValue([2, 2], $this->dataOdk["odk_name"] . "-" . $this->dataOdk["odk_version"]);
        $settings->setCellValue([3, 2], $this->dataOdk["odk_version"]);

        /**
         * write the ods file
         */
        $spreadsheet->addSheet($survey);
        $spreadsheet->addSheet($choices);
        $spreadsheet->addSheet($settings);
        $spreadsheet->removeSheetByIndex(0);
        $writer = new Xlsx($spreadsheet);
        $filename = tempnam($this->appConfig->APP_temp, "ODK");
        $writer->save($filename);
        return $filename;
    }
}
