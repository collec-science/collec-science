<script>
	$(document).ready(function () {
		$("#checkMetadata").change(function () {
			$('.checkMetadata').prop('checked', this.checked);
			var libelle = "{t}Tout cocher{/t}";
			if (this.checked) {
				libelle = "{t}Tout décocher{/t}";
			}
			$("#lmetadatachek").text(libelle);
		});
		$("#metadataRegenerate").submit(function (event) {
			if ($("#regenerateType").val() == 0 ) {
				event.preventDefault();
			}
		})
	});
</script>

<h2>{t}Modèles de métadonnées{/t}</h2>
<div class="row">
	<div class="col-md-6">
		{if $rights.collection == 1}
		<a href="metadataChange?metadata_id=0">
			<img src="display/images/new.png" height="25">
			{t}Nouveau...{/t}
		</a>
		{/if}

		<form method="POST" id="metadataExport" action="metadataExport">
			<div class="row">
				<div class="center">
					{t}Exporter les métadonnées :{/t} 
					<label id="lmetadatacheck" for="checkMetadata">
						{t}Tout décocher{/t}
					</label> 
					<input type="checkbox" id="checkMetadata" checked>
					<button type="submit" class="btn btn-primary">{t}Déclencher l'export{/t}</button>
				</div>
			</div>

			<table id="metadataList" class="table table-bordered table-hover datatable display">
				<thead>
					<tr>
						<th>{t}Nom du modèle{/t}</th>
						<th>{t}Id{/t}</th>
						<th>{t}Détail{/t}</th>
						{if $rights.collection == 1}
						<th>{t}Dupliquer{/t}</th>
						{/if}
						<th>{t}Exporter{/t}</th>
					</tr>
				</thead>
				<tbody>
					{section name=lst loop=$data}
					<tr>
						<td>{$data[lst].metadata_name}</td>
						<td class="center">{$data[lst].metadata_id}</td>
						<td class="center">
							<a href="metadataDisplay?metadata_id={$data[lst].metadata_id}">
								<img src="display/images/zoom.png" height="25">
							</a>
						</td>
						{if $rights.collection == 1}
						<td class="center">
							<a href="metadataCopy?metadata_id={$data[lst].metadata_id}"
								title="{t}Dupliquer le modèle de métadonnées{/t}">
								<img src="display/images/copy.png" height="25">
							</a>
						</td>
						{/if}
						<td class="center">
							<input type="checkbox" class="checkMetadata" name="metadata_id[]"
								value="{$data[lst].metadata_id}" checked>
						</td>
					</tr>
					{/section}
				</tbody>
			</table>
			{$csrf}
		</form>
	</div>
</div>


{if $rights["param"] == 1}
<div class="row">
	<div class="col-md-6">
		<fieldset>
			<legend>{t}Importer des métadonnées provenant d'une autre base de données Collec-Science{/t}</legend>
			<form class="form-horizontal" id="metadataImport" method="post" action="metadataImport"
				enctype="multipart/form-data">
				<div class="form-group">
					<label for="upfile" class="control-label col-md-4"><span class="red">*</span> 
						{t}Nom du fichier à importer (CSV) :{/t}
					</label>
					<div class="col-md-8">
						<input class="form-control" type="file" name="upfile" required>
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
				{$csrf}
			</form>
		</fieldset>
	</div>
</div>
<div class="row">
	<div class="col-md-6">
		<fieldset>
			<legend>{t}Régénérer les modèles{/t}</legend>
			<form class="form-horizontal" id="metadataRegenerate" method="post" action="metadataRegenerate">
				<div class="bg-info">
					{t}La régénération consiste à reformater les modèles de métadonnées, pour les rendre compatibles avec la version v25.0.0 ou ultérieure de l'application{/t}
					<br>
					{t}La première option permet de reformater les modèles, la seconde recrée les index sur la table des échantillons{/t}
					<div class="form-group">
						<label for="regenerateType" class="control-label col-md-4">
							{t}Type d'opération à exécuter :{/t}
						</label>
						<div class="col-md-8">
							<select id="regenerateType" name="regenerateType" class="form-control">
								<option value="0" selected>
									{t}Choisissez{/t}
								</option>
								<option value="1">
									{t}Régénérer les modèles{/t}
								</option>
								<option value="2">
									{t}Régénérer les index de la table des échantillons{/t}
								</option>
							</select>
						</div>
					</div>
					<div class="form-group center">
						<button type="submit" class="btn btn-danger">{t}Lancer l'opération{/t}</button>
					</div>
				</div>
				{$csrf}
			</form>
		</fieldset>
	</div>
</div>
<div class="row">
	<div class="col-md-6">
		<fieldset>
			<legend>{t}Renommer un champ de métadonnées globalement{/t}</legend>
			<form class="form-horizontal" id="metadataRename" method="post" action="metadataRename">
				<div class="bg-info">
					{t}Le renommage d'un champ de métadonnées est une opération qui se déroule en deux temps. Le programme va :{/t}
					<ul>
						<li>{t}renommer le nom de la métadonnée concerné dans tous les échantillons{/t}</li>
						<li>{t}Modifier tous les modèles qui contiennent l'ancien nom{/t}</li>
					</ul>
				</div>
				<div class="form-group">
					<label for="oldName" class="control-label col-md-4">
						{t}Ancien nom de la métadonnée :{/t}
					</label>
					<div class="col-md-8">
						<input class="form-control" id="oldName" name="oldName" required>
					</div>
				</div>
				<div class="form-group">
					<label for="newName" class="control-label col-md-4">
						{t}Nouveau nom de la métadonnée :{/t}
					</label>
					<div class="col-md-8">
						<input class="form-control" id="newName" name="newName" pattern="[a-z0-9_]*" required
						title="{t}Uniquement des minuscules (sans accents), des chiffres, ou le caractère _{/t}">
					</div>
				</div>
				<div class="form-group center">
					<button type="submit" class="btn btn-danger">{t}Lancer l'opération{/t}</button>
				</div>
				{$csrf}
			</form>
		</fieldset>
	</div>
</div>

{/if}