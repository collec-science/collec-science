<script type="text/javascript" src="display/javascript/alpaca/js/formbuilder.js"></script>

<script type="text/javascript">
var is_scan = false;
function testScan() {
	if (is_scan) {
		return false;
	} else {
		return true;
	}
}

    $(document).ready(function() {
        $("#scan_label").focus(function () {
        	is_scan = true;
        });
		$("#scan_label").blur(function () {
        	is_scan = false;
        });
			
    	
    	function getMetadata() {
       		var dataParse = $("#metadataField").val();
        	 dataParse = dataParse.replace(/&quot;/g,'"');
        	 dataParse = dataParse.replace(/\n/g,"\\n");
        	 if (dataParse.length > 2) {
        		 dataParse = JSON.parse(dataParse);
        	 }
        	 //console.log(dataParse);
       	    var schema;
       	    var sti = $("#sample_type_id").val();
       	    if (sti) {
       	    	$.ajax( { 
       	    		url: "index.php",
       	    		data: { "module": "sampleTypeMetadata", "sample_type_id": sti }
       	    	})
       	    	.done (function (value) {
       	    		//console.log(value);
       	    		var schema = value.replace(/&quot;/g,'"');
       	    		showForm(JSON.parse(schema),dataParse);
       	    		$(".alpaca-field-select").combobox();
       	    	})
       	    	;
       	    }
        }
        $("#sample_type_id").change( function() {
       	 getMetadata();
        });
        /*
         * Lecture initiale
         */
        getMetadata();

        $('#sampleForm').submit(function(event) {
            if($("#action").val()=="Write"){
                $('#metadata').alpaca().refreshValidationState(true);
                if($('#metadata').alpaca().isValid(true)){
                	if($('#metadata').alpaca().isValid(true)){
                		 var value = $('#metadata').alpaca().getValue();
                		 // met les metadata en JSON dans le champ (name="metadata") qui sera sauvegardé en base
                		 $("#metadataField").val(JSON.stringify(value));
                		 console.log($("#metadataField").val());
                	} else {
                    	alert("La définition des métadonnées n'est pas valide.");
                    	event.preventDefault();
                	}
            	}
            }
    	});
        $("#reinit").click(function() {
        	$("#wgs84_x").val("");
        	$("#wgs84_y").val("");
        	$("#sample_date").val("");
        	$("#collection_id").val("");
        	$("#sample_type_id").val("");
        	$("#sampling_place_id").val("");
        	$("#multiple_value").val("");
        	$("#metadataField").val("");
        	showForm([],"");
        	point.setCoordinates ([]);
        	
        });

        
        $("#scan_label_action").click(function() {
        	var contenu = $("#scan_label").val();
        	if (contenu.length > 0) {
        	try {
        		var data = JSON.parse(contenu);
        		/*
        		 * Traitement de chaque cle
        		 */
        		 for (var key in data) {
        			 switch (key) {
        			 case "uid":
        				 $("#dbuid_origin").val(data["db"]+":"+data["uid"]);
        				 break;
        			 case "id":
        				 $("#identifier").val(data["id"]);
        				 break;
        			 case "prj":
        				 $('#collection_id option[value]="'+data["prj"]+'"]').attr("selected", "selected");
        				 break;
        			 case "x":
        				 $("#wgs84_x").val(data["x"]);
        				 break;
        			 case "y":
        				 $("#wgs84_y").val(data["y"]);
        				 break;
        			 case "loc":
        				 $('#sampling_place_id option[value]="'+data["loc"]+'"]').attr("selected", "selected");
        				 break;
        			 case "cd":
        				 $("#sample_date").val(data["cd"]);
        				 break;
        			default:
        				$('input[name='+key+']').val(data[key]);
        					 
        				break;
        				 
        				
        			 }
        		 }
        	} catch (e) {
        		console.error ("Parsing Json error:", e);
        	}
        	}
        	
        });
    });
</script>

<h2>Création - modification d'un échantillon</h2>
<div class="row col-md-12">
<a href="index.php?module=sampleList">
<img src="{$display}/images/list.png" height="25">
Retour à la liste des échantillons
</a>
{if $data.uid > 0}
<a href="index.php?module=sampleDisplay&uid={$data.uid}">
<img src="{$display}/images/box.png" height="25">Retour au détail
</a>
{elseif $sample_parent_uid > 0}
<a href="index.php?module=sampleDisplay&uid={$sample_parent_uid}">
<img src="{$display}/images/box.png" height="25">Retour au détail
</a>
{/if}
</div>
<div class="row">
{if $data.parent_sample_id > 0}
<fieldset class="col-md-6">
<legend>Échantillon parent</legend>
<div class="form-display">
<dl class="dl-horizontal">
<dt>UID et référence :</dt>
<dd>
<a href="index.php?module=sampleDisplay&uid={$parent_sample.uid}">
{$parent_sample.uid} {$parent_sample.identifier}
</a>
</dd>
</dl>
<dl class="dl-horizontal">
<dt>Projet :</dt>
<dd>{$parent_sample.collection_name}</dd>
</dl>
<dl class="dl-horizontal">
<dt>Type :</dt>
<dd>{$parent_sample.sample_type_name}</dd>
</dl>
</div>
</fieldset>
{/if}
</div>
{if $data.sample_id == 0}
<button type="button" class="btn btn-warning" id="reinit">Réinitialiser les champs</button>
{/if}
<div class="row">
<fieldset class="col-md-6">
<legend>Échantillon</legend>
<form class="form-horizontal protoform" id="sampleForm" method="post" action="index.php" onsubmit="return(testScan());">
<input type="hidden" name="sample_id" value="{$data.sample_id}">
<input type="hidden" name="moduleBase" value="sample">
<input type="hidden" id="action" name="action" value="Write">
<input type="hidden" name="parent_sample_id" value="{$data.parent_sample_id}">
<input type="hidden" name="metadata" id="metadataField" value="{$data.metadata}">

