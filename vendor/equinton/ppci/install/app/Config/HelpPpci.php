<?php

namespace app\Config;

class HelpPpci
{

    protected $helps = [];

    function getAddress(string $key)
    {
        if (array_key_exists($key, $this->helps)) {
            return ($this->helps[$key]);
        } else {
            return false;
        }
    }
}
