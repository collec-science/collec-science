{* Paramètres > Métadonnées > Nouveau > *}

{include file="param/metadataFormJS.tpl"}

<script type="text/javascript">
function loadSchema(){

}

$(document).ready(function() {

        var metadataParse= $("#metadataField").val();
        if (metadataParse.length > 0) {
            metadataParse = metadataParse.replace(/&quot;/g,'"');
            metadataParse = JSON.parse(metadataParse);
        }
        renderForm(metadataParse);

        $('#metadataForm').submit(function(event) {
        	console.log("write");
        	if ($("#action").val() == "Write") {
        		$('#metadata').alpaca().refreshValidationState(true);
                if(!$('#metadata').alpaca().isValid(true)){
                	alert("{t}La définition des métadonnées n'est pas valide.{/t}");
                	event.preventDefault();
                }
        	}
        });        
    });
</script>

<h2>{t}Création - Modification d'un modèle de métadonnées{/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=metadataList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal protoform" id="metadataForm" method="post" action="index.php" enctype="multipart/form-data">
{if $nbSample > 0}<fieldset disabled>{/if}
<input type="hidden" name="moduleBase" value="metadata">
<input type="hidden" id="action" name="action" value="Write">
<input type="hidden" name="metadata_id" value="{$data.metadata_id}">
<input type="hidden" name="metadata_schema" id="metadataField" value="{$data.metadata_schema}">

<div class="form-group">
<label for="metadataName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom du modèle :{/t}</label>
<div class="col-md-8">
<input id="metadataName" type="text" class="form-control" name="metadata_name" value="{$data.metadata_name}" required autofocus>
</div>
</div>

<fieldset>
<legend>{t}Jeu de métadonnées{/t}</legend>


<div id="metadata"></div>

</fieldset>

{if $nbSample < 1}
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.metadata_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
 {/if}
 {if $nbSample > 0}</fieldset>{/if}
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>