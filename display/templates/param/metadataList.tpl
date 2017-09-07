<script>
	$(document).ready(function() {
		$("#checkMetadata").change(function() {
			$('.checkMetadata').prop('checked', this.checked);
			var libelle = "Tout cocher";
			if (this.checked) {
				libelle = "Tout décocher";
			}
			$("#lmetadatachek").text(libelle);
		});
	});
</script>

<h2>Modèles de métadonnées</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.projet == 1}
<a href="index.php?module=metadataChange&metadata_id=0">
{$LANG["appli"][0]}
</a>
{/if}

<form method="POST" id="metadataExport" action="index.php">
	<input type="hidden" id="module" name="module" value="metadataExport">
	<div class="row">
		<div class="center">
			Exporter les métadonnées : <label id="lmetadatacheck" for="checkMetadata">Tout décocher</label> <input
				type="checkbox" id="checkMetadata" checked>
				<button type="submit" class="btn btn-primary">Déclencher l'export</button>
		</div>
	</div>

<table id="metadataList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>Nom du modèle</th>
{if $droits.projet == 1}
<th>Dupliquer</th>
{/if}
<th>Exporter</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.projet == 1}
<a href="index.php?module=metadataChange&metadata_id={$data[lst].metadata_id}">
{$data[lst].metadata_name}
</a>
{else}
{$data[lst].metadata_name}
{/if}
</td>
{if $droits.projet == 1}
<td class="center">
<a href="index.php?module=metadataCopy&metadata_id={$data[lst].metadata_id}" title="Dupliquer le modèle de métadonnées">
<img src="display/images/copy.png" height="25">
</a>
</td>
{/if}
<td class="center">
<input type="checkbox" class="checkMetadata"
	name="metadata_id[]" value="{$data[lst].metadata_id}" checked>
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>
</form>

{if $droits["param"] == 1}
<div class="row col-md-6">
<fieldset>
<legend>Importer des métadonnées provenant d'une autre base de données Collec-Science</legend>
<form class="form-horizontal protoform" id="metadataImport" method="post" action="index.php" enctype="multipart/form-data">
<input type="hidden" name="module" value="metadataImport">
<div class="form-group">
<label for="upfile" class="control-label col-md-4">Nom du fichier à importer (CSV)<span class="red">*</span> :</label>
<div class="col-md-8">
<input type="file" name="upfile" required>
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary">Importer les métadonnées</button>
</div>
</form>
</fieldset>
</div>
{/if}
