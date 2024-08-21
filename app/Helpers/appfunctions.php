<?php

/**
 * Sort list files on name
 *
 * @param string $a
 * @param string $b
 * @return int
 */
function cmp($a, $b)
{
    return strcmp($a["name"], $b["name"]);
}

function collectionVerify(int $collection_id): bool
{
    $ok = false;
    foreach ($_SESSION["collections"] as $collection) {
        if ($collection["collection_id"] == $collection_id) {
            $ok = true;
            break;
        }
    }
    return $ok;
}

/**
 * This function transforms the php.ini notation for numbers (like '2M') to an integer (2*1024*1024 in this case)
 * 
 * @param string $sSize
 * @return integer The value in bytes
 */
function convertPHPSizeToBytes($sSize)
{
    //
    $sSuffix = strtoupper(substr($sSize, -1));
    if (!in_array($sSuffix, array('P', 'T', 'G', 'M', 'K'))) {
        return (int)$sSize;
    }
    $iValue = substr($sSize, 0, -1);
    switch ($sSuffix) {
        case 'P':
            $iValue *= 1024;
            // Fallthrough intended
        case 'T':
            $iValue *= 1024;
            // Fallthrough intended
        case 'G':
            $iValue *= 1024;
            // Fallthrough intended
        case 'M':
            $iValue *= 1024;
            // Fallthrough intended
        case 'K':
            $iValue *= 1024;
            break;
    }
    return (int)$iValue;
}
/**
 * This function returns the maximum files size that can be uploaded 
 * in PHP
 * @returns int File size in bytes
 **/
function getMaximumFileUploadSize()
{
    return min(convertPHPSizeToBytes(ini_get('post_max_size')), convertPHPSizeToBytes(ini_get('upload_max_filesize')));
}
