{* Paramètres > Métadonnées > Nouveau > *}
<script>
	$(document).ready(function() {
		$("#checkMetadata").change(function() {
			$('.checkMetadata').prop('checked', this.checked);
			var libelle = "{t}Tout cocher{/t}";
			if (this.checked) {
				libelle = "{t}Tout décocher{/t}";
			}
			$("#lmetadatachek").text(libelle);
		});
	});
</script>

<h2>{t}Modèles de métadonnées{/t}</h2>
<div class="row">
	<div class="col-md-6">
		{if $droits.collection == 1}
			<a href="index.php?module=metadataChange&metadata_id=0">
				{t}Nouveau...{/t}
			</a>
		{/if}

		<form method="POST" id="metadataExport" action="index.php">
			<input type="hidden" id="module" name="module" value="metadataExport">
			<div class="row">
				<div class="center">
					{t}Exporter les métadonnées :{/t} <label id="lmetadatacheck" for="checkMetadata">{t}Tout décocher{/t}</label> <input
						type="checkbox" id="checkMetadata" checked>
						<button type="submit" class="btn btn-primary">{t}Déclencher l'export{/t}</button>
				</div>
			</div>

			<table id="metadataList" class="table table-bordered table-hover datatable " >
				<thead>
					<tr>
						<th>{t}Nom du modèle{/t}</th>
						<th>{t}Détail des champs{/t}</th>
						{if $droits.collection == 1}
							<th>{t}Modifier{/t}</th>
							<th>{t}Dupliquer{/t}</th>
						{/if}
						<th>{t}Exporter{/t}</th>
					</tr>
				</thead>
				<tbody>
					{section name=lst loop=$data}
						<tr>
							<td>{$data[lst].metadata_name}</td>
							<td class="center">
								<a href="index.php?module=metadataDisplay&metadata_id={$data[lst].metadata_id}">
									<img src="display/images/zoom.png" height="25">
								</a>
							</td>
							{if $droits.collection == 1}
								<td class="center">
									<a href="index.php?module=metadataChange&metadata_id={$data[lst].metadata_id}" title="{t}Modifier le modèle de métadonnées{/t}">
										<img src="display/images/edit.gif" height="25">
									</a>
								<td class="center">
									<a href="index.php?module=metadataCopy&metadata_id={$data[lst].metadata_id}" title="{t}Dupliquer le modèle de métadonnées{/t}">
										<img src="display/images/copy.png" height="25">
									</a>
								</td>
							{/if}
							<td class="center">
								<input type="checkbox" class="checkMetadata" name="metadata_id[]" value="{$data[lst].metadata_id}" checked>
							</td>
						</tr>
					{/section}
				</tbody>
			</table>
		</form>
	</div>
</div>


{if $droits["param"] == 1}
	<div class="row col-md-6">
		<fieldset>
			<legend>{t}Importer des métadonnées provenant d'une autre base de données Collec-Science{/t}</legend>
			<form class="form-horizontal protoform" id="metadataImport" method="post" action="index.php" enctype="multipart/form-data">
				<input type="hidden" name="module" value="metadataImport">
				<div class="form-group">
					<label for="upfile" class="control-label col-md-4"><span class="red">*</span> {t}Nom du fichier à importer (CSV) :{/t}</label>
					<div class="col-md-8">
						<input type="file" name="upfile" required>
					</div>
				</div>
				<div class="form-group center">
					<button type="submit" class="btn btn-primary">{t}Importer les métadonnées{/t}</button>
				</div>
				<div class="bg-info">
					{t}L'importation est basée sur un fichier exporté depuis une autre instance de Collec-Science.{/t}
					<br>
					{t}Description du fichier :{/t}
					<ul>
						<li>{t}metadata_name : nom de la métadonnée{/t}</li>
						<li>{t}metadata_schema : Description, au format JSON, de la métadonnée{/t}</li>
					</ul>
				</div>
			</form>
		</fieldset>
	</div>
{/if}
