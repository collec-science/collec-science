{include file="param/metadataFormJS.tpl"}

<script type="text/javascript">
function toHex(txt){
		const encoder = new TextEncoder();
		return Array
			.from(encoder.encode(txt))
			.map(b => b.toString(16).padStart(2, '0'))
			.join('')
	}
$(document).ready(function() {

        var metadataParse= $("#metadataField").val();
        if (metadataParse.length > 0) {
            metadataParse = metadataParse.replace(/&quot;/g,'"');
            metadataParse = JSON.parse(metadataParse);
        }
        renderForm(metadataParse);
        $('#metadataForm').submit(function(event) {
        	if ($("#action").val() == "Write") {
                $('#metadata').alpaca().refreshValidationState(true);
                var reserved = ["sampling_date", "expiration_date", "sample_creation_date", "change_date"];
                $(".alpaca-control").each(function (i, e) {
                    if (reserved.includes($(e).val())) {
                       alert("{t}Le nom suivant ne peut pas être utilisé (mot réservé dans la base de données) :{/t}" + $(e).val());
                        event.preventDefault();
                    }
                });
                if(!$('#metadata').alpaca().isValid(true)){
                	alert("{t}La définition des métadonnées n'est pas valide.{/t}");
                	event.preventDefault();
                }
                $("#schemaSent").val(toHex ($("#metadataField").val() ) );
            }
        });
    });
</script>

<h2>{t}Création - Modification d'un modèle de métadonnées{/t}</h2>
<div class="row">
<div class="col-lg-8 col-md-12">
<a href="metadataList">
    <img src="display/images/list.png" height="25">
    {t}Retour à la liste{/t}
</a>
{if $data.metadata_id > 0}
    &nbsp;<img src="display/images/display.png" height="25">
    <a href="metadataDisplay?metadata_id={$data.metadata_id}">
        {t}Retour au détail{/t}
    </a>
{/if}

<form class="form-horizontal " id="metadataForm" method="post" action="metadataWrite" enctype="multipart/form-data">
    {if $nbSample < 1}
        <div class="form-group center">
            <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
        </div>
    {/if}
{if $nbSample > 0}<fieldset disabled>{/if}
<input type="hidden" name="moduleBase" value="metadata">
<input type="hidden" name="metadata_id" value="{$data.metadata_id}">
<input type="hidden" name="metadataField" id="metadataField" value="{$data.metadata_schema}">
<input type="hidden" name="metadata_schema" id="schemaSent">

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
{$csrf}</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
