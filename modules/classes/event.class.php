<?php

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Event extends ObjetBDD
{
        private $sql = "select * from event
            join event_type using (event_type_id)";
        /**
         *
         * @param PDO $bdd
         * @param array $param
         */
        function __construct($bdd, $param = array())
        {
                $this->table = "event";
                $this->colonnes = array(
                        "event_id" => array(
                                "type" => 1,
                                "key" => 1,
                                "requis" => 1,
                                "defaultValue" => 0
                        ),
                        "uid" => array(
                                "type" => 1,
                                "requis" => 1,
                                "parentAttrib" => 1
                        ),
                        "event_date" => array(
                                "type" => 2,
                                "defaultValue" => "getDateJour"
                        ),
                        "event_type_id" => array(
                                "type" => 1,
                                "requis" => 1
                        ),
                        "still_available" => array(
                                "type" => 0
                        ),
                        "event_comment" => array(
                                "type" => 0
                        ),
                        "due_date" => array("type" => 2)
                );
                parent::__construct($bdd, $param);
        }
        /**
         * Retourne la liste avec les tables liees pour un uid
         * @param unknown $uid
         */
        function getListeFromUid($uid)
        {
                if ($uid > 0 && is_numeric($uid)) {
                        $where = " where uid = :uid";
                        $data["uid"] = $uid;
                        $order = " order by event_date desc";
                        return parent::getListeParamAsPrepared($this->sql . $where . $order, $data);
                }
        }
        /**
         * Search events where due date is between date interval, with or without done
         *
         * @param string $dateFrom
         * @param string $dateTo
         * @param integer $isDone -1: not realized, 0:indifferent, 1, realized
         * @param integer $collection_id
         * @param integer $event_type_id
         * @return array|null
         */
        function searchDueEvent(string $searchType, string $dateFrom, string $dateTo, int $isDone = 0, int $collection_id = 0, int $event_type_id = 0, int $object_type_id = 0, int $object_type = 1): ?array
        {
                $searchType == "due_date" ? $search = "due_date" : $search = "event_date";
                if ($object_type == 1) {
                        $colonnes = ",sample_type_name, 'sample' as object_type";
                        $jointure = "join sample using (uid)
                                join sample_type using (sample_type_id)";
                        $fieldName = "sample_type_id";
                } else {
                        $colonnes = ",container_type_name, 'container' as object_type";
                        $jointure = "join container using (uid)
                                join container_type using (container_type_id)";
                        $fieldName = "container_type_id";
                }
                $sql = "select uid, identifier, event_date, due_date, event_id
                        ,event_type_id, event_type_name, event_comment
                        ,still_available
                        $colonnes
                        from event
                        join object using (uid)
                        join event_type using (event_type_id)
                        $jointure";
                $sql .= " where $search between :datefrom and :dateto";
                if ($isDone == -1) {
                        $sql .= " and event_date is null";
                } elseif ($isDone == 1) {
                        $sql .= " and event_date is not null";
                }
                $data =  array(
                        "datefrom" => $this->formatDateLocaleVersDB($dateFrom),
                        "dateto" => $this->formatDateLocaleVersDB($dateTo)
                );
                if ($collection_id > 0) {
                        $sql .= " and collection_id = :collection_id";
                        $data["collection_id"] = $collection_id;
                }
                if ($event_type_id > 0) {
                        $sql .= " and event_type_id = :event_type_id";
                        $data["event_type_id"] = $event_type_id;
                }
                if ($object_type_id > 0) {
                        $sql .= " and $fieldName = :object_type_id";
                        $data["object_type_id"] = $object_type_id;
                }
                return $this->getListeParamAsPrepared($sql, $data);
        }
}
