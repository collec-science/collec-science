<?php

/**
 * Classe de base pour gerer des parametres de recherche
 * Classe non instanciable, a heriter
 * L'instance doit etre conservee en variable de session
 * @author Eric Quinton
 *
 */
class SearchParam
{

  /**
   * Tableau des parametres geres par la classe
   * La liste des parametres doit etre declaree dans la fonction construct
   *
   * @var array
   */
  public $param;

  public $paramNum;

  /**
   * Indique si la lecture des parametres a ete realisee au moins une fois
   * Permet ainsi de declencher ou non la recherche
   *
   * @var int
   */
  public $isSearch;

  /**
   * Constructeur de la classe
   * A rappeler systematiquement pour initialiser isSearch
   */
  function __construct()
  {
    if (!is_array($this->param)) {
      $this->param = array();
    }
    $this->isSearch = 0;
    $this->param["isSearch"] = 0;
    if (is_array($this->paramNum)) {
      $this->paramNum = array_flip($this->paramNum);
    }
  }

  /**
   * Stocke les parametres fournis
   *
   * @param array $data
   *            : tableau des valeurs, ou non de la variable
   * @param string $valeur
   *            : valeur a renseigner, dans le cas ou la donnee est unique
   */
  function setParam($data, $valeur = NULL)
  {
    if (is_array($data)) {
      /**
       * Les donnees sont fournies sous forme de tableau
       */
      foreach ($this->param as $key => $value) {
        /**
         * Recherche si une valeur de $data correspond a un parametre
         */
        if (isset($data[$key])) {
          /**
           * Recherche si la valeur doit etre numerique
           */
          if (isset($this->paramNum[$key])) {
            if (!is_numeric($data[$key])) {
              $data[$key] = "";
            }
          }
          $this->param[$key] = $data[$key];
        }
      }
    } else {
      /**
       * Une donnee unique est fournie
       */
      if (isset($this->param[$data]) && !is_null($valeur)) {
        if (isset($this->paramNum[$data])) {
          if (!is_numeric($valeur)) {
            $valeur = "";
          }
        }
        $this->param[$data] = $valeur;
      }
    }
    /**
     * Gestion de l'indicateur de recherche
     */
    if ($data["isSearch"] == 1) {
      $this->isSearch = 1;
    }
  }

  /**
   * Retourne les parametres existants
   */
  function getParam()
  {
    return $this->param;
  }

  /**
   * Indique si la recherche a ete deja lancee
   *
   * @return int
   */
  function isSearch()
  {
    if ($this->isSearch == 1) {
      return 1;
    } else {
      return 0;
    }
  }

  /**
   * Encode les donnees avant de les envoyer au navigateur
   *
   * @param unknown $data
   * @return string|array
   */
  function encodeData($data)
  {
    if (is_array($data)) {
      foreach ($data as $key => $value) {
        $data[$key] = $this->encodeData($value);
      }
    } else {
      $data = htmlspecialchars($data);
    }
    return $data;
  }
  /**
   * Get the parameters in a JSON string
   *
   * @return string
   */
  function getParamAsJson()
  {
    return json_encode($this->param);
  }
  /**
   * Init the values with the content of a json string
   *
   * @param string $content
   * @return void
   */
  function setParamFromJson($content)
  {
    $this->setParam(json_decode($content, true));
  }

  /**
   * Function used to reinit some fields
   */
  function reinit()
  {
  }
}

/**
 * Exemple d'instanciation
 *
 * @author Eric Quinton
 *
 */
class SearchExample extends SearchParam
{

  function __construct()
  {
    $this->param = array(
      "comment" => "",
      "numero" => 0,
      "numero1" => "",
      "dateExample" => date($_SESSION["MASKDATE"])
    );
    $this->paramNum = array(
      "numero",
      "numero1"
    );
    parent::__construct();
  }
}

/**
 * Classe de recherche des contenants
 *
 * @author quinton
 *
 */
class SearchContainer extends SearchParam
{
  function __construct()
  {
    $this->param = array(
      "name" => "",
      "container_family_id" => "",
      "container_type_id" => "",
      "limit" => 100,
      "object_status_id" => 1,
      "uid_min" => 0,
      "uid_max" => 0,
      "select_date" => "",
      "date_from" => date($_SESSION["MASKDATE"]),
      "date_to" => date($_SESSION["MASKDATE"]),
      "trashed" => 0,
      "referent_id" => "",
      "event_type_id" => "",
      "movement_reason_id" => ""
    );
    /**
     * Ajout des dates
     */
    $this->reinit();
    $this->paramNum = array(
      "container_family_id",
      "container_type_id",
      "limit",
      "object_status_id",
      "uid_min",
      "uid_max",
      "trashed",
      "referent_id",
      "event_type_id",
      "movement_reason_id"
    );
    parent::__construct();
  }
  function reinit()
  {
    $ds = new DateTime();
    $ds->modify("-1 year");
    $this->param["date_from"] = $ds->format($_SESSION["MASKDATE"]);
    $this->param["date_to"] = date($_SESSION["MASKDATE"]);
  }
}

class SearchSample extends SearchParam
{

  function __construct()
  {
    $this->param = array(
      "name" => "",
      "sample_type_id" => "",
      "collection_id" => "",
      "limit" => 100,
      "object_status_id" => 1,
      "uid_min" => 0,
      "uid_max" => 0,
      "sampling_place_id" => "",
      "metadata_field" => "",
      "metadata_value" => "",
      "select_date" => "",
      "referent_id" => "",
      "movement_reason_id" => "",
      "trashed" => 0,
      "SouthWestlon" => "",
      "SouthWestlat" => "",
      "NorthEastlon" => "",
      "NorthEastlat" => "",
      "campaign_id" => "",
      "country_id" => "",
      "country_origin_id"=>"",
      "authorization_number" => "",
      "event_type_id" => "",
      "subsample_quantity_min" => "",
      "subsample_quantity_max" => "",
      "booking_type" => 0
    );
    /**
     * Ajout des dates
     */
    $this->reinit();
    $this->paramNum = array(
      "sample_type_id" => 0,
      "collection_id",
      "object_status_id" => 1,
      "limit",
      "uid_min",
      "uid_max",
      "sampling_place_id" => 0,
      "referent_id",
      "movement_reason_id",
      "trashed",
      "SouthWestlon",
      "SouthWestlat",
      "NorthEastlon",
      "NorthEastlat",
      "campaign_id",
      "country_id" => 0,
      "country_origin_id"=>0,
      "event_type_id",
      "subsample_quantity_min",
      "subsample_quantity_max",
      "booking_type" => 0
    );
    parent::__construct();
  }

  function reinit()
  {
    $ds = new DateTime();
    $ds->modify("-1 year");
    $this->param["date_from"] = $ds->format($_SESSION["MASKDATE"]);
    $this->param["date_to"] = date($_SESSION["MASKDATE"]);
    $this->param["booking_from"] = date($_SESSION["MASKDATE"]);
    $this->param["booking_to"] = date($_SESSION["MASKDATE"]);
  }
}

class SearchMovement extends SearchParam
{

  function __construct()
  {
    $this->param = array(
      "login" => ""
    );
    $this->reinit();
    parent::__construct();
  }

  function reinit()
  {
    $ds = new DateTime();
    $ds->modify("-1 month");
    $this->param["date_start"] = $ds->format($_SESSION["MASKDATE"]);
    $this->param["date_end"] = date($_SESSION["MASKDATE"]);
  }
}
