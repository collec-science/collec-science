<script>
	$(document).ready(function() {
		var maxUploadSize = "{$maxUploadSize}" * 1024 *1024;
		$("#documentName").on ("change", function() {
			var totalSize = 0;
			var docs = document.getElementById("documentName");
			for (file of docs.files) {
				totalSize += file.size;
			}
			if (totalSize > maxUploadSize) {
				alert ("{t}La taille du ou des fichiers dépasse celle autorisée{/t}");
				docs.value = "";
			}
		});
		$("#documentForm").on("submit", function (e) {
			if (!$("#documentName").val()) {
				e.preventDefault();
			} else {
				$("#documentSpinner").show();
			}
		});
	});
</script>

<div class="row">
	<form id="documentForm" class="form-horizontal" method="post" action="{$moduleParent}documentWrite" enctype="multipart/form-data">
		<input type="hidden" name="document_id" value="0">
		<input type="hidden" name="uid" value="{$data.uid}">
		<input type="hidden" name="campaign_id" value="{$data.campaign_id}">
		<input type="hidden" name="event_id" value="{$data.event_id}">
		<input type="hidden" name="parentKeyName" value="{$parentKeyName}">
		<input type="hidden" name="activeTab" value="tab-document">
		<div class="form-group">
			<label for="documentName" class="control-label col-md-4">
				{t 1=$maxUploadSize}Fichier(s) à importer (taille maxi : %1 Mb):{/t} <br>({$extensions})
			</label>
			<div class="col-md-8">
				<input id="documentName" type="file" class="form-control"
					name="documentName[]" multiple>
			</div>
		</div>
		<div class="form-group">
			<label for="document_description" class="control-label col-md-4">
				{t}Description :{/t} </label>
			<div class="col-md-8">
				<input id="document_description" name="document_description" class="form-control">
			</div>
		</div>
		<div class="form-group">
			<label for="document_creation_date" class="control-label col-md-4">
				{t}Date de création du document :{/t} </label>
			<div class="col-md-8">
				<input id="document_creation_date" name="document_creation_date"
					class="form-control datepicker">
			</div>
		</div>
		<div class="form-group center">
			<button type="submit" class="btn btn-primary">{t}Envoyer le fichier{/t}</button>
			<img id="documentSpinner" src="display/images/spinner.gif" height="25" hidden>
		</div>
	{$csrf}</form>
</div>
