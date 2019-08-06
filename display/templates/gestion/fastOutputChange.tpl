{* Mouvements > Sortir un échantillon > *}
<!-- Sortie rapide d'un échantillon du stock -->
{include file="gestion/qrcode_read.tpl"}
<h2>{t}Sortir du stock{/t}</h2>

<div class="row">
	<div class="col-md-6">
		<form class="form-horizontal protoform fastform" id="fastOutputForm"
			method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="fastOutput"> <input
				type="hidden" name="action" value="Write"> <input
				type="hidden" name="movement_id" value="0"> <input
				type="hidden" id="read_optical" name="read_optical"
				value="{$read_optical}">

			<div class="form-group">
				<label for="object_uid" class="control-label col-sm-4"><span class="red">*</span> {t}UID de l'objet :{/t}</label>
				<div class="col-sm-8" id="object_groupe">
					<div class="col-sm-3">
						<input id="object_uid" type="text" name="object_uid" value=""
							class="form-control" required autofocus autocomplete="off">
					</div>
					<div class="col-sm-3 col-sm-offset-1">
						<button type="button" id="object_search" class="btn btn-default">{t}Chercher...{/t}</button>
					</div>
				</div>
				<div class="col-sm-8 col-sm-offset-4 ">
					<input id="object_detail" type="text" class="form-control" disabled>
				</div>
			</div>

			<div class="form-group">
				<label for="movement_date" class="control-label col-sm-4"><span class="red">*</span> {t}Date/heure :{/t}</label>
				<div class="col-sm-8">
					<input id="movement_date" name="movement_date" required
						value="{$data.movement_date}" class="form-control datetimepicker">
				</div>
			</div>
			<div class="form-group">
				<label for="movement_reason_id" class="control-label col-sm-4">{t}Motif du déstockage :{/t}</label>
				<div class="col-sm-8">
					<select id="movement_reason_id" name="movement_reason_id">
					<option value="" {if $data.movement_reason_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
					{section name=lst loop=$movementReason}
					<option value="{$movementReason[lst].movement_reason_id}" {if $data.movement_reason_id == $movementReason[lst].movement_reason_id}selected{/if}>
					{$movementReason[lst].movement_reason_name}
					</option>	
					{/section}		
					</select>
				</div>
			</div>
					
			<div class="form-group">
				<label for="movement_comment" class="control-label col-sm-4">{t}Commentaire :{/t}</label>
				<div class="col-sm-8">
					<textarea class="form-control" id="movement_comment"
						name="movement_comment" rows="3"></textarea>
				</div>
			</div>

			<div class="form-group center">
				<button type="submit" class="btn btn-primary button-valid">{t}Sortir du stock{/t}</button>
			</div>

		</form>
		<span class="red">*</span><span class="messagebas">Donnée obligatoire</span>
	</div>
</div>
<!-- Lecture par douchette -->
<div class="row">
	<fieldset>
		<legend>{t}Lecture optique par douchette{/t}</legend>

		<div class="col-md-6">
			<div class="form-horizontal protoform">
				<div class="form-group">
					<label for="valeur-scan" class="control-label col-sm-4">{t}Valeur lue :{/t}</label>
					<div class="col-sm-8">
						<input id="valeur-scan" type="text" class="form-control"
							placeholder="{t}Placez le curseur dans cette zone et scannez l'étiquette{/t}">
					</div>
				</div>
			</div>
		</div>
	</fieldset>
</div>
<!-- Rajout pour la lecture optique -->
<div class="row" id="optical">
	<fieldset>
		<legend>{t}Lecture par la caméra de l'ordinateur ou du smartphone (utiliser Firefox){/t}</legend>

		<div class="col-md-6">
			<div class="form-horizontal protoform">
				<div class="form-group center">
					<button id="start2" class="btn btn-success">{t}Activer la lecture{/t}</button>
					<button id="stop" class="btn btn-danger">{t}Arrêter la lecture{/t}</button>
				</div>
			</div>
		</div>
		<div class="col-md-6 center">
			<video id="reader" autoplay width="320" height="240" poster="display/images/webcam.png"></video>
		</div>
		
	</fieldset>
</div>


