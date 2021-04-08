# Appeler une API

Certaines API peuvent être disponibles, notamment pour modifier des informations depuis une application tierce.

L'identification est gérée par un login et un token, à fournir lors de l'appel parmi les variables. Pour plus d'informations concernant la création d'un compte dédié et la génération du token, consultez le document suivant : [Identification pour les services web](index.php?module=swidentification_fr) 

## Exemple d'appel en PHP

	class ApiCurlException extends Exception{};
	/**
	 * call a api with curl
	 * code from
	 * @param string $method
	 * @param string $url
	 * @param array $data
	 * @return void
	 */
	function apiCall($method, $url, $certificate_path = "", $data = array(), $modeDebug = false)
	{
	  $curl = curl_init();
	  if (!$curl) {
	    throw new ApiCurlException(_("Impossible d'initialiser le composant curl"));
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
	      }
	  }
	  /**
	   * Set options
	   */
	  curl_setopt($curl, CURLOPT_URL, $url);
	  curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

	  if (!empty($certificate_path)){
	    curl_setopt($curl, CURLOPT_SSLCERT, $certificate_path);
	  }
	  if ($modeDebug) {
	    curl_setopt($curl, CURLOPT_SSL_VERIFYSTATUS, false);
	    curl_setopt ($curl, CURLOPT_SSL_VERIFYPEER, false);
	    curl_setopt($curl,CURLOPT_SSL_VERIFYHOST, 0 );
	    curl_setopt($curl, CURLOPT_VERBOSE, true);
	  }
	  /**
	   * Execute request
	   */
	  $res = curl_exec($curl);
	  if (!$res) {
	    throw new ApiCurlException(sprintf(_("Une erreur est survenue lors de l'exécution de la requête vers le serveur distant. Code d'erreur CURL : %s"), curl_error($curl)));
	  }
	  curl_close($curl);
	  return $res;
	}

### Paramètres

- method : GET, POST, PUT, DELETE (non implémenté dans la fonction). Pour les écritures, il est préférable d'indiquer POST, et de ne conserver GET que pour obtenir des informations sur un item. La méthode PUT est traitée comme la méthode POST.
- url : adresse de l'API, par exemple *collec.mysociety.com/index.php?module=apiv1sampleWrite*
- certificate_path : chemin d'accès au certificat du serveur distant. En production, le certificat doit être valide et être généré par une autorité de certification reconnue par votre serveur
- data : tableau contenant l'ensemble des variables à transmettre au serveur. Ce tableau doit impérativement contenir :
	- login : le login du compte autorisé à utiliser l'API
	- token : le token associé à ce compte
- modeDebug : si à *true*, les contrôles de certificats sont inhibés. À ne jamais utiliser en production !

### Exemple d'appel

Cet exemple est utilisé dans l'application *metabo*, et permet de créer un échantillon dans une instance Collec-Science.

	$uidMin = 99999999;
	      $uidMax = 0;
	      try {
	        if (empty($_POST["samples"])) {
	          throw new SampleException(_("Aucun échantillon n'a été sélectionné"));
	        }
	        /**
	         * Verify the parameters for Collec-science
	         */
	        if (empty($_SESSION["collec_token"]) || empty($_SESSION["collec_sample_address"] || empty($_SESSION["collec_login"]))) {
	          throw new SampleException(_("Les paramètres pour Collec-Science n'ont pas été renseignés"));
	        }
	        foreach ($_POST["samples"] as $sample_id) {
	          $dataClass->auto_date = 0;
	          $dataSample = $dataClass->getDetail($sample_id);
	          if (empty($dataSample["uuid"])) {
	            throw new SampleException(sprintf(_("Impossible de lire les informations de l'échantillon %s"), $sample_id));
	          }
	          if (!projectVerify($dataSample["project_id"])) {
	            throw new SampleException(sprintf(_("Vous ne disposez pas des droits nécessaires sur l'échantillon %s"), $sample_id));
	          }
	          $data = array();
	          $data["sample_type_name"] = $dataSample["collec_type_name"];
	          $data["sampling_date"] = $dataSample["sampling_date"];
	          $data["identifier"] = $dataSample["sample_name"];
	          $data["uuid"] = $dataSample["uuid"];
	          $data["station_name"] = $dataSample["station_name"];
	          $data["wgs84_x"] = $dataSample["wgs84_x"];
	          $data["wgs84_y"] = $dataSample["wgs84_y"];
	          $data["token"] = $_SESSION["collec_token"];
	          $data["login"] = $_SESSION["collec_login"];
	          $debugMode = true;
	          $result_json = apiCall("POST", $_SESSION["collec_sample_address"], "", $data, $debugMode);
	          $result = json_decode($result_json, true);
	          if ($result["error_code"] != 200) {
	            throw new SampleException(sprintf(_("L'erreur %1\$s a été générée lors du traitement de l'échantillon %3\$s : %2\$s"), $result["error_code"], $result["error_message"] . " " . $result["error_detail"], $sample_id));
	          }
	          $uid = $result['uid'];
	          if ($uid > 0) {
	            if ($uid < $uidMin) {
	              $uidMin = $uid;
	            }
	            if ($uid > $uidMax) {
	              $uidMax = $uid;
	            }
	          }
	        }
	        $module_coderetour = 1;
	      } catch (Exception $e) {
	        $message->set($e->getMessage(), true);
	        $module_coderetour = -1;
	      } finally {
	        if ($uidMax > 0) {
	          $message->set(sprintf(_("UID min traité : %s"), $uidMin));
	          $message->set(sprintf(_("UID max traité : %s"), $uidMax));
	        }
	      }


