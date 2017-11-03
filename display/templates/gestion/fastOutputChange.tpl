<!-- Sortie rapide d'un échantillon du stock -->
{include file="gestion/qrcode_read.tpl"}
<h2>{$LANG["menu"].75}</h2>

<div class="row">
	<div class="col-md-6">
		<form class="form-horizontal protoform fastform" id="fastOutputForm"
			method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="fastOutput"> <input
				type="hidden" name="action" value="Write"> <input
				type="hidden" name="storage_id" value="0"> <input
				type="hidden" id="read_optical" name="read_optical"
				value="{$read_optical}">

			<div class="form-group">
				<label for="object_uid" class="control-label col-sm-4">UID
					de l'objet<span class="red">*</span> :
				</label>
				<div class="col-sm-8" id="object_groupe">
					<div class="col-sm-3">
						<input id="object_uid" type="text" name="object_uid" value=""
							class="form-control" required autofocus autocomplete="off">
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
				<label for="storage_date" class="control-label col-sm-4">Date/heure<span
					class="red">*</span> :
				</label>
				<div class="col-sm-8">
					<input id="storage_date" name="storage_date" required
						value="{$data.storage_date}" class="form-control datetimepicker">
				</div>
			</div>
			<div class="form-group">
				<label for="storage_reason_id" class="control-label col-sm-4">Motif du déstockage :</label>
				<div class="col-sm-8">
					<select id="storage_reason_id" name="storage_reason_id">
					<option value="" {if $data.storage_reason_id == ""}selected{/if}>Sélectionnez...</option>
					{section name=lst loop=$storageReason}
					<option value="{$storageReason[lst].storage_reason_id}" {if $data.storage_reason_id == $storageReason[lst].storage_reason_id}selected{/if}>
					{$storageReason[lst].storage_reason_name}
					</option>	
					{/section}		
					</select>
				</div>
			</div>
					
			<div class="form-group">
				<label for="storage_comment" class="control-label col-sm-4">Commentaire
					:</label>
				<div class="col-sm-8">
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
<!-- Lecture par douchette -->
<div class="row">
	<fieldset>
		<legend>Lecture optique par douchette</legend>

		<div class="col-md-6">
			<div class="form-horizontal protoform">
				<div class="form-group">
					<label for="valeur-scan" class="control-label col-sm-4">Valeur
						lue :</label>
					<div class="col-sm-8">
						<input id="valeur-scan" type="text" class="form-control"
							placeholder="Positionnez le curseur dans cette zone avant de lire l'étiquette">
					</div>
				</div>
			</div>
		</div>
	</fieldset>
</div>
<!-- Rajout pour la lecture optique -->
<div class="row" id="optical">
	<fieldset>
		<legend>Lecture par la caméra de l'ordinateur ou du smartphone (utiliser Firefox)</legend>

		<div class="col-md-6">
			<div class="form-horizontal protoform">
				<div class="form-group center">
					<button id="start2" class="btn btn-success">Activer la
						lecture</button>
					<button id="stop" class="btn btn-danger">Arrêter la
						lecture</button>
				</div>
			</div>
		</div>
		<div class="col-md-6 center">
			<video id="reader" autoplay width="320" height="240" poster="{$display}/images/webcam.png"></video>
		</div>
		
	</fieldset>
</div>


