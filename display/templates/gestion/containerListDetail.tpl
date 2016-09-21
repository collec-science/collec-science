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
	$("#formListPrint").submit( function (event) {
		$("#containerSpinner").show();
	});
});
</script>
{include file="gestion/displayPhotoScript.tpl"}
{if $droits.gestion == 1}
<form method="post" id="formListPrint" action="index.php">
<input type="hidden" id="module" name="module" value="containerPrintLabel">
<div class="row">
<div class="col-sm-6 right">
<label id="lcheck" for="check">Tout décocher</label>
<input type="checkbox" id="check" checked>
<button type="submit" class="btn">Fichier pour étiquettes</button>
<img id="containerSpinner" src="display/images/spinner.gif" height="25" >
</div>
</div>
{/if}
<table id="containerList" class="table table-bordered table-hover datatable-nopaging " >
<thead>
<tr>
<th>UID</th>
<th>Identifiant ou nom</th>
<th>Statut</th>
<th>Type</th>
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
<td >
{$containers[lst].object_status_name}
</td>
<td>
{$containers[lst].container_family_name}/
{$containers[lst].container_type_name}
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