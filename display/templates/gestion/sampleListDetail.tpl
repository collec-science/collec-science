<!--  Liste des échantillons pour affichage-->
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
});
</script>
{if $droits.gestion == 1}
<form method="post" id="formListPrint" action="index.php">
<input type="hidden" id="module" name="module" value="samplePrintLabel">
<div class="row">
<div class="col-sm-6 right">
<label id="lcheck" for="check">Tout décocher</label>
<input type="checkbox" id="check" checked>
<button type="submit" class="btn">Fichier pour étiquettes</button>
</div>
</div>
{/if}
<table id="containerList" class="table table-bordered table-hover datatable-nopaging " >
<thead>
<tr>
<th>UID</th>
<th>Identifiant ou nom</th>
<th>Projet</th>
<th>Type</th>
<th>Statut</th>
<th>Date</th>
<th>Date de création dans la base</th>
{if $droits.gestion == 1}
<th></th>
{/if}
</tr>
</thead>
<tbody>
{section name=lst loop=$samples}
<tr>
<td class="text-center">
<a href="index.php?module=sampleDisplay&uid={$samples[lst].uid}" title="Consultez le détail">
{$samples[lst].uid}
</a>
</td>
<td>
<a href="index.php?module=sampleDisplay&uid={$samples[lst].uid}" title="Consultez le détail">
{$samples[lst].identifier}
</a>
</td>
<td>{$samples[lst].project_name}</td>
<td>{$samples[lst].sample_type_name}</td>
<td>{$samples[lst].object_status_name}</td>
<td>{$samples[lst].sample_date}</td>
<td>{$samples[lst].sample_creation_date}</td>
{if $droits.gestion == 1}
<td class="center">
<input type="checkbox" class="check" name="uid[]" value="{$samples[lst].uid}" checked>
</td>
{/if}
</tr>
{/section}
</tbody>
</table>
{if $droits.gestion == 1}
</form>
{/if}