<?php

namespace App\Libraries;

use App\Models\Collection;
use App\Models\SampleType;
use Ppci\Libraries\PpciLibrary;

class Elab extends PpciLibrary
{

    function display()
    {
        $this->vue = service('Smarty');
        if (!empty($_POST["collection_id"])) {
            $this->vue->set($_POST["collection_id"], "collection_id");
            $this->vue->set($_POST["sample_type_id"], "sample_type_id");
        }
        $collection = new Collection;
        $this->vue->set($collection->getCollectionsFromLogin(), "collections");
        $this->vue->set("gestion/elab.tpl", "corps");
        return $this->vue->send();
    }

    function generateModel()
    {
        $metadata = [];
        $sampleTypeId = $_POST["sample_type_id"];
        if (!empty($sampleTypeId)) {
            $sampleType = new SampleType;
            $d = $sampleType->read($sampleTypeId);
            if (!empty($d["multiple_value"])) {
                $metadata[_("quantité")] = [
                    "type" => "number",
                    "unit" => $d["multiple_unit"],
                    "value" => $d["multiple_value"]
                ];
            }
            $mdschema = json_decode($d["metadata_schema"], true);
            if (!empty($mdschema)) {

                foreach ($mdschema as $md) {
                    $field = [];
                    $field["value"] = $md["defaultValue"];
                    $field["description"] = $md["description"];
                    /**
                     * types
                     */
                    $field["type"] = $md["type"];
                    if ($md["type"] == "string" || $md["type"] == "textarea") {
                        $field["type"] = "text";
                    } elseif ($md["type"] == "array") {
                        $field["allow_multiple_values"] = true;
                    }
                    if ($md["multiple"] == "yes") {
                        $field["allow_multiple_values"] = true;
                    }
                    if (!empty($md["measureUnit"])) {
                        $field["unit"] = $md["measureUnit"];
                    }
                    if (!empty($md["choiceList"])) {
                        $field["options"] = $md["choiceList"];
                    }
                    $field["required"] = $md["required"];
                    $metadata["metadata"][$md["name"]] = $field;
                }
            }

            $model = json_encode($metadata, JSON_UNESCAPED_UNICODE);
            $this->vue = service('Smarty');
            $this->vue->set($model, "model");
        }
        return $this->display();
    }
}
