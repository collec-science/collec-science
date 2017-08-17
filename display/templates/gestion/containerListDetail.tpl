<!-- Liste des conteneurs pour affichage -->
<script>
$(document).ready(function () {
	$("#check").change( function() {
		$('.check').prop('checked', this.checked);
		var libelle="Tout cocher";
		if (this.checked) {
			libelle = "Tout décocher";
		} 
		$("#lchek").text(libelle);
	});
	
	$("#containerSpinner").hide();
	$('#containercsvfile').keypress(function() {
		$(this.form).find("input[name='module']").val("containerExportCSV");
		$(this.form).submit();
	});
	$("#containercsvfile").click(function() {
		console.log("Demande de generation du fichier csv");
		$(this.form).find("input[name='module']").val("containerExportCSV");
		$(this.form).submit();
	});
	$("#containerlabels").keypress(function() {
		$(this.form).find("input[name='module']").val("containerPrintLabel");
		$("#containerSpinner").show();
		$(this.form).submit();
	});
	$("#containerlabels").click(function() {
		$(this.form).find("input[name='module']").val("containerPrintLabel");
		$("#containerSpinner").show();
		$(this.form).submit();
	});

});
</script>
{include file="gestion/displayPhotoScript.tpl"}
{if $droits.gestion == 1}
<form method="GET" id="formListPrint" action="index.php">
<input type="hidden" id="module" name="module" value="containerPrintLabel">
<div class="row">
<div class="center">
<label id="lcheck" for="check">Tout décocher</label>
<input type="checkbox" id="check" checked>
			<button id="containerlabels" class="btn btn-primary">Étiquettes</button>
			<select id="labels" name="label_id">
			<option value="" {if $label_id == ""}selected{/if}>Étiquette par défaut</option>
			{section name=lst loop=$labels}
			<option value="{$labels[lst].label_id}" {if $labels[lst].label_id == $label_id}selected{/if}>
			{$labels[lst].label_name}
			</option>
			{/section}
			</select>
			<img id="containerSpinner" src="/display/images/spinner.gif" height="25">
			<button id="containercsvfile" class="btn btn-primary">Fichier CSV</button>
</div>
</div>
{/if}
<table id="containerList" class="table table-bordered table-hover datatable-export " >
<thead>
<tr>
<th>UID</th>
<th>Identifiant ou nom</th>
<th>Autres identifiants</th>
<th>Statut</th>
<th>Type</th>
<th>Dernier mouvement</th>
<th>Condition de stockage</th>
<th>Produit de stockage</th>
<th>Code CLP</th>
<th>Photo</th>
{if $droits.gestion == 1}
<th></th>
{/if}
</tr>
</thead>
<tbody>
{section name=lst loop=$containers}
<tr>
<td class="text-center">
<a href="index.php?module=containerDisplay&uid={$containers[lst].uid}" title="Consultez le détail">
{$containers[lst].uid}
</td>
<td>
<a href="index.php?module=containerDisplay&uid={$containers[lst].uid}" title="Consultez le détail">
{$containers[lst].identifier}
</a>
</td>
<td>
{$containers[lst].identifiers}
</td>
<td >
{$containers[lst].object_status_name}
</td>
<td>
{$containers[lst].container_family_name}/
{$containers[lst].container_type_name}
</td>
<td>
{if strlen($containers[lst].storage_date) > 0 }
{if $containers[lst].movement_type_id == 1}
<span class="green">{else}
<span class="red">{/if}{$containers[lst].storage_date}</span>
{/if}
</td> 
<td>
{$containers[lst].storage_condition_name}
</td>
<td>
{$containers[lst].storage_product}
</td>
<td>
{$containers[lst].clp_classification}
</td>
<td class="center">
{if $containers[lst].document_id > 0}
<a class="image-popup-no-margins" href="index.php?module=documentGet&document_id={$containers[lst].document_id}&attached=0&phototype=1" title="aperçu de la photo">
<img src="index.php?module=documentGet&document_id={$containers[lst].document_id}&attached=0&phototype=2" height="30">
</a>
{/if}
</td>
{if $droits.gestion == 1}
<td class="center">
<input type="checkbox" class="check" name="uid[]" value="{$containers[lst].uid}" checked>
</td>
{/if}
</tr>
{/section}
</tbody>
</table>
{if $droits.gestion == 1}
</form>
{/if}