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
    	    		//console.log( value );
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
}) ;

</script>

<h2>Modification d'une étiquette</h2>
<div class="row">
<div class="col-md-12">
<a href="index.php?module=labelList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="labelForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="label">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="label_id" value="{$data.label_id}">
<input type="hidden" name="metadata_id" value="{$metadata_id}">
<div class="form-group">
<label for="labelName"  class="control-label col-md-4">Nom de l'étiquette<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="labelName" type="text" class="form-control" name="label_name" value="{$data.label_name}" autofocus required>
</div>
</div>
<div class="form-group">
<label for="xsl"  class="control-label col-md-4">Transformation XSL<span class="red">*</span> :</label>
<div class="col-md-8">
<textarea id="label_xsl" name="label_xsl" class="form-control" rows="20" required>{$data.label_xsl}</textarea>
</div>
</div>
<div class="form-group">
<label for ="identifiers_only" class="control-label col-md-4">Étiquette ne comprenant qu'un identifiant métier ?</label>
<div class="col-md-8" id="identifiers_only">
<div class="radio-inline">
<label>
<input type="radio" name="identifier_only" id="identifier_only1" value="1" {if $data.identifier_only == 1}checked{/if}>
oui
</label>
</div>
<div class="radio-inline">
<label>
<input type="radio" name="identifier_only" id="identifier_only0" value="0" {if $data.identifier_only == 0}checked{/if}>
non
</label>
</div>
</div>
</div>

<div class="form-group">
<label for="label_fields"  class="control-label col-md-4">Champs à insérer dans le QRCode (séparés par une virgule, sans espace)<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="label_fields" type="text" class="form-control" name="label_fields" value="{$data.label_fields}" required>
</div>
</div>
<div class="form-group">
<label for="metadata_id"  class="control-label col-md-4">Modèle de métadonnées rattaché à l'étiquette :</label>
<div class="col-md-8">
<select id="metadata_id" name="metadata_id" class="form-control" >
<option value="" {if $data.metadata_id == ""}selected{/if}>Sélectionnez...</option>
{foreach $metadata as $value}
<option value="{$value.metadata_id}" {if $value.metadata_id == $data.metadata_id}selected{/if}>
{$value.metadata_name}
</option>
{/foreach}
</select>
</div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.label_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<div class="bg-info">
Champs utilisables dans le QRcode et dans le texte de l'étiquette :
<ul>
<li>Cas général : QrCode au format JSON, avec plusieurs informations stockées
<ul>
<li>uid (obligatoire) : identifiant unique</li>
<li>db (obligatoire) : code de la base de données (utilisé pour éviter de mélanger les échantillons entre plusieurs bases)</li>
<li>id : identifiant général</li>
<li>prj : code du projet</li>
<li>clp : code de risque</li>
<li>pn : nom du protocole</li>
<li>x : coordonnée wgs84_x de l'objet (lieu de prélèvement ou de stockage suivant le cas)</li>
<li>y : coordonnée wgs84_y de l'objet</li>
<li>loc : localisation du prélèvement (table des lieux de prélèvement)</li>
<li>prod : produit utilisé pour la conservation</li>
<li>cd : date d'import/création dans la base de données</li>
<li>et tous les codes d'identifiants secondaires - cf. paramètres > Types d'identifiants</li>
</ul>
</li>
<li>Cas particulier : QrCode avec uniquement un identifiant, au format texte
<ul>
<li>id ou tout identifiant secondaire non numérique - cf. paramètres > Types d'identifiants</li>
</ul>
</li>
</ul>
</div>

<div class="bg-info">
Métadonnées utilisables dans le QRcode et dans le texte de l'étiquette :
<ul id="list_metadata">
</ul>
</div>
</fieldset>

<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>
