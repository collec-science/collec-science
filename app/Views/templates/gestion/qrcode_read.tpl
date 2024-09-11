{* Mouvements > Entrer un échantillon > *}
<!--
<script src="display/javascript/adapter.js"></script>
<script
	src="display/javascript/dwa012-html5-qrcode/lib/jsqrcode-combined.min.js"></script>
<script src="display/javascript/html5-qrcode.eq.js"></script>
 -->
 <script src="display/javascript/qcode-decoder/build/qcode-decoder.min.js"></script>
<script>
$(document).ready(function() {
	'use strict';
	var destination = "object";
	var video = document.querySelector("#reader");
    var qr = new QCodeDecoder();
    if (!(qr.isCanvasSupported() && qr.hasGetUserMedia())) {
        //alert('Your browser doesn\'t match the required specs.');
        throw new Error('Canvas and getUserMedia are required');
        $("#optical").hide();
      }

	var db = "{$db}";
	function getDetail(uid, champ) {
		/*
		 * Retourne le detail d'un objet, par interrogation ajax
		 */
		var url = "objectGetDetail";
		var chaine ;
		var is_container = 0;
		if (champ == "container") {
			is_container = 1;
		}

		$.ajax ( { url:url, method:"GET", data : { uid:uid, is_container:is_container }, success : function ( djs ) {
			var data = JSON.parse(djs);
			if (data.length > 0) {
				if (!isNaN(data[0].uid)) {
					var id = "", type="";
					if (data[0].identifier) {
						id = data[0].identifier;
					}
					if (data[0].type_name) {
						type = " (" + data[0].type_name+")";
					}
					chaine = id + type ;
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
		if (value.length > 0) {
			readChange();
		}
	});
	/*
	 * Fonctions pour la lecture du QRCode
	 */
	var is_read = false;
	var snd = new Audio("/display/images/sound.ogg");
	function readChange() {
		/*
		 * Lit le contenu de la zone, et declenche la recherche
		 */
		snd.play();
		var valeur = $("#valeur-scan").val().trim();
		if (valeur.substring(0,3) == "]C1") {
			valeur = valeur.substring(3);
		}
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
		 /*valeur = valeur.replace("[", String.fromCharCode(123));
		 valeur = valeur.replace ("]", String.fromCharCode(125));*/
		var data = JSON.parse(valeur);
		if (data["db"] == db) {
			return data["uid"];
		} else {
			return data["db"]+":"+data["uid"];
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
		 qr.decodeFromCamera(video, resultHandler);
	}
	$('#destContainer').click(function() {
		destination = "container";
		showArrow("container");
		$("#valeur-scan").val("");
		$("#valeur-scan").focus();
	} );
	$('#destObject').click(function() {
		destination = "object";
		showArrow("object");
		$("#valeur-scan").val("");
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
		//$('#reader').html5_qrcode_stop();
		qr.stop();
		is_read == false;
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


showArrow("object");

function resultHandler (err, result) {
    $("#valeur-scan").val(result);
    readChange();
  }

/*
 * Activation automatique de la lecture optique
 */
{if $read_optical == 1}
readEnable();
{/if}

/*
 * Declenche la recherche du container si l'uid est fourni a l'ouverture de la page
 */
 var cuid = $("#container_uid").val();
if (cuid.length > 0) {
	getDetail(cuid, "container");
}
});
</script>
