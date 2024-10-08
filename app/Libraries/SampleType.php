<?php

namespace App\Libraries;

use App\Models\ContainerType;
use App\Models\Metadata;
use App\Models\MultipleType;
use App\Models\Operation;
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
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return $this->list();
            } else {
                return $this->change();
            }
        } catch (PpciException) {
            return $this->change();
        }
    }

    function delete()
    {
        /*
         * delete record
         */
        try {
            $this->dataDelete($this->id);
            return $this->list();
        } catch (PpciException) {
            return $this->change();
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
        $this->vue->set($this->dataclass->getListFromCollection($_REQUEST["collection_id"]));
        return $this->vue->send();
    }
}
