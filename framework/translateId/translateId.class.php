<?php

/**
 * Classe permettant de gerer les remplacements d'identifiants par des cles locales
 *
 * Instanciation :
 * if (!isset($_SESSION["ti_table"])
 * 		$_SESSION["ti_table"] = new TranslateId("cle_name");
 * @author Eric Quinton
 * @copyright Copyright (c) 2015, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 8 juin 2015
 */
class TranslateId
{

    /**
     * Tableau de correspondance entre les identifiants de la base de donnees
     * et les identifiants calcules
     *
     * @var array[$this->cle] = $dbkey;
     */
    private $corresp;

    /**
     * Tableau inverse
     *
     * @var array[$dbkey] = [$this->cle];
     */
    private $corresp_reverse;

    /**
     * Nom de la colonne utilisee pour le codage (cle de la table)
     *
     * @var string
     */
    private $fieldname;

    /**
     * Compteur utilise pour la renumerotation
     *
     * @var int
     */
    private $cle = 1;

    /**
     * Initialisation du champ contenant le nom de la colonne
     *
     * @param string $fieldname
     */
    function __construct($fieldname)
    {
        if (strlen($fieldname) > 0) {
            $this->fieldname = $fieldname;
        }
    }

    /**
     * Transforme toutes les valeurs du tableau
     *
     * @param array $data
     * @param string $fieldname
     *            : nom de la colonne (si non precisee a l'instanciation)
     * @return array
     */
    function translateList($data, $reset = false)
    {
        /*
         * Reinitialisation du tableau
         */
        if ($reset) {
            $this->reinit();
        }
        /*
         * Traitement de chaque ligne du tableau
         */
        foreach ($data as $key => $value) {
            if (isset($value[$this->fieldname])) {
                if (! isset($this->corresp_reverse[$value[$this->fieldname]])) {
                    $this->setValue($value[$this->fieldname]);
                }
                $data[$key][$this->fieldname] = $this->corresp_reverse[$value[$this->fieldname]];
            }
        }
        return $data;
    }

    /**
     * Reinitialisation du tableau
     */
    function reinit()
    {
        $this->cle = 1;
        $this->corresp = array();
        $this->corresp_reverse = array();
    }

    /**
     * Ajoute une valeur dans le tableau si elle n'existe pas
     *
     * @param int $dbId
     * @return int : valeur traduite
     */
    function setValue($dbId)
    {
        if ($dbId > 0) {
            if (! isset($this->corresp_reverse[$dbId])) {
                $this->corresp[$this->cle] = $dbId;
                $this->corresp_reverse[$dbId] = $this->cle;
                $key = $this->cle;
                $this->cle ++;
            } else {
                $key = $this->corresp_reverse[$dbId];
            }
            return $key;
        }
    }

    /**
     * Retourne la cle correspondant a la valeur fournie
     *
     * @param int $id
     * @return multitype:$this->cle |NULL
     */
    function getValue($id)
    {
        if ($id > 0) {
            return $this->corresp[$id];
        } else {
            return 0;
        }
    }

    /**
     * Transform the row: replace the calculate key by the dbkey
     *
     * @param array $row
     * @return array
     */
    function getDbkeyFromRow(array $row) {
        if (isset($row[$this->fieldname])) {
            $row[$this->fieldname] = $this->corresp[$row[$this->fieldname]];
        }
        return $row;
    }

    /**
     * Retourne la valeur calculee correspondant a une cle de la table
     *
     * @param array $row
     * @return array
     */
    function translateRow($row)
    {
        foreach ($row as $key => $value) {
            if ($key == $this->fieldname) {
                if (! isset($this->corresp_reverse[$value])) {
                    $this->setValue($value);
                }
                $value > 0 ? $row[$key] = $this->corresp_reverse[$value] : $row[$key]=0;
                break;
            }
        }
        return $row;
    }

    /**
     * Retourne la liste des valeurs de la base de donnees
     * pour l'ensemble du tableau fourni
     *
     * @param array $data
     * @return array
     */
    function getFromList($data)
    {
        foreach ($data as $key => $value) {
            if (is_array($value)) {
                $data[$key] = $this->getFromList($value);
            } else {
                if ($key == $this->fieldname) {
                    $data[$key] = $this->corresp[$value];
                }
            }
        }
        return $data;
    }
    /**
	 * Fonction retournant la totalite des valeurs traduites
	 * Utilise pour les selections multiples provenant depuis la page html,
	 * sous forme de tableau : [campagne_id] => Array ( [0] => 1 [1] => 3 )
	 *
	 * @param array|int $data
	 */
	function getFromListForAllValue($data) {
		foreach ( $data as $key => $value ) {
			if (is_array ( $value )) {
				$data [$key] = $this->getFromListForAllValue ( $value );
			} else {
				$data [$key] = $this->corresp [$value];
			}
		}
		return $data;
	}

}
