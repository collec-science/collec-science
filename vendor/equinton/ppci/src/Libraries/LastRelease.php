<?php

namespace Ppci\Libraries;


class LastRelease extends PpciLibrary
{
    function index()
    {
        $release = $this->getRelease();
        if (!empty($release)) {
            $vue = service('Smarty');
            $vue->set("ppci/utils/lastRelease.tpl", "corps");
            $vue->set($this->appConfig->version, "currentVersion");
            $vue->set($release, "release");
            return $vue->send();
        } else {
            $this->message->set(_("Impossible de récupérer la dernière version publiée de l'application"), true);
            return  defaultPage();
        }
    }
    function getRelease(): array
    {
        $params = $this->appConfig->APPLI_release;
        $release = array();
        if (!empty($params["url"])) {
            $ch = curl_init($params["url"]);
            /*if (!empty($headers)) {
                curl_setopt($ch, CURLOPT_HEADER, $headers);
            }*/
            if ($params["provider"] == "github") {
                curl_setopt($ch, CURLOPT_USERAGENT, $params["user_agent"]);
            }
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
            $result = curl_exec($ch);
            curl_close($ch);
            if (!$result) {
                $this->message->set(_("Impossible de récupérer la dernière version publiée de l'application"), true);
            } else {
                $res = json_decode($result, true);
                $release["tag"] = $res[$params["tag"]];
                $release["description"] = $res[$params["description"]];
                if (isset($_SESSION["date"]["maskdate"])) {
                    $maskdate = $_SESSION["date"]["maskdate"];
                } else {
                    $maskdate = 'd/m/Y';
                }
                $release["date"] = date_create($res[$params["date"]])->format($maskdate);
            }
        }
        return $release;
    }
    function check()
    {
        $release = $this->getRelease();
        if (!empty($release) && $this->appConfig->version != $release["tag"]) {
            $date = date_create($release["date"]);
            $this->message->set(sprintf(_("La nouvelle version %1s du %2s a été publiée !"), $release["tag"], $release["date"]));
        }
    }
}
