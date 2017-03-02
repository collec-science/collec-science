<script src="display/javascript/adapter.js"></script>
<script
	src="display/javascript/dwa012-html5-qrcode/lib/jsqrcode-combined.min.js"></script>
<script src="display/javascript/html5-qrcode.eq.js"></script>


<script>
$(document).ready(function() { 
	var destination = "object";
	
	var db = "{$db}";	
	function getDetail(uid, champ) {
		/*
		 * Retourne le detail d'un objet, par interrogation ajax
		 */
		var url = "index.php";
		var chaine ;
		var is_container = 0;
		if (champ == "container") {
			is_container = 1;
		}
		console.log("fonction getDetail - paramètres : uid : "+uid +" is_container : "+ is_container);
		console.log ("appel ajax");
		//$.getJSON ( url, { "module":"objectGetDetail", "container_family_id":family } , function( data ) {

		$.ajax ( { url:url, method:"GET", data : { module:"objectGetDetail", uid:uid, is_container:is_container }, success : function ( djs ) {
			console.log("interrogation Ajax terminée");
			console.log("data recuperee depuis le serveur : " + djs);
			var data = JSON.parse(djs);
			if (data.length > 0) {
			console.log ("uid extrait de data : "+data[0].uid);
				console.log("traitement de data");
				if (!isNaN(data[0].uid)) {
					var id = "", type="";
					if (data[0].identifier) {
						id = data[0].identifier;
					}
					if (data[0].type_name) {
						type = " (" + data[0].type_name+")";
					}
					chaine = id + type ;
					console.log("Détail associé à l'UID : " + chaine);
					$("#"+champ+"_uid").val(data[0].uid);
					$("#"+champ+"_detail").val(chaine);
				} else {
					$("#"+champ+"_uid").val("");
					$("#"+champ+"_detail").val("");
				}
			} else {
				/*
				 * vidage des champs
				 */
				$("#"+champ+"_uid").val("");
				$("#"+champ+"_detail").val("");
			}
			/*
			 * Reinitialisation de la zone de lecture
			 */
			 $("#valeur-scan").val("");
		}
		} ); 
	}
	
	$("#container_uid").focusout(function () {
		getDetail($("#container_uid").val(), "container");
	});
	$("#container_search").click(function () {
		getDetail($("#container_uid").val(), "container");
	});
	$("#object_uid").focusout(function () {
		getDetail($("#object_uid").val(), "object");
	});
	$("#object_search").click(function () {
		getDetail($("#object_uid").val(), "object");
	});
	$("#valeur-scan").change(function () {
		var value = $(this).val()
		console.log("#valeur-scan change. Value : " + value);
		if (value.length > 0) {
			readChange();
		}
	});
	/*
	 * Fonctions pour la lecture du QRCode
	 */
	var is_read = false;
	var snd = new Audio("display/images/sound.ogg"); 
	function readChange() {
		/*
		 * Lit le contenu de la zone, et declenche la recherche
		 */
		//console.log("destination : "+destination);
		//console.log("valeur : "+ $("#valeur-scan").val());
		snd.play();
		var valeur = $("#valeur-scan").val().trim();
		var firstChar = valeur.substring(0,1);
		var value;
		if (firstChar == "[" || firstChar == String.fromCharCode(123)) {
		value = extractUidValFromJson(valeur);
		$("#" + destination +"_uid").val(value);
		} else if (valeur.substring(0,4) == "http" || valeur.substring(0,3) == "htp") {
			var elements = valeur.split("/");
			var nbelements = elements.length ;
			if (nbelements > 0) {
				value = elements[nbelements - 1];
			}
		} else {
			value = valeur;
		}
		getDetail(value, destination);
	}
	
	function extractUidValFromJson(valeur) {
		/*
		 * Extrait le contenu de la chaine json
		 * Transformation des [] en { }
		 */
		 valeur = valeur.replace("[", String.fromCharCode(123));
		 valeur = valeur.replace ("]", String.fromCharCode(125));
		 console.log("valeur après remplacement suite à lecture douchette :" + valeur);
		var data = JSON.parse(valeur);
		console.log("uid après extraction : "+data["uid"]);
		console.log ("db après extraction : " + data ["db"]);
		if (data["db"] == db) {
			return data["uid"];	
		} else {
			return "";
		}
		
		/*
		 * Recherche s'il s'agit d'une adresse web
		 */
		var adresse = valeur.split("?");
		var variables;
		var a_variables;
		var variable;
		var value = "";
		if (adresse.length == 2) {
			variables = adresse[1];
		} else
			variables = adresse[0];
		/*
		 * Decoupage des variables
		 */
		a_variables = variables.split("&");
		for (i = 0; i < a_variables.length; i++) {
			/*
			 * extraction du nom de la variable
			 */
			variable = a_variables[i].split("=");
			if (variable[0] == "uid") {
				value = variable[1];
				break;
			}
		}
		return value;
	}
	function readEnable() {
		/*
		 * Fonction declenchant la lecture des qrcodes
		 */
		is_read = true;
		$("#read_optical").val("1");
		$('#reader').html5_qrcode(function(data) {
			// do something when code is read
			$("#valeur-scan").val(data);
			readChange();
		}, function(error) {
			//show read errors 
			//console.log(error);
		}, function(videoError) {
			//the video stream could be opened
			$("#valeur-scan").val(videoError);
			console.log(videoError);
		});
	}
	$('#destContainer').click(function() {
		destination = "container";
		showArrow("container");
		$("#valeur-scan").focus();
	} );
	$('#destObject').click(function() {
		destination = "object";
		showArrow("object");
		$("#valeur-scan").focus();
	} );
	
	$('#start').click(function() {
		destination = "container";
		showArrow("container");
		if (is_read == false) {
			readEnable();
		}
	});
	$('#start2').click(function() {
		destination = "object";
		showArrow("object");
		if (is_read == false) {
			readEnable();
		}
	});


	$('#stop').click(function() {
		$('#reader').html5_qrcode_stop();
	});
	function showArrow(type) {
		if (type == "object") {
			$("#arrow-object").show();
			$("#arrow-container").hide();
		} else {
			$("#arrow-object").hide();
			$("#arrow-container").show();
		}
	}
/*
 * Activation automatique de la lecture optique
 */
 {if $read_optical == 1}
readEnable();
{/if}
showArrow("object");
/*
 * Declenche la recherche du container si l'uid est fourni a l'ouverture de la page
 */
 var cuid = $("#container_uid").val();
if (cuid.length > 0) {
	getDetail(cuid, "container");
}
});
</script>