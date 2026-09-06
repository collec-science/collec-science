<?php

namespace App\Libraries;

use App\Models\Odk;
use App\Models\OdkChoice;
use App\Models\OdkLine;
use App\Models\OdkSampletype;
use Override;
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
            $dataOdk = $this->odk->read($id);
            if (empty($dataOdk)) {
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

    function addChoice(string $listName, string $name, string $label, string $filter = "")
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
        $this->openGroup("sampling", _("Échantillonnage"));
        $this->addLine("begin repeat", "samples", _("Échantillons"));
        $this->addLine("select one sample", "sample_type_id", "Type d'échantillon", "", "field-list");
        $unit = "jr:choice-name('" . '${sample_type_id}' . "', 'multiple_unit')";
        $this->addLine("calculate", "hint-quantity", "", "", "", "", "", ["calculation" => $unit]);
        $relevant = "jr:choice-name('" . '${sample_type_id}' . "', 'multiple_type_id') = 1";
        $this->addLine("decimal", "multiple_value", _("Quantité"), '${hint-quantity}', "", "", $relevant);
        $prefix = [];
        $md_list = [];
        $md_list_relevant = [];
        /**
         * Add list of sample types in choice
         */
        foreach ($this->samples as $sample) {
            $this->addChoice("sample_type_id", $sample["sample_type_name"], $sample["sample_type_id"]);
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
        $this->addLine("end repeat");
        $this->closeGroup();
    }

    function openGroup(string $name, string $label)
    {
        $this->addLine("begin group", $name, $label, "", "field-list");
    }

    function closeGroup()
    {
        $this->addLine("end group");
        $this->addLine("blank");
    }
}
