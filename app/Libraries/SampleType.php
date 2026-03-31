<?php

namespace App\Libraries;

use App\Models\ContainerType;
use App\Models\Metadata;
use App\Models\MultipleType;
use App\Models\Operation;
use App\Models\Product;
use App\Models\Risk;
use App\Models\SampleType as ModelsSampleType;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class SampleType extends PpciLibrary
{
    /**
     * @var ModelsSampleType
     */
    protected PpciModel $dataclass;



    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsSampleType();
        $this->keyName = "sample_type_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function list()
    {
        $this->vue = service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe(2), "data");
        $this->vue->set("param/sampleTypeList.tpl", "corps");
        $this->vue->help("parametres/les-types-d'échantillons.html");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');

        $this->dataRead($this->id, "param/sampleTypeChange.tpl");
        $containerType = new ContainerType();
        $this->vue->set($containerType->getListe("container_type_name"), "container_type");
        $operation = new Operation();
        $this->vue->set($operation->getListe(), "operation");
        $multipleType = new MultipleType();
        $this->vue->set($multipleType->getListe(1), "multiple_type");
        $metadata = new Metadata();
        $this->vue->set($metadata->getListe(2), "metadata");
        $risk = new Risk;
        $product = new Product;
        $this->vue->set($risk->getList(2), "risks");
        $this->vue->set($product->getList(2), "products");
        $this->vue->help("parametres/les-types-d'échantillons.html");
        return $this->vue->send();
    }
    function write()
    {
        try {
            if (!empty($_POST["productNew"])) {
                $product = new Product;
                $_REQUEST["product_id"] = $product->write(["product_id" => 0, "product_name" => $_POST["productNew"]]);
            }
            if (!empty($_POST["riskNew"])) {
                $risk = new Risk;
                $_REQUEST["risk_id"] = $risk->write(["risk_id" => 0, "risk_name" => $_POST["riskNew"]]);
            }
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return true;
            } else {
                return false;
            }
        } catch (PpciException) {
            return false;
        }
    }

    function delete()
    {
        /*
         * delete record
         */
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException) {
            return false;
        }
    }
    function metadata()
    {
        $this->vue = service("AjaxView");
        $this->vue->setJson($this->dataclass->getMetadataForm($this->id));
        return $this->vue->send();
    }
    function metadataSearchable()
    {
        $this->vue = service("AjaxView");
        if (!empty($this->id)) {
            $this->vue->set($this->dataclass->getMetadataSearchable($this->id));
        } else {
            $metadata = new Metadata();
            $this->vue->set($metadata->getListSearchable());
        }
        return $this->vue->send();
    }
    function generator()
    {
        $this->vue = service("AjaxView");
        $this->vue->setJson($this->dataclass->getIdentifierJs($this->id));
        return $this->vue->send();
    }
    function getListAjax()
    {
        $this->vue = service("AjaxView");
        if (!empty($_REQUEST["collection_id"]) && is_numeric($_REQUEST["collection_id"])) {
            $this->vue->set($this->dataclass->getListFromCollection($_REQUEST["collection_id"]));
            return $this->vue->send();
        }
    }
}
