<?php

/**
 * Get the last release of the code for the current software
 *
 * @param string $url : url of the repository
 * @param string $tagName : fieldname which contains the tag number
 * @param string $dateName : fieldname which contains the date of the release
 * @return array
 */
function getLastRelease(string $url, string $tagName, string $dateName, string $userAgent): array
{
    $release = array();
    if (!empty($url)) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        if (!empty($headers)) {
            curl_setopt($ch, CURLOPT_HEADER, $headers);
        }
        curl_setopt($ch, CURLOPT_USERAGENT,$userAgent);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $result = curl_exec($ch);
        curl_close($ch);
        if ($result) {
            $res = json_decode($result, true);
            $release["tag"] = $res[$tagName];
            $release["date"] = $res[$dateName];
        }
    }
    return $release;
}
