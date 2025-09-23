<script>
	$(document).ready(function () {
		function toHex(txt) {
			const encoder = new TextEncoder();
			return Array
				.from(encoder.encode(txt))
				.map(b => b.toString(16).padStart(2, '0'))
				.join('')
		}
		var form = $("#labelForm");
		function getMetadata() {
			$("#list_metadata").empty();
			var schema;
			var oi = $("#metadata_id").val();
			if (oi.length > 0) {
				$.ajax({
					url: "metadataGetschema",
					data: { "metadata_id": oi }
				})
					.done(function (value) {
						$.each(JSON.parse(value), function (i, obj) {
							var name = obj.name.replace(/ /g, "_");
							$("#list_metadata").append($("<li>").text(name));
						})
					})
					;
			}
		}
		$("#metadata_id").change(function () {
			getMetadata();
		});
		getMetadata();
		$("#stay").click(function () {
			$(this.form).attr("action", "labelWriteStay");
		});

		$("#labelForm").submit(function (event) {
			$("#labelSent").val(toHex($("#label_xsl").val()));
		});
		function setTypeLabel(barcodeId) {

			if (barcodeId > 1) {
				$("#identifier_only1").prop("checked", true);
				$("#identifier_only0").prop("disabled", true);
				$(".multipleFields").hide();
				$(".monoField").show();
			} else {
				$("#identifier_only0").prop("disabled", false);
				$(".multipleFields").show();
				$(".monoField").hide();
			}
		}
		$("#barcode_id").change(function () {
			setTypeLabel($(this).val());
		});
		setTypeLabel($("#barcode_id").val());

	});

</script>

<h2>{t}Création - Modification d'une étiquette{/t}</h2>
<div class="row">
	<div class="col-md-12">
		<a href="labelList">{t}Retour à la liste{/t}</a>

		<form class="form-horizontal" id="labelForm" method="post" action="labelWrite">
			<input type="hidden" name="moduleBase" value="label">
			<input type="hidden" name="label_id" value="{$data.label_id}">
			<input type="hidden" name="metadata_id" value="{$metadata_id}">
			<input type="hidden" id="labelSent" name="label_xsl">
			<div class="form-group">
				<label for="labelName" class="control-label col-md-4"><span class="red">*</span>
					{t}Nom de l'étiquette :{/t}</label>
				<div class="col-md-8">
					<input id="labelName" type="text" class="form-control" name="label_name" value="{$data.label_name}"
						autofocus required>
				</div>
			</div>
			<div class="form-group">
				<label for="xsl" class="control-label col-md-4"><span class="red">*</span>
					{t}Transformation XSL :{/t}</label>
				<div class="col-md-8">
					<textarea id="label_xsl" class="form-control textarea-edit" rows="20"
						required>{$data.label_xsl}</textarea>
				</div>
			</div>
			<div class="form-group multipleFields" id="metadataDisplay">
				<label for="metadata_id" class="control-label col-md-4">
					{t}Modèle de métadonnées rattaché à l'étiquette :{/t}</label>
				<div class="col-md-8">
					<select id="metadata_id" name="metadata_id" class="form-control">
						<option value="" {if $data.metadata_id=="" }selected{/if}>{t}Choisissez...{/t}</option>
						{foreach $metadata as $value}
						<option value="{$value.metadata_id}" {if $value.metadata_id==$data.metadata_id}selected{/if}>
							{$value.metadata_name}
						</option>
						{/foreach}
					</select>
				</div>
			</div>
			<fieldset>
				<legend>{t}Premier code optique{/t}</legend>
				<div class="form-group">
					<label for="barcode_id" class="control-label col-md-4">{t}Type de code-barre :{/t}</label>
					<div class="col-md-8">
						<select id="barcode_id" name="barcode_id" class="form-control">
							{foreach $barcodes as $barcode}
							<option value="{$barcode.barcode_id}" {if
								$barcode.barcode_id==$optical[0].barcode_id}selected{/if}>
								{$barcode.barcode_name}
							</option>
							{/foreach}
						</select>
					</div>
				</div>
				<div class="form-group">
					<label for="content_type" class="control-label col-md-4">{t}Type de contenu :{/t}</label>
					<div class="col-md-8">
						<select id="content_type" class="form-control" name="content_type">
							<option value="1" {if $opticals[0].content_type==1}selected{/if}>
								{t}plusieurs valeurs différentes au format JSON (historique){/t}
							</option>
							<option value="2" {if $opticals[0].content_type==2}selected{/if}>
								{t}Un seul identifiant, type UUID{/t}
							</option>
							<option value="3" {if $opticals[0].content_type==3}selected{/if}>
								{t}Une URI (radical + identifiant){/t}
							</option>
						</select>
					</div>
				</div>
				<div class="form-group radical">
					<label for="radical" class="control-label col-md-4">
						{t}Texte inséré dans le code optique, avant l'attribut (pour les URI, notamment) :{/t}
					</label>
					<div class="col-md-8">
						<input id="radical" type="text" class="form-control" name="radical"
							value="{$optical[0].radical}">
					</div>
				</div>
				<div class="form-group">
					<label for="optical_content" class="control-label col-md-4"><span class="red">*</span>
						{t}Contenu du code optique (si plusieurs attributs, séparés par une virgule, sans espace) :{/t}
					</label>
					<div class="col-md-8">
						<input id="optical_content" type="text" class="form-control" name="optical_content"
							value="{$optical[0].optical_content}" required>
					</div>
				</div>
			</fieldset>
			<fieldset>
				<legend>{t}Second code optique{/t}</legend>
				<div class="form-group">
					<label for="barcode_id_2" class="control-label col-md-4">{t}Type de code-barre :{/t}</label>
					<div class="col-md-8">
						<select id="barcode_id_2" name="barcode_id_2" class="form-control">
							{foreach $barcodes as $barcode}
							<option value="{$barcode.barcode_id}" {if
								$barcode.barcode_id==$optical[1].barcode_id}selected{/if}>
								{$barcode.barcode_name}
							</option>
							{/foreach}
						</select>
					</div>
				</div>
				<div class="form-group">
					<label for="content_type" class="control-label col-md-4">{t}Type de contenu :{/t}</label>
					<div class="col-md-8">
						<select id="content_type" class="form-control" name="content_type">
							<option value="1" {if $opticals[1].content_type==1}selected{/if}>
								{t}plusieurs valeurs différentes au format JSON (historique){/t}
							</option>
							<option value="2" {if $opticals[1].content_type==2}selected{/if}>
								{t}Un seul identifiant, type UUID{/t}
							</option>
							<option value="3" {if $opticals[1].content_type==3}selected{/if}>
								{t}Une URI (radical + identifiant){/t}
							</option>
						</select>
					</div>
				</div>
				<div class="form-group radical">
					<label for="radical" class="control-label col-md-4">
						{t}Texte inséré dans le code optique, avant l'attribut (pour les URI, notamment) :{/t}
					</label>
					<div class="col-md-8">
						<input id="radical" type="text" class="form-control" name="radical"
							value="{$optical[1].radical}">
					</div>
				</div>
				<div class="form-group">
					<label for="optical_content" class="control-label col-md-4"><span class="red">*</span>
						{t}Contenu du code optique (si plusieurs attributs, séparés par une virgule, sans espace) :{/t}
					</label>
					<div class="col-md-8">
						<input id="optical_content" type="text" class="form-control" name="optical_content"
							value="{$optical[1].optical_content}" required>
					</div>
				</div>
			</fieldset>

			<div class="form-group center">
				<button type="submit" id="stay" class="btn btn-primary">{t}Valider{/t}</button>
				<button type="submit" id="write" class="btn btn-primary button-valid">{t}Valider et retour{/t}</button>
				{if $data.label_id > 0 }
				<button id="delete" class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
				{/if}
			</div>
			{$csrf}
		</form>
	</div>
