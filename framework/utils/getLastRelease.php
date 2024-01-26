<?php

$vue->set("framework/utils/lastRelease.tpl","corps");
$vue->set($APPLI_version,"currentVersion");
$release = getLastRelease($APPLI_release_url, $APPLI_release_url_tag, $APPLI_release_url_date, $APPLI_release_user_agent, $APPLI_release_description);
$release["date"] = date_format(date_create($release["date"]), $_SESSION["MASKDATE"]);
$vue->set( $release,"release");