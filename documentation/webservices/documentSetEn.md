# API for adding a document to an object

## Principle

This API allows you to add an attachment to an object (sample, container) from a third-party application. The API allows you to either upload a new file or reference a file if the collection allows external storage of documents (see [Associating external documents with a sample](document_external_en)).

## Identification

Refer to this document to create the API user, generate a token, and grant them the appropriate permissions: [Identification for web services](swidentification_en)

## Call method

> URL: apiv1documentWrite

The API must be called in HTTP **POST** mode.

## Variables to provide

| Parameter | Content |
| ------------- | ------------------------------------------------------------------------------------------------------------------------- |
| uid, uuid, or identifier | UID, UUID, or business identifier (not recommended) of the target object (required) |
| token | identification token (required) |
| login | login associated with the token. Both pieces of information must be provided for identification to be performed |
| document_name | document name. If not specified, it will be derived from the name of the transmitted document |
| document_creation_date | Document creation date, in dd/mm/YYYY format |
| external_storage_path | File path, if stored outside the database |

{.table .table-bordered .table-hover}

If you specify the *external_storage_path* variable, the target file must exist in the external tree structure and be accessible to the web server.

## Example of sending a file

Here is an example of sending a file to the server, written in PHP:

~~~
<?php
$address = "https://mysite.collec-science.org";
$params = [
"login" => "apiaccount",
"token" => "SECRET",
"uid" => 1234
];
$fileToSend = "/home/equinton/Images/eel.jpg";
$method = "POST";
$debugMode = false;
class ApiCurlException extends Exception {};
function makeCurlFile($file)
{
$mime = mime_content_type($file);
$info = pathinfo($file);
$name = $info['basename'];
$output = new CURLFile($file, $mime, $name);
return $output;
}
function apiCall($method, $url, $certificate_path = "", $data = array(), $modeDebug = false, $file = "")
{ 
$curl = curl_init($url); 
if (!$curl) { 
throw new ApiCurlException(_("Unable to initialize curl component")); 
} 
if (!empty($file)) { 
$data["file"] = makeCurlFile($file); 
} 
switch ($method) { 
“POST” box: 
curl_setopt($curl, CURLOPT_POST, true); 
if (!empty($data)) { 
curl_setopt($curl, CURLOPT_POSTFIELDS, $data); 
} 
break; 
“PUT” box: 
curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT"); 
if (!empty($data)) { 
curl_setopt($curl, CURLOPT_POSTFIELDS, $data); 
} 
break; 
default: 
if (!empty($data)) { 
$url = sprintf("%s?%s", $url, http_build_query($data)); 
echo "URL: $url" . PHP_EOL; 
} 
} 
/** 
*Set options 
*/ 
curl_setopt($curl, CURLOPT_URL, $url); 
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1); 
if (!empty($certificate_path)) { 
curl_setopt($curl, CURLOPT_SSLCERT, $certificate_path); 
} 
curl_setopt($curl, CURLOPT_SSL_VERIFYSTATUS, false); 
curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false); 
curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0); 
if ($debugmode) { 
curl_setopt($curl, CURLOPT_VERBOSE, true); 
} 
/** 
* Execute request 
*/ 
$res = curl_exec($curl); 
if ($res === false) {
throw new ApiCurlException(
sprintf(
_("An error occurred while executing the request to the remote server. CURL error code: %s"),
curl_error($curl)
)
);
}
curl_close($curl);
return $res;
}
echo "Method: " . $method . PHP_EOL;
echo "Address: " . $address . "/" . $page . PHP_EOL;
echo "Parameters" . PHP_EOL;
print_r($params);

$res = apiCall($method, $address . "/" . $page, "", $params, $debugMode, $fileToSend);
if ($res == "null") {
echo "result: null" . PHP_EOL;
} else {
if ($page == "apiv1documentGet") {
file_put_contents("test.txt", $res);
} else {
print_r(json_decode($res, true));
}
}
~~~

This script is designed to run from the command line:

~~~
php testapi.php
~~~