<!-- Ajout rapide d'un échantillon dans un container -->
<script src="display/javascript/adapter.js"></script>
<script
	src="display/javascript/dwa012-html5-qrcode/lib/jsqrcode-combined.min.js"></script>
<script
	src="display/javascript/html5-qrcode.eq.js"></script>
	

<script>
$(document).ready(function() { 
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
		console.log("uid : "+uid);
		$.getJSON ( url, { "module":"objectGetDetail", "uid":uid, "is_container":is_container } , function( data ) {
			if (data != null) {
				if (data.length > 0) {
					chaine = data[0].identifier + " (" + data[0].type_name +")";
					console.log("Retour objectGetDetail : " + chaine);
					$("#"+champ+"_detail").val(chaine);
				} else {
					$("#"+champ+"_uid").val("");
					$("#"+champ+"_detail").val("");
				}
			}
		});
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
	/*
	 * Fonctions pour la lecture du QRCode
	 */
	var is_read = false;
	var destination = "container";
	var snd = new Audio("display/images/sound.ogg"); 
	function readChange() {
		//console.log("destination : "+destination);
		//console.log("valeur : "+ $("#valeur-scan").val());
		snd.play();
		var valeur = $("#valeur-scan").val();
		var value = extractUidVal(valeur);
		$("#" + destination +"_uid").val(value);
		getDetail(value, destination);
	}
	function extractUidVal(valeur) {
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
	$('#start').click(function() {
		destination = "container";
		if (is_read == false) {
			readEnable();
		}
	});
	$('#start2').click(function() {
		destination = "object";
		if (is_read == false) {
			readEnable();
		}
	});


	$('#stop').click(function() {
		$('#reader').html5_qrcode_stop();
	});
/*
 * Activation automatique de la lecture optique
 */
 {if $read_optical == 1}
readEnable();
{/if}

});
</script>
<h2>Entrée rapide d'un échantillon dans le stock</h2>
<div class="row">
<div class="col-md-6">
<form class="form-horizontal protoform" id="fastInputForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="fastInput">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="storage_id" value="0">
<input type="hidden" id="read_optical" name="read_optical" value="{$read_optical}">


<div class="form-group">
<label for="container_groupe" class="control-label col-sm-4">UID du conteneur<span class="red">*</span> :</label>
<div class="col-sm-8" id="container_groupe">
<div class="col-sm-3">
<input id="container_uid" type="text" name="container_uid"  value="{$container_uid}" class="form-control" autocomplete="off" {if strlen($container_uid) == 0}autofocus{/if}>
</div>
<div class="col-sm-3 col-sm-offset-1">
<button type="button" id="container_search" class="btn btn-default">Chercher...</button>
</div>
</div>
<div class="col-sm-8 col-sm-offset-4 ">
<input id="container_detail" type="text" class="form-control" disabled>
</div>
</div>

<div class="form-group">
<label for="object_uid" class="control-label col-sm-4">UID de l'objet<span class="red">*</span> :</label>
<div class="col-sm-8" id="object_groupe">
<div class="col-sm-3">
<input id="object_uid" type="text" name="object_uid"  value="" class="form-control"{if strlen($container_uid) > 0}autofocus{/if} autocomplete="off" >
</div>
<div class="col-sm-3 col-sm-offset-1">
<button type="button" id="object_search" class="btn btn-default">Chercher...</button>
</div>
</div>
<div class="col-sm-8 col-sm-offset-4 ">
<input id="object_detail" type="text" class="form-control" disabled>
</div>
</div>

<div class="form-group">
<label for="storage_range" class="control-label col-sm-4">Emplacement dans le container :</label>
<div class="col-sm-8">
<input id="storage_range" name="storage_range" value="{$data.storage_range}" class="form-control" >
</div>
</div>

<div class="form-group">
<label for="storage_date" class="control-label col-sm-4">Date/heure<span class="red">*</span> :</label>
<div class="col-sm-8">
<input id="storage_date" name="storage_date" required value="{$data.storage_date}" class="form-control datetimepicker" >
</div>
</div>

<div class="form-group">
<label for="storage_comment" class="control-label col-sm-4">Commentaire :</label>
<div class="col-sm-8">
<textarea class="form-control" id="storage_comment" name="storage_comment" rows="3"></textarea>
</div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
 </div>

</form>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>
</div> 
</div>
<!-- Rajout pour la lecture optique -->
<div class="row">
<fieldset>
	<legend>Lecture optique (QRCode uniquement)</legend>
	<div class="col-md-6">
		<div class="form-horizontal protoform">
			<div class="form-group center">
				<button id="start" class="btn btn-success">Lecture du container</button>
				<button id="start2" class="btn btn-success">Lecture de l'objet à entrer</button>
				<button id="stop" class="btn btn-danger">Arrêter la lecture</button>
			</div>
			
			<div class="form-group">
				<label for="valeur-scan" class="control-label col-sm-4">Valeur
					lue :</label>
				<div class="col-sm-8">
					<input id="valeur-scan" type="text" class="form-control" disabled>
				</div>
			</div>
		</div>

	</div>
	</fieldset>
</div>
<div class="row">
	<div class="col-md-6">
	<div class="center">
<div id="reader" style="width: 640px; height: 480px"></div>
</div>

</div>
</div>
