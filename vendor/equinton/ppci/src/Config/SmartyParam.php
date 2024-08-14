<?php
namespace Ppci\Config;

use CodeIgniter\Config\BaseConfig;

class SmartyParam extends BaseConfig
{

    public $params = [
        "templateDir" => [ROOTPATH . 'app/Views/templates', ROOTPATH . 'vendor/equinton/ppci/src/Views/templates'],
        "compileDir" => 'writable/templates_c',
        "cache" => false,
        "cache_dir" => "display/smarty_cache",
        "template_main" => "ppci/main.html"
    ];

}