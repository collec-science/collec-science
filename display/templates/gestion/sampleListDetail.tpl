<!--  Liste des échantillons pour affichage-->
<script>
	$(document).ready(function() {
		$("#check").change(function() {
			$('.check').prop('checked', this.checked);
			var libelle = "Tout cocher";
			if (this.checked) {
				libelle = "Tout décocher";
			}
			$("#lchek").text(libelle);
		});
		$("#sampleSpinner").hide();

		$('#samplecsvfile').keypress(function() {
			$(this.form).find("input[name='module']").val("sampleExportCSV");
			$(this.form).submit();
		});
		$("#samplecsvfile").click(function() {
			console.log("Demande de generation du fichier csv");
			$(this.form).find("input[name='module']").val("sampleExportCSV");
			$(this.form).submit();
		});
		$("#samplelabels").keypress(function() {
			$(this.form).find("input[name='module']").val("samplePrintLabel");
			$("#sampleSpinner").show();
			$(this.form).submit();
		});
		$("#samplelabels").click(function() {
			$(this.form).find("input[name='module']").val("samplePrintLabel");
			$("#sampleSpinner").show();
			$(this.form).submit();
		});
	});
</script>
{include file="gestion/displayPhotoScript.tpl"} {if $droits.gestion ==
1}
<form method="GET" id="formListPrint" action="index.php">
	<input type="hidden" id="module" name="module" value="samplePrintLabel">
	<div class="row">
		<div class="center">
			<label id="lcheck" for="check">Tout décocher</label> <input
				type="checkbox" id="check" checked>
			<button id="samplelabels" class="btn btn-primary">Étiquettes</button>
			<select id="labels" name="label_id">
			<option value="" {if $label_id == ""}selected{/if}>Étiquette par défaut</option>
			{section name=lst loop=$labels}
			<option value="{$labels[lst].label_id}" {if $labels[lst].label_id == $label_id}selected{/if}>
			{$labels[lst].label_name}
			</option>
			{/section}
			</select>
			<img id="sampleSpinner" src="display/images/spinner.gif" height="25">
			<button id="samplecsvfile" class="btn btn-primary">Fichier
				CSV</button>
		</div>
	</div>
	{/if}
	<table id="containerList"
		class="table table-bordered table-hover datatable-export ">
		<thead>
			<tr>
				<th>UID</th>
				<th>Identifiant ou nom</th>
				<th>Autres identifiants</th>
				<th>Projet</th>
				<th>Type</th>
				<th>Statut</th>
				<th>Parent</th>
				<th>Photo</th>
				<th>Dernier mouvement</th>
				<th>Lieu de prélèvement</th>
				<th>Date</th>
				<th>Date de création dans la base</th> {if $droits.gestion == 1}
				<th></th> {/if}
			</tr>
		</thead>
		<tbody>
			{section name=lst loop=$samples}
			<tr>
				<td class="text-center"><a
					href="index.php?module=sampleDisplay&uid={$samples[lst].uid}"
					title="Consultez le détail"> {$samples[lst].uid} </a>
					{if strlen($samples[lst].dbuid_origin) > 0}
					<br>{$samples[lst].dbuid_origin}
					{/if}
					</td>
				<td><a
					href="index.php?module=sampleDisplay&uid={$samples[lst].uid}"
					title="Consultez le détail"> {$samples[lst].identifier} </a></td>
				<td>{$samples[lst].identifiers}</td>
				<td>{$samples[lst].project_name}</td>
				<td>{$samples[lst].sample_type_name}</td>
				<td>{$samples[lst].object_status_name}</td>
				<td>{if strlen($samples[lst].parent_uid) > 0}
				<a href="index.php?module=sampleDisplay&uid={$samples[lst].parent_uid}">
				{$samples[lst].parent_uid}&nbsp;{$samples[lst].parent_identifier}
				</a>
				{/if}
				</td>
				<td class="center">{if $samples[lst].document_id > 0} <a
					class="image-popup-no-margins"
					href="index.php?module=documentGet&document_id={$samples[lst].document_id}&attached=0&phototype=1"
					title="aperçu de la photo"> <img
						src="index.php?module=documentGet&document_id={$samples[lst].document_id}&attached=0&phototype=2"
						height="30">
				</a> {/if}
				</td>
				<td>
				{if strlen($samples[lst].storage_date) > 0 }
					{if $samples[lst].movement_type_id == 1}
						<span class="green">{else}
						<span class="red">
					{/if}
					{$samples[lst].storage_date}
					</span>
				{/if}
				</td> 
				<td>{$samples[lst].sampling_place_name}</td>
				<td>{$samples[lst].sample_date}</td>
				<td>{$samples[lst].sample_creation_date}</td> {if $droits.gestion ==
				1}
				<td class="center"><input type="checkbox" class="check"
					name="uid[]" value="{$samples[lst].uid}" checked></td> {/if}
			</tr>
			{/section}
		</tbody>
	</table>
	{if $droits.gestion == 1}
</form>
{/if}