<div class="form-group">
<label for="scan_label" class="control-label col-md-4">Scannez l'étiquette existante :</label>
<div class="col-md-5">
<input id="scan_label" class="form-control" placeholder="Placez le curseur dans la zone et scannez l'étiquette">
</div>
<div class="col-md-3">
<button class="btn btn-info" type="button" id="scan_label_action">Mettre à jour les champs</button>
</div>
</div>


{include file="gestion/uidChange.tpl"}

<div class="form-group">
<label for="collection_id" class="control-label col-md-4">Projet<span class="red">*</span> :</label>
<div class="col-md-8">
<select id="collection_id" name="collection_id" class="form-control" autofocus>
{section name=lst loop=$collections}
<option value="{$collections[lst].collection_id}" {if $data.collection_id == $collections[lst].collection_id}selected{/if}>
{$collections[lst].collection_name}
</option>
{/section}
</select>
</div>
</div>


<div class="form-group">
<label for="sample_type_id" class="control-label col-md-4">Type<span class="red">*</span> :</label>
<div class="col-md-8">
<select id="sample_type_id" name="sample_type_id" class="form-control">
<option disabled selected value >{$LANG["appli"][2]}</option>
{section name=lst loop=$sample_type}
<option value="{$sample_type[lst].sample_type_id}" {if $sample_type[lst].sample_type_id == $data.sample_type_id}selected{/if}>
{$sample_type[lst].sample_type_name} 
{if $sample_type[lst].multiple_type_id > 0}
/{$sample_type[lst].multiple_type_name} : {$sample_type[lst].multiple_unit}
{/if}
</option>
{/section}
</select>
</div>
</div>

<div class="form-group">
<label for="dbuid_origin" class="control-label col-md-4">Base de données et UID d'origine :</label>
<div class="col-md-8">
<input id="dbuid_origin" class="form-control" name="dbuid_origin" value="{$data.dbuid_origin}" placeholder="db:uid. Exemple: col:125">
</div>
</div>


<div class="form-group">
<label for="sampling_place_id" class="control-label col-md-4">Lieu de prélèvement :</label>
<div class="col-md-8">
<select id="sampling_place_id" name="sampling_place_id" class="form-control combobox">
<option value="" {if $data.sampling_place_id == ""}selected{/if}>
Sélectionnez...
</option>
{section name=lst loop=$samplingPlace}
<option value="{$samplingPlace[lst].sampling_place_id}" {if $samplingPlace[lst].sampling_place_id == $data.sampling_place_id}selected{/if}>
{$samplingPlace[lst].sampling_place_name} 
</option>
{/section}
</select>
</div>
</div>

<div class="form-group">
<label for="sample_date"  class="control-label col-md-4">Date de création de l'échantillon :</label>
<div class="col-md-8">
<input id="sample_date" class="form-control datetimepicker" name="sample_date" value="{$data.sample_date}"></div>
</div>

<div class="form-group">
<label for="sample_creation_date"  class="control-label col-md-4">Date d'import dans la base de données :</label>
<div class="col-md-8">
<input id="sample_creation_date" class="form-control" name="sample_creation_date" readonly value="{$data.sample_creation_date}"></div>
</div>
<fieldset>
<legend>Sous-échantillonnage (si le type le permet)</legend>
<div class="form-group">
<label for="multiple_value"  class="control-label col-md-4">
Quantité initiale de sous-échantillons ({$data.multiple_type_name}:{$data.multiple_unit}) :</label>
<div class="col-md-8">
<input id="multiple_value" class="form-control taux" name="multiple_value" value="{$data.multiple_value}"></div>
</div>
</fieldset>

<fieldset>
    <legend>Jeu de métadonnées</legend>
    <div class="form-group">
    <div class="col-md-10 col-sm-offset-1">
    <div id="metadata"></div>
    </div>
    </div>
</fieldset>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.sample_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>

</form>
</fieldset>
<div class="col-md-6">
{include file="gestion/objectMapDisplay.tpl"}
</div>
</div>

<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>