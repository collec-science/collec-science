{* Paramètres > Étiquettes > Nouveau > *}
<script>
$(document).ready( function() {
     function getMetadata() {
    	 $("#list_metadata").empty();
				var schema;
				var oi = $("#metadata_id").val();
				if (oi.length > 0) {
					$.ajax( {
						url: "index.php",
						data: { "module": "metadataGetschema", "metadata_id": oi }
					})
					.done (function (value) {
						$.each(JSON.parse(value), function(i, obj) {
							var name = obj.name.replace(/ /g,"_");
							$("#list_metadata").append($("<li>").text(name));
						})
					})
					;
				}
     }
     $("#metadata_id").change( function() {
    	 getMetadata();
     });
     getMetadata();
		 $("#stay").click(function () {
			$( this.form ).find( "input[name='action']" ).val( "WriteStay" );
			$(this.form).submit();
		 });
}) ;

</script>

<h2>{t}Création - Modification d'une étiquette{/t}</h2>
<div class="row">
<div class="col-md-12">
<a href="index.php?module=labelList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal protoform" id="labelForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="label">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="label_id" value="{$data.label_id}">
<input type="hidden" name="metadata_id" value="{$metadata_id}">
<div class="form-group">
<label for="labelName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom de l'étiquette :{/t}</label>
<div class="col-md-8">
<input id="labelName" type="text" class="form-control" name="label_name" value="{$data.label_name}" autofocus required>
</div>
</div>
<div class="form-group">
<label for="xsl"  class="control-label col-md-4"><span class="red">*</span> {t}Transformation XSL :{/t}</label>
<div class="col-md-8">
<textarea id="label_xsl" name="label_xsl" class="form-control textarea-edit" rows="20" required>{$data.label_xsl}</textarea>
</div>
</div>
<div class="form-group">
	<label for="barcode_id" class="control-label col-md-4">{t}Type de code-barre :{/t}</label>
	<div class="col-md-8">
		<select id="barcode_id" name="barcode_id" class="form-control">
			{foreach $barcodes as $barcode}
				<option value="{$barcode.barcode_id}" {if $barcode.barcode_id == $data.barcode_id}selected{/if}>
					{$barcode.barcode_name}
				</option>
			{/foreach}
		</select>
	</div>
</div>
<div class="form-group">
<label for ="identifiers_only" class="control-label col-md-4">{t}Étiquette ne comprenant qu'un identifiant métier ?{/t}</label>
<div class="col-md-8" id="identifiers_only">
<div class="radio-inline">
<label>
<input type="radio" name="identifier_only" id="identifier_only1" value="1" {if $data.identifier_only == 1}checked{/if}>
{t}oui{/t}
</label>
</div>
<div class="radio-inline">
<label>
<input type="radio" name="identifier_only" id="identifier_only0" value="0" {if $data.identifier_only == 0}checked{/if}>
{t}non{/t}
</label>
</div>
</div>
</div>

<div class="form-group">
<label for="label_fields"  class="control-label col-md-4"><span class="red">*</span> {t}Champs à insérer dans le QR Code (séparés par une virgule, sans espace) :{/t}</label>
<div class="col-md-8">
<input id="label_fields" type="text" class="form-control" name="label_fields" value="{$data.label_fields}" required>
</div>
</div>
<div class="form-group">
<label for="metadata_id"  class="control-label col-md-4">{t}Modèle de métadonnées rattaché à l'étiquette :{/t}</label>
<div class="col-md-8">
<select id="metadata_id" name="metadata_id" class="form-control" >
<option value="" {if $data.metadata_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
{foreach $metadata as $value}
<option value="{$value.metadata_id}" {if $value.metadata_id == $data.metadata_id}selected{/if}>
{$value.metadata_name}
</option>
{/foreach}
</select>
</div>
</div>

<div class="form-group center">
			<button id="stay"  class="btn btn-primary">{t}Valider{/t}</button>
      <button type="submit" class="btn btn-primary button-valid">{t}Valider et retour{/t}</button>
      {if $data.label_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
</form>
</div>
</div>
<div class="bg-info">
{t}Champs utilisables dans le QR Code et dans le texte de l'étiquette :{/t}
<ul>
<li>{t}Cas général : QR Code au format JSON, avec plusieurs informations stockées{/t}
<ul>
<li>{t 1='uid'}%1 (obligatoire) : identifiant unique{/t}</li>
<li>{t 1='db'}%1 (obligatoire) : code de la base de données (utilisé pour éviter de mélanger les échantillons entre plusieurs bases){/t}</li>
<li>{t 1='id'}%1 : identifiant général{/t}</li>
<li>{t 1='col'}%1 : code de la collection{/t}</li>
<li>{t 1='pid'}%1 : identifiant de l'échantillon parent{/t}</li>
<li>{t 1='clp'}%1 : code de risque{/t}</li>
<li>{t 1='pn'}%1 : nom du protocole{/t}</li>
<li>{t 1='x'}%1 : coordonnée wgs84_x de l'objet (lieu de prélèvement ou de stockage suivant le cas){/t}</li>
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
<li>{t}Cas particulier : code-barre avec un seul identifiant, au format texte :{/t}
<ul>
<li>id</li>
<li>uid</li>
<li>{t}tout identifiant secondaire non numérique - cf. paramètres > Types d'identifiants{/t}</li>
<li>{t 1='dbuid_origin' escape=no}%1 : identifiant de la base de données d'origine. Pour un échantillon créé dans la base courante, la valeur sera de type <i>db:uid</i>{/t}</li>
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
