<?php
namespace App\Libraries;

use Ppci\Models\PpciModel;

class PpciExtends extends PpciModel {

    function deleteChildrenForGroup(int $id) {
        /**
         * delete reference of group in table collection
         */
        $sql = "DELETE from collection_group where aclgroup_id = :id:";
        $this->executeQuery($sql, ["id"=>$id], true);
    }
}