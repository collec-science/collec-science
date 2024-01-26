<?php
/**
 * Operations generated after login
 */
if ($_SESSION["droits"][$APPLI_release_right_minimal] == 1) {
    /**
     * Search from last release and display message if new release
     */
    if (!empty($APPLI_release_url)) {
        $lastRelease = getLastRelease($APPLI_release_url, $APPLI_release_url_tag, $APPLI_release_url_date, $APPLI_release_user_agent, $APPLI_release_description);
        if (!empty($lastRelease["tag"])) {
            if ($APPLI_version != $lastRelease["tag"]) {
                $date = date_create($lastRelease["date"]);
                $message->set(sprintf(_("La nouvelle version %1s du %2s a été publiée !"), $lastRelease["tag"], date_format($date, $_SESSION["MASKDATE"])));
            }
        }
    }
}
