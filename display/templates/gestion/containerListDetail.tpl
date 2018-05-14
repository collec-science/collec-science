<!-- Liste des containers pour affichage -->
<script>
$(document).ready(function () {
	$("#checkContainer").change( function() {
		$('.checkContainer').prop('checked', this.checked);
		var libelle="{t}Tout cocher{/t}";
		if (this.checked) {
			libelle = "{t}Tout décocher{/t}";
		} 
		$("#lcheckContainer").text(libelle);
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
	$("#containerdirect").keypress(function() {
		$(this.form).find("input[name='module']").val("containerPrintDirect");
		$("#containerSpinner").show();
		$(this.form).submit();
	});
	$("#containerdirect").click(function() {
		$(this.form).find("input[name='module']").val("containerPrintDirect");
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
<label id="lcheckContainer" for="check">{t}Tout décocher{/t}</label>
<input type="checkbox" id="checkContainer" checked>
						<select id="labels" name="label_id">
			<option value="" {if $label_id == ""}selected{/if}>{t}Étiquette par défaut{/t}</option>
			{section name=lst loop=$labels}
			<option value="{$labels[lst].label_id}" {if $labels[lst].label_id == $label_id}selected{/if}>
			{$labels[lst].label_name}
			</option>
			{/section}
			</select>
			<button id="containerlabels" class="btn btn-primary">{t}Étiquettes{/t}</button>
			<img id="containerSpinner" src="{$display}/images/spinner.gif" height="25">
			<button id="containercsvfile" class="btn btn-primary">{t}Fichier CSV{/t}</button>
			{if count($printers) > 0}
			<select id="printers" name="printer_id">
			{section name=lst loop=$printers}
			<option value="{$printers[lst].printer_id}">
			{$printers[lst].printer_name}
			</option>
			{/section}
			</select>
			<button id="containerdirect" class="btn btn-primary">{t}Impression directe{/t}</button>
			{/if}
</div>
</div>
{/if}
<table id="containerList" class="table table-bordered table-hover datatable-export " >
<thead>
<tr>
<th>{t}UID{/t}</th>
<th>{t}Identifiant ou nom{/t}</th>
<th>{t}Autres identifiants{/t}</th>
<th>{t}Statut{/t}</th>
<th>{t}Type{/t}</th>
<th>{t}Dernier mouvement{/t}</th>
<th>{t}Emplacement{/t}</th>
<th>{t}Condition de stockage{/t}</th>
<th>{t}Produit de stockage{/t}</th>
<th>{t}Code CLP{/t}</th>
<th>{t}Photo{/t}</th>
{if $droits.gestion == 1}
<th></th>
{/if}
</tr>
</thead>
<tbody>
{section name=lst loop=$containers}
<tr>
<td class="text-center">
<a href="index.php?module=containerDisplay&uid={$containers[lst].uid}" title="{t}Consultez le détail{/t}">
{$containers[lst].uid}
</td>
<td>
<a href="index.php?module=containerDisplay&uid={$containers[lst].uid}" title="{t}Consultez le détail{/t}">
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
{if strlen($containers[lst].movement_date) > 0 }
{if $containers[lst].movement_type_id == 1}
<span class="green">{else}
<span class="red">{/if}{$containers[lst].movement_date}
</span>
{/if}
</td> 
<td>
{if $containers[lst].container_uid > 0}
<a href="index.php?module=containerDisplay&uid={$containers[lst].container_uid}">
{$containers[lst].container_identifier}
</a>
<br>{t}col:{/t}{$containers[lst].column_number} {t}ligne:{/t}{$containers[lst].line_number}
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
<a class="image-popup-no-margins" href="index.php?module=documentGet&document_id={$containers[lst].document_id}&attached=0&phototype=1" title="{t}aperçu de la photo{/t}">
<img src="index.php?module=documentGet&document_id={$containers[lst].document_id}&attached=0&phototype=2" height="30">
</a>
{/if}
</td>
{if $droits.gestion == 1}
<td class="center">
<input type="checkbox" class="checkContainer" name="uid[]" value="{$containers[lst].uid}" checked>
</td>
{/if}
</tr>
{/section}
</tbody>
</table>
{if $droits.gestion == 1}
</form>
{/if}