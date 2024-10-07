<?php

namespace App\Config;

use Ppci\Config\RightsPpci;

/**
 * List of all rights required by modules
 */
class Rights extends RightsPpci
{
    protected array $rights = [
        "gestion" => ["management"]
    ];
}
