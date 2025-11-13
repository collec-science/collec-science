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

		var optical2id = "{$opticals[1].label_optical_id}";
		if (optical2id > 0) {
			$("#optical2Enabled").attr("checked",true);
			$("#optical2").show();
			$("#optical2").attr("disabled",false);
			$("#optical_content2").prop("required",true);
		}
		$("#optical2Enabled").change(function () {
			if ($(this).prop("checked") ) {
				$("#optical2").show();
				$("#optical2").prop("disabled",false);
				$("#optical_content2").prop("required",true);
			} else {
				$("#optical2").hide();
				$("#optical2").prop("disabled",true);
				$("#optical_content2").prop("required",false);
			}
		});
		$("#barcode_id").change(function () { 
			var type = $(this).val();
			if (type == 2) {
				$("#radical").prop("disabled",true);
				$("#radical").val("");
				$("content_type").val(2);
			} else {
				$("#radical").prop("disabled",false);
			}
		});
		$("#barcode_id2").change(function () { 
			var type = $(this).val();
			if (type == 2) {
				$("#radical2").prop("disabled",true);
				$("#radical2").val("");
				$("content_type2").val(2);
			} else {
				$("#radical2").prop("disabled",false);
			}
		});
		$("#content_type").change(function() {
			var type = $(this).val();
			if (type == 1) {
				$("#radical").prop("disabled",true);
				$("#radical").val("");
			} else {
				$("#radical").prop("disabled",false);
			}
		});
		$("#content_type2").change(function() {
			var type = $(this).val();
			if (type == 1) {
				$("#radical2").prop("disabled",true);
				$("#radical2").val("");
			} else {
				$("#radical2").prop("disabled",false);
			}
		});
	});

</script>

<h2>{t}Création - Modification d'une étiquette{/t}</h2>
<div class="row">
	<div class="col-md-12">
		<a href="labelList">
			<img src="display/images/list.png" height="25">
			{t}Retour à la liste{/t}</a>
		{$help}

		<form class="form-horizontal" id="labelForm" method="post" action="labelWrite" enctype="multipart/form-data">
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
				<input type="hidden" name="label_optical_id" value="{$opticals[0].label_optical_id}">
				<div class="form-group">
					<label for="barcode_id" class="control-label col-md-4">{t}Type de code-barre :{/t}</label>
					<div class="col-md-8">
						<select id="barcode_id" name="barcode_id" class="form-control">
							{foreach $barcodes as $barcode}
							<option value="{$barcode.barcode_id}" {if
								$barcode.barcode_id==$opticals[0].barcode_id}selected{/if}>
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
						</select>
					</div>
				</div>
				<div class="form-group">
					<label for="radical" class="control-label col-md-4">
						{t}Radical inséré avant l'attribut :{/t}
					</label>
					<div class="col-md-8">
						<input id="radical" type="text" class="form-control" name="radical"
							value="{$opticals[0].radical}">
					</div>
				</div>
				<div class="form-group">
					<label for="optical_content" class="control-label col-md-4"><span class="red">*</span>
						{t}Attribut inséré dans le code optique (si plusieurs attributs dans le format JSON, les séparer par une virgule, sans espace) :{/t}
					</label>
					<div class="col-md-8">
						<input id="optical_content" type="text" class="form-control" name="optical_content"
							value="{$opticals[0].optical_content}" required>
					</div>
				</div>
			</fieldset>
			<fieldset>
				<legend>{t}Second code optique : activer{/t}
					<input id="optical2Enabled" name="optical2enabled" value="1" type="checkbox" class="" {if $opticals[1].label_optical_id>
					0}checked{/if}>
				</legend>
				<input type="hidden" name="label_optical_id2" value="{$opticals[1].label_optical_id}">
				<div id="optical2" disabled hidden>
					<div class="form-group">
						<label for="barcode_id2" class="control-label col-md-4">{t}Type de code-barre :{/t}</label>
						<div class="col-md-8">
							<select id="barcode_id2" name="barcode_id2" class="form-control">
								{foreach $barcodes as $barcode}
								<option value="{$barcode.barcode_id}" {if
									$barcode.barcode_id==$opticals[1].barcode_id}selected{/if}>
									{$barcode.barcode_name}
								</option>
								{/foreach}
							</select>
						</div>
					</div>
					<div class="form-group">
						<label for="content_type2" class="control-label col-md-4">{t}Type de contenu :{/t}</label>
						<div class="col-md-8">
							<select id="content_type2" class="form-control" name="content_type2">
								<option value="1" {if $opticals[1].content_type==1}selected{/if}>
									{t}plusieurs valeurs différentes au format JSON (historique){/t}
								</option>
								<option value="2" {if $opticals[1].content_type==2}selected{/if}>
									{t}Un seul identifiant, type UUID, ou URI avec un radical{/t}
								</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label for="radical2" class="control-label col-md-4">
							{t}Radical inséré avant l'attribut :{/t}
						</label>
						<div class="col-md-8">
							<input id="radical2" type="text" class="form-control" name="radical2"
								value="{$opticals[1].radical}">
						</div>
					</div>
					<div class="form-group">
						<label for="optical_content2" class="control-label col-md-4"><span class="red">*</span>
							{t}Attribut inséré dans le code optique (si plusieurs attributs dans le format JSON, les séparer par une virgule, sans espace) :{/t}
						</label>
						<div class="col-md-8">
							<input id="optical_content2" type="text" class="form-control" name="optical_content2"
								value="{$opticals[1].optical_content}">
						</div>
					</div>
				</div>
			</fieldset>			
			<div class="form-group">
				<label for="logo" class="control-label col-md-4">
					{t}Logo à insérer dans l'étiquette (jpg, png) :{/t}
				</label>
				<div class="col-md-8">
					{if $data.has_logo == 1}
					<img src="labelGetLogo?label_id={$data.label_id}" height="30">
					{/if}
					<input id="logo" type="file" class="form-control" name="logo">
				</div>
			</div>
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
		<li>{t}Champs affichables sur l'étiquette et dans le QRCODE au format JSON :{/t}
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
				<li>{t}Si l'objet est toujours stocké au même endroit, pour pouvoir le replacer à son emplacement initial :{/t}
					<ul>
						<li>{t 1='stor'}%1 : nom du contenant{/t}</li>
						<li>{t 1='cnum'}%1 : numéro de la colonne{/t}</li>
						<li>{t 1='lnum'}%1 : numéro de la ligne{/t}</li>
					</ul>
				</li>
			</ul>
		</li>
		<li>{t}Champs utilisables dans un code optique avec un seul identifiant, au format texte, avec ou sans radical :{/t}
			<ul>
				<li>id</li>
				<li>uid</li>
				<li>uuid</li>
				<li>{t}tout identifiant secondaire non numérique - cf. paramètres > Types d'identifiants{/t}</li>
				<li>{t 1='dbuid_origin' escape=no}%1 : identifiant de la base de données d'origine. Pour un échantillon
					créé dans la base courante, la valeur sera de type <i>db:uid</i>{/t}</li>
			</ul>
		</li>
		<li>{t}Graphismes à insérer dans l'étiquette :{/t}
			<ul>
				<li>{t}xsl:value-of select="concat(uid,'.png')" : premier code optique{/t}</li>
				<li>{t}xsl:value-of select="concat(uid,'-2.png')" : second code optique{/t}</li>
				<li>{t}xsl:value-of select="concat(label_id,'-logo.png')" : logo{/t}</li>
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