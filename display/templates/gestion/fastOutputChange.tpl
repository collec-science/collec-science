<!-- Sortie rapide d'un échantillon du stock -->
<script
	src="display/javascript/dwa012-html5-qrcode/lib/jsqrcode-combined.min.js"></script>
<script
	src="display/javascript/dwa012-html5-qrcode/lib/html5-qrcode.min.js"></script>

<script>
	$(document).ready(
			function() {
				function getDetail(uid, champ) {
					/*
					 * Retourne le detail d'un objet, par interrogation ajax
					 */
					var url = "index.php";
					var chaine;
					var is_container = 0;
					if (champ == "container") {
						is_container = 1;
					}
					console.log("uid : " + uid);
					$.getJSON(url, {
						"module" : "objectGetDetail",
						"uid" : uid,
						"is_container" : is_container
					}, function(data) {
						if (data != null) {
							if (data.length > 0) {
								chaine = data[0].identifier + " ("
										+ data[0].type_name + ")";
								console.log("Retour objectGetDetail : "
										+ chaine);
								$("#" + champ + "_detail").val(chaine);
							} else {
								$("#" + champ + "_uid").val("");
								$("#" + champ + "_detail").val("");
							}
						}
					});
				}

				$("#object_uid").focusout(function() {
					getDetail($("#object_uid").val(), "object");
				});
				$("#object_search").click(function() {
					getDetail($("#object_uid").val(), "object");
				});
				/*
				 * Fonctions pour la lecture du QRCode
				 */
				var is_read = false;
				var destination = "object_uid";
				function readChange() {
					//console.log("destination : "+destination);
					//console.log("valeur : "+ $("#valeur-scan").val());
					var valeur = $("#valeur-scan").val();
					var value = extractUidVal(valeur);
					$("#" + destination).val(value);
					getDetail(value, "object");
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
					destination = "object_uid";
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
<h2>{$LANG["menu"].75}</h2>

<div class="row">
	<div class="col-md-6">
		<form class="form-horizontal protoform" id="fastOutputForm"
			method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="fastOutput"> <input
				type="hidden" name="action" value="Write"> <input
				type="hidden" name="storage_id" value="0">
				<input type="hidden" id="read_optical" name="read_optical" value="{$read_optical}">

			<div class="form-group">
				<label for="object_uid" class="control-label col-md-4">UID
					de l'objet<span class="red">*</span> :
				</label>
				<div class="col-md-8" id="object_groupe">
					<div class="col-md-3">
						<input id="object_uid" type="text" name="object_uid" value=""
							class="form-control" autofocus autocomplete="off">
					</div>
					<div class="col-md-3 col-md-offset-1">
						<button type="button" id="object_search" class="btn btn-default">Chercher...</button>
					</div>
				</div>
				<div class="col-md-8 col-md-offset-4 ">
					<input id="object_detail" type="text" class="form-control" disabled>
				</div>
			</div>

			<div class="form-group">
				<label for="storage_date" class="control-label col-md-4">Date/heure<span
					class="red">*</span> :
				</label>
				<div class="col-md-8">
					<input id="storage_date" name="storage_date" required
						value="{$data.storage_date}" class="form-control datetimepicker">
				</div>
			</div>

			<div class="form-group">
				<label for="storage_comment" class="control-label col-md-4">Commentaire
					:</label>
				<div class="col-md-8">
					<textarea class="form-control" id="storage_comment"
						name="storage_comment" rows="3"></textarea>
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
				<button id="start" class="btn btn-success">Activer la lecture</button>
				<button id="stop" class="btn btn-danger">Arrêter la lecture</button>
			</div>
			<div class="form-group">
				<label for="valeur-scan" class="control-label col-md-4">Valeur
					lue :</label>
				<div class="col-md-8">
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
<div id="reader" style="width: 300px; height: 250px"></div>
</div>
</div>
</div>
