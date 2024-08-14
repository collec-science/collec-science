<?php
namespace Ppci\Libraries\Views;

class DefaultView 
    {

        /**
         * Donnees a envoyer (cas hors html)
         *
         * @var string|array
         */
        protected $data;
    
        /**
         * Assigne une valeur
         *
         * @param $value
         * @param string $variable
         */
        function set($value, $variable = "")
        {
            if (!empty($variable)) {
                $this->data[$variable] = $value;
            } else {
                $this->data = $value;
            }
        }
    
        /**
         * Declenche l'affichage
         *
         * @param string $param
         */
        function send($param = "")
        {
        }
    
        /**
         * Return the content of a variable
         *
         * @param string $variable
         * @return string|array
         */
        function get($variable = "")
        {
            if (!empty($variable)) {
                return $this->data[$variable];
            } else {
                return $this->data;
            }
        }
    
        /**
         * Fonction recursive d'encodage html
         * des variables
         *
         * @param string|array $data
         * @return string
         */
        function encodehtml($data)
        {
            if (!is_object($data)) {
                if (is_array($data)) {
                    foreach ($data as $key => $value) {
    
                        $data[$key] = $this->encodehtml($value);
                    }
                } else {
                    $data = htmlspecialchars($data, ENT_QUOTES);
                }
            } else {
                $data = null;
            }
            return $data;
        }
    }
    