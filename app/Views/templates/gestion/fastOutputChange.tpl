<script>
	$(document).ready(function () {
		var destination = "object_search";
		function setResult(label, result) {
			$("#" + destination).val(result.data);
			snd.play();
			$("#" + destination).change();
			scanner.stop();
		}
		$('#start2').click(function () {
			$("#video-container").show();
			scanner.start().then(() => {
				updateFlashAvailability();
				searchCamera();
			});

		});
		$('#stop').click(function () {
			$("#video-container").hide();
			scanner.stop();
		});
	});
</script>
{include file="gestion/qrcode_read.tpl"}
<div class="container">
	<h2>{t}Sortir du stock{/t}</h2>

	<div class="row">
		<form class="form-horizontal  fastform" id="fastOutputForm" method="post" action="fastOutputWrite">
			<input type="hidden" name="moduleBase" value="fastOutput">
			<input type="hidden" name="movement_id" value="0"> <input type="hidden" id="read_optical" name="read_optical" value="{$read_optical}">

			<div class="row">
				<label for="object_uid" class="form-label col-4"><span class="red">*</span>
					{t}UID de l'objet :{/t}</label>
				<div class="col-4" id="object_groupe">
					<input id="object_uid" type="text" name="object_uid" value="" class="form-control" required autofocus autocomplete="off">
				</div>
				<div class="col-auto">
					<button type="button" id="object_search" class="btn btn-secondary">{t}Chercher...{/t}</button>
				</div>
			</div>
			<div class="row">
				<div class="col-8 offset-4 ">
					<input id="object_detail" type="text" class="form-control" disabled>
				</div>
			</div>

			<div class="row">
				<label for="movement_date" class="form-label col-4"><span class="red">*</span>
					{t}Date/heure :{/t}</label>
				<div class="col-8">
					<input id="movement_date" name="movement_date" required value="{$data.movement_date}" class="form-control datetimepicker">
				</div>
			</div>
			<div class="row">
				<label for="movement_reason_id" class="form-label col-4">{t}Motif du déstockage :{/t}</label>
				<div class="col-8">
					<select id="movement_reason_id" name="movement_reason_id" class="form-select">
						<option value="" {if $data.movement_reason_id=="" }selected{/if}>{t}Choisissez...{/t}</option>
						{section name=lst loop=$movementReason}
						<option value="{$movementReason[lst].movement_reason_id}" {if $data.movement_reason_id==$movementReason[lst].movement_reason_id}selected{/if}>
							{$movementReason[lst].movement_reason_name}
						</option>
						{/section}
					</select>
				</div>
			</div>
			<div class="row">
				<label for="movement_comment" class="form-label col-4">{t}Commentaire :{/t}</label>
				<div class="col-8">
					<textarea class="form-control" id="movement_comment" name="movement_comment" rows="3"></textarea>
				</div>
			</div>
			<div class="row d-inline">
				<span class="messagebas"><span class="red">*</span>&nbsp;{t}Donnée obligatoire{/t}</span>
			</div>
			<div class="row d-flex justify-content-center">
				<div class="col-auto">
					<button type="submit" class="btn btn-primary button-valid">
						{t}Sortir du stock{/t}
					</button>
				</div>
			</div>
			{$csrf}
		</form>
	</div>
	<!-- Lecture par douchette -->
	<div class="row">
		<fieldset>
			<legend>{t}Lecture optique par douchette{/t}</legend>
			<div class="form-horizontal ">
				<div class="row">
					<label for="valeur-scan" class="form-label col-4">{t}Valeur lue :{/t}</label>
					<div class="col-8">
						<input id="valeur-scan" type="text" class="form-control" placeholder="{t}Placez le curseur dans cette zone et scannez l'étiquette{/t}">
					</div>
				</div>
			</div>
		</fieldset>
	</div>
	<!-- Rajout pour la lecture optique -->
	<div class="row" id="optical">
		<fieldset>
			<legend>{t}Lecture par la caméra{/t}</legend>
			<div class="form-horizontal "></div>
			<div class="row d-flex justify-content-center">

				<div class="col-auto">
					<button id="start2" class="btn btn-success">{t}Activer la lecture{/t}</button>
				</div>
				<div class="col-auto">
					<button id="stop" class="btn btn-danger">{t}Arrêter la lecture{/t}</button>
				</div>
			</div>
			{include file="gestion/scanner.tpl"}
		</fieldset>
	</div>
</div>
<script src='display/node_modules/qr-scanner/qr-scanner.umd.min.js'></script>
<!-- from : https://nimiq.github.io/qr-scanner/demo/ -->
<link rel="stylesheet" href="display/CSS/qr-scanner.css">
<script src="display/javascript/qr-scanner.js"></script>