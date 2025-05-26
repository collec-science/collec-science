# API d'ajout d'un document à un objet

## Principe

Cette API permet, depuis une application tierce, d'ajouter une pièce jointe à un objet (échantillon, contenant). L'API autorise soit le téléchargement d'un nouveau fichier, soit le référencement d'un fichier si la collection autorise le stockage externe des documents (cf. [Associer des documents externes à un échantillon](document_external_fr)).

## Identification

Consultez ce document pour créer l'utilisateur de l'API, générer un token et lui donner les droits adéquats : [Identification pour les services web](swidentification_fr)

## Méthode d'appel

> URL : apiv1documentWrite

L'API doit être appelée en mode http **POST**.

## Variables à fournir

| Paramètre  | Contenu                                                                                                                 |
| ------------- | ------------------------------------------------------------------------------------------------------------------------- |
| uid, uuid ou identifier | UID, UUID ou identifiant métier (déconseillé) de l'objet cible (obligatoire)                                                                        |
| token       | jeton d'identification (obligatoire) |
| login       | login associé au jeton (token). Les deux informations doivent être fournies pour que l'identification soit réalisée |
| document_name | nom du document. Si non renseigné, il sera déduit du nom du document transmis |
| document_creation_date | Date de création du document, au format dd/mm/YYYY |
| external_storage_path | Chemin d'accès au fichier, si celui-ci est stocké en dehors de la base de données |

{.table .table-bordered .table-hover}

Si vous renseignez la variable *external_storage_path*, le fichier cible doit exister dans l'arborescence externe et être accessible au serveur web.

## Exemple d'envoi d'un fichier

Voici un exemple d'envoi d'un fichier vers le serveur, écrit en PHP :

~~~
<?php
$address = "https://monsite.collec-science.org";
$params = [
    "login" => "compteapi",
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
        throw new ApiCurlException(_("Impossible d'initialiser le composant curl"));
    }
    if (!empty($file)) {
        $data["file"] = makeCurlFile($file);
    }
    switch ($method) {
        case "POST":
            curl_setopt($curl, CURLOPT_POST, true);
            if (!empty($data)) {
                curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
            }
            break;
        case "PUT":
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
     * Set options
     */
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    if (!empty($certificate_path)) {
        curl_setopt($curl, CURLOPT_SSLCERT, $certificate_path);
    }
    curl_setopt($curl, CURLOPT_SSL_VERIFYSTATUS, false);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0);
    if ($modeDebug) {
        curl_setopt($curl, CURLOPT_VERBOSE, true);
    }
    /**
     * Execute request
     */
    $res = curl_exec($curl);
    if ($res === false) {
        throw new ApiCurlException(
            sprintf(
                _("Une erreur est survenue lors de l'exécution de la requête vers le serveur distant. Code d'erreur CURL : %s"),
                curl_error($curl)
            )
        );
    }
    curl_close($curl);
    return $res;
}
echo "Méthode : " . $method . PHP_EOL;
echo "Adresse : " . $address . "/" . $page . PHP_EOL;
echo "Paramètres" . PHP_EOL;
print_r($params);

$res = apiCall($method, $address . "/" . $page, "", $params, $debugMode, $fileToSend);
if ($res == "null") {
    echo "résultat : null" . PHP_EOL;
} else {
    if ($page == "apiv1documentGet") {
        file_put_contents("test.txt", $res);
    } else {
        print_r(json_decode($res, true));
    }
}
~~~

Ce script est prévu pour s'exécuter en ligne de commande :

~~~
php testapi.php
~~~