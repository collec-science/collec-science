<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Xx extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $dataclass;

    private $keyName;

function __construct()
    {
        parent::__construct();
        $this->dataClass = new XXX();
        $this->keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
require_once 'modules/classes/campaign_regulation.class.php';
$this->dataclass = new CampaignRegulation();
$this->keyName = "campaign_regulation_id";
$this->id = $_REQUEST[$this->keyName];


  function change(){
$this->vue=service('Smarty');
    $data = $this->dataRead( $this->id, "param/campaignRegulationChange.tpl", $_REQUEST["campaign_id"]);
    require_once "modules/classes/regulation.class.php";
    require_once "modules/classes/campaign.class.php";
    $regulation = new Regulation();
    $campaign = new Campaign();
    $this->vue->set($regulation->getListe("regulation_name"), "regulations");
    $this->vue->set($campaign->getListe($data["campaign_id"]), "campaign");
    }
      function write() {
    try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return $this->display();
            } else {
                return $this->change();
            }
        } catch (PpciException) {
            return $this->change();
        }
    }
    /*
   * write record in database
   */
    $this->dataWrite( $_REQUEST);
    }
  function delete(){
    /*
   * delete record
   */
     try {
            $this->dataDelete($this->id);
            return $this->list();
        } catch (PpciException $e) {
            return $this->change();
        }
    }
}
