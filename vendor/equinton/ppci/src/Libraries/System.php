<?php
namespace Ppci\Libraries;

class System extends PpciLibrary
{
    static protected function systemPrepareData(array $data): array
    {
        $content = array();
        foreach ($data as $k => $v) {
            if (!is_object($v)) {
                if (is_array($v)) {
                    $content[$k] = json_encode($v);
                } else {
                    $content[$k] = $v;
                }
            } else {
                $content[$k] = "object";
            }
        }
        return $content;
    }

    static function index(array $param)
    {
        $vue = service("Smarty");
        $vue->set(System::systemPrepareData($param), "data");
        $vue->set("ppci/utils/system.tpl", "corps");
        return $vue->send();
    }
}