</div>
<div class="bg-info">
	{t}Champs utilisables dans le QR Code et dans le texte de l'étiquette :{/t}
	<ul>
		<li>{t}Cas général : QR Code au format JSON, avec plusieurs informations stockées{/t}
			<ul>
				<li>{t 1='uid'}%1 (obligatoire) : identifiant unique{/t}</li>
				<li>{t 1='db'}%1 (obligatoire) : code de la base de données (utilisé pour éviter de mélanger les
					échantillons entre plusieurs bases){/t}</li>
				<li>{t 1='id'}%1 : identifiant général{/t}</li>
				<li>{t 1='col'}%1 : code de la collection{/t}</li>
				<li>{t 1='pid'}%1 : identifiant de l'échantillon parent{/t}</li>
				<li>{t 1='clp'}%1 : code de risque{/t}</li>
				<li>{t 1='pn'}%1 : nom du protocole{/t}</li>
				<li>{t 1='x'}%1 : coordonnée wgs84_x de l'objet (lieu de prélèvement ou de stockage suivant le cas){/t}
				</li>
				<li>{t 1='y'}%1 : coordonnée wgs84_y de l'objet{/t}</li>
				<li>{t 1='loc'}%1 : localisation du prélèvement (table des lieux de prélèvement){/t}</li>
				<li>{t 1='ctry'}%1 : code du pays de collecte{/t}</li>
				<li>{t 1='prod'}%1 : produit utilisé pour la conservation{/t}</li>
				<li>{t 1='cd'}%1 : date de création de l'échantillon dans la base de données{/t}</li>
				<li>{t 1='sd'}%1 : date d'échantillonnage{/t}</li>
				<li>{t 1='ed'}%1 : date d'expiration de l'échantillon{/t}</li>
				<li>{t 1='uuid'}%1 : UID Universel (UUID){/t}</li>
				<li>{t 1="ref"}%1 : référent de l'objet{/t}</li>
				<li>{t}et tous les codes d'identifiants secondaires - cf. paramètres > Types d'identifiants{/t}</li>
			</ul>
		</li>
		<li>{t}Si l'objet est toujours stocké au même endroit, pour pouvoir le replacer à son emplacement initial :{/t}
			<ul>
				<li>{t 1='stor'}%1 : nom du contenant{/t}</li>
				<li>{t 1='cnum'}%1 : numéro de la colonne{/t}</li>
				<li>{t 1='lnum'}%1 : numéro de la ligne{/t}</li>
			</ul>
		</li>
		<li>{t}Cas particulier : code-barre avec un seul identifiant, au format texte :{/t}
			<ul>
				<li>id</li>
				<li>uid</li>
				<li>uuid</li>
				<li>{t}tout identifiant secondaire non numérique - cf. paramètres > Types d'identifiants{/t}</li>
				<li>{t 1='dbuid_origin' escape=no}%1 : identifiant de la base de données d'origine. Pour un échantillon
					créé dans la base courante, la valeur sera de type <i>db:uid</i>{/t}</li>
			</ul>
		</li>
	</ul>
</div>

<div class="bg-info">
	{t}Métadonnées utilisables dans le QR Code et dans le texte de l'étiquette :{/t}
	<ul id="list_metadata">
	</ul>
</div>
</fieldset>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>