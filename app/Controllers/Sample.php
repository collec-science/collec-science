<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Sample as LibrariesSample;

class Sample extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesSample();
}
function list() {
return $this->lib->list();
}
function searchAjax() {
return $this->lib->searchAjax();
}
function getFromId() {
return $this->lib->getFromId();
}
function display() {
return $this->lib->display();
}
function change() {
return $this->lib->change();
}
function write() {
return $this->lib->write();
}
function delete() {
return $this->lib->delete();
}
function export() {
return $this->lib->export();
}
function importStage1() {
return $this->lib->importStage1();
}
function importStage2() {
return $this->lib->importStage2();
}
function deleteMulti() {
return $this->lib->deleteMulti();
}
function referentAssignMulti() {
return $this->lib->referentAssignMulti();
}
function eventAssignMulti() {
return $this->lib->eventAssignMulti();
}
function lendingMulti() {
return $this->lib->lendingMulti();
}
function exitMulti() {
return $this->lib->exitMulti();
}
function entryMulti() {
return $this->lib->entryMulti();
}
function setCountry() {
return $this->lib->setCountry();
}
function setCollection() {
return $this->lib->setCollection();
}
function setCampaign() {
return $this->lib->setCampaign();
}
function setStatus() {
return $this->lib->setStatus();
}
function setParent() {
return $this->lib->setParent();
}
function getChildren() {
return $this->lib->getChildren();
}
}
