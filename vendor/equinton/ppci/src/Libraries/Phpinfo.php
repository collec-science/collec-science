<?php
namespace Ppci\Libraries;

class Phpinfo extends PpciLibrary
{
    static function getPhpinfo()
    {
        ob_start();
        phpinfo();
        $phpinfo = ob_get_contents();
        ob_end_clean();
        $vue = service("Smarty");
        $vue->set($phpinfo, "phpinfo");
        $vue->set("ppci/phpinfo.tpl", "corps");
        return $vue->send();
    }
}