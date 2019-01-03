{* Objets > échantillons > Rechercher > UID d'un échantillon > Modifier > *}
<script type="text/javascript" src="display/javascript/alpaca/js/formbuilder.js"></script>

<script type="text/javascript">
var identifier_fn = "";
var is_scan = false;
var sampling_place_init = "{$data.sampling_place_id}";
function testScan() {
	if (is_scan) {
		return false;
	} else {
		return true;
	}
}

    $(document).ready(function() {
    	
    	function convertGPStoDD(valeur) {
    		var parts = valeur.trim().split(/[^\d]+/);
    		var dd = parseFloat(parts[0])
    				+ parseFloat((parts[1] + "." + parts[2]) / 60);
    		var lastChar = valeur.substr(-1).toUpperCase();
    		dd = Math.round(dd * 1000000) / 1000000;
    		if (lastChar == "S" || lastChar == "W" || lastChar == "O") {
    			dd *= -1;
    		}
    		;
    		return dd;
    	}
    	$("#latitude").change( function () {
    		var value = $(this).val();
    		if (value.length > 0) {
    			$("#wgs84_y").val( convertGPStoDD(value));
    		}
    	});
    	$("#longitude").change( function () {
    		var value = $(this).val();
    		if (value.length > 0) {
    			$("#wgs84_x").val( convertGPStoDD(value));
    		}
    	});

        $("#scan_label").focus(function () {
        	is_scan = true;
        });
		$("#scan_label").blur(function () {
        	is_scan = false;
        });
			
    	
    	function getMetadata() {
    		/*
    		 * Recuperation du modele de metadonnees rattache au type d'echantillon
    		 */
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
       	    		if (value) {
       	    		//console.log(value);
       	    		var schema = value.replace(/&quot;/g,'"');
       	    		showForm(JSON.parse(schema),dataParse);
       	    		$(".alpaca-field-select").combobox();
       	    		}
       	    	})
       	    	;
       	    }
        }
    	
    	function getSamplingPlace () {
    		/*
    		 * Recuperation de la liste des lieux de prelevement rattaches a la collection
    		 */
    		var colid = $("#collection_id").val();
    		console.log ("colid:"+colid);
    		var url = "index.php";
    		var data = { "module":"samplingPlaceGetFromCollection", "collection_id": colid };
    		$.ajax ( { url:url, data: data})
    		.done (function( d ) {
   				if (d ) {
    				d = JSON.parse(d);
    				options = '<option value="">{t}Sélectionnez...{/t}</option>';			
    				 for (var i = 0; i < d.length; i++) {
    				        options += '<option value="'+d[i].sampling_place_id + '"';
    				        if (d[i].sampling_place_id == sampling_place_init ) {
    				        	options += ' selected ';
    				        }
    				        options += '>';
    				        if (d[i].sampling_place_code) {
    				        	options += d[i].sampling_place_code;
    				        } else {
    				        	options += d[i].sampling_place_name;
    				        }
    				        options += '</option>';
    				      };
    				$("#sampling_place_id").html(options);
    				}
    			});
    	}
    	
    	function getCoordinatesFromLocalisation() {
    		/*
    		 * Recuperation des coordonnees geographiques a partir du lieu de prelevement
    		 */
    		var locid = $("#sampling_place_id").val();
    		console.log ("sampling_place_id:"+locid);
    		if (locid > 0) {
    			var x = $("#wgs84_x").val();
    			var y = $("#wgs84_y").val();
    			if ( x.length == 0 && y.length == 0 ) {
    				var url = "index.php";
    	    		var data = { "module":"samplingPlaceGetCoordinate", "sampling_place_id": locid };
    	    		$.ajax ( { url:url, data: data})
    	    		.done (function( data ) {
    	    			data = JSON.parse(data);
    	    			if (data["sampling_place_x"].length > 0 && data["sampling_place_y"].length > 0) {
    	    				$("#wgs84_x").val(data["sampling_place_x"]);
    	    				$("#wgs84_y").val(data["sampling_place_y"]);
    	    				$("#wgs84_x").trigger("change");
    	    			}
    	    		});
    			}
    		}
    	}
    	
    	function getGenerator() {
    		/*
    		 * Recuperation du script utilisable pour generer l'identifiant metier
    		 */
    		var sti = $("#sample_type_id").val();
       	    if (sti) {
       	    	$.ajax( { 
       	    		url: "index.php",
       	    		data: { "module": "sampleTypeGenerator", "sample_type_id": sti }
       	    	})
       	    	.done (function (value) {
       	    		if (value.length > 0) {
       	    			identifier_fn = value;
       	    			$("#identifier_generate").prop("disabled", false);
       	    		} else {
       	    			$("#identifier_generate").prop("disabled", true);
       	    		}
       	    	})
     		}
    	}
    	
        $("#sample_type_id").change( function() {
       	 getMetadata();
       	 getGenerator();
        });
        
        $("#collection_id").change(function() {
        	getSamplingPlace();
        });
        
        $("#sampling_place_id").change (function() {
        	getCoordinatesFromLocalisation();
        });
        
        /*
         * Lecture initiale
         */
        getMetadata();
        getGenerator();
        getSamplingPlace();

        $('#sampleForm').submit(function(event) {
            if($("#action").val()=="Write"){
            	var error = false;
            	var sample_type_id = $("#sample_type_id").val();
            	if (sample_type_id) {
            		if (sample_type_id.length == 0 ) {
            			error = true;
            		} 
            	} else {
            		error = true;
            	}
            	var collection_id = $("#collection_id").val();
            	if (collection_id) {
            		if (collection_id.length == 0 ) {
            			error = true;
            		} 
            	} else {
            		error = true;
            	}
        
                $('#metadata').alpaca().refreshValidationState(true);
                if($('#metadata').alpaca().isValid(true)){
                	var value = $('#metadata').alpaca().getValue();
                	 // met les metadata en JSON dans le champ (name="metadata") qui sera sauvegardé en base
                	 $("#metadataField").val(JSON.stringify(value));
                	 console.log($("#metadataField").val());
                } else {
                   	error = true;
                }
                if (error) {
                	event.preventDefault();
                }
            	
            }

    	});
        $("#reinit").click(function() {
        	$("#wgs84_x").val("");
        	$("#wgs84_y").val("");
        	$("#sampling_date").val("");
        	$("#collection_id").val("");
        	$("#sample_type_id").val("");
        	$("#sampling_place_id").val("");
        	$("#multiple_value").val("");
        	$("#metadataField").val("");
        	showForm([],"");
        	point.setCoordinates ([]);
        	
        });
        $("#identifier_generate").click(function () {
        	if (identifier_fn.length > 0) {
        		$("#identifier").val(eval(identifier_fn));
        	}
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
        			 case "col":
        				 $('#collection_id option[value]="'+data["col"]+'"]').attr("selected", "selected");
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
        			 case "sd":
        				 $("#sampling_date").val(data["sd"]);
        				 break;
        			 case "cd":
        				 $("#sample_creation_date").val(data["cd"]);
        				 break; 
        			 case "ed":
        				 $("#expiration_date").val(data["ed"]);
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

<h2>{t}Création - modification d'un échantillon{/t}</h2>
<div class="row col-md-12">
<a href="index.php?module={$moduleListe}">
<img src="{$display}/images/list.png" height="25">
{t}Retour à la liste des échantillons{/t}
</a>
{if $data.uid > 0}
<a href="index.php?module=sampleDisplay&uid={$data.uid}">
<img src="{$display}/images/box.png" height="25">{t}Retour au détail{/t}
</a>
{elseif $sample_parent_uid > 0}
<a href="index.php?module=sampleDisplay&uid={$sample_parent_uid}">
<img src="{$display}/images/box.png" height="25">{t}Retour au détail{/t}
</a>
{/if}
</div>
<div class="row">
{if $data.parent_sample_id > 0}
<fieldset class="col-md-6">
<legend>{t}Échantillon parent{/t}</legend>
<div class="form-display">
<dl class="dl-horizontal">
<dt>{t}UID et référence :{/t}</dt>
<dd>
<a href="index.php?module=sampleDisplay&uid={$parent_sample.uid}">
{$parent_sample.uid} {$parent_sample.identifier}
</a>
</dd>
</dl>
<dl class="dl-horizontal">
<dt>{t}Collection :{/t}</dt>
<dd>{$parent_sample.collection_name}</dd>
</dl>
<dl class="dl-horizontal">
<dt>{t}Type :{/t}</dt>
<dd>{$parent_sample.sample_type_name}</dd>
</dl>
</div>
</fieldset>
{/if}
</div>
{if $data.sample_id == 0}
<button type="button" class="btn btn-warning" id="reinit">{t}Réinitialiser les champs{/t}</button>
{/if}
<div class="row">
<fieldset class="col-md-6">
<legend>{t}Échantillon{/t}</legend>
<form class="form-horizontal protoform" id="sampleForm" method="post" action="index.php" onsubmit="return(testScan());">
<input type="hidden" name="sample_id" value="{$data.sample_id}">
<input type="hidden" name="moduleBase" value="sample">
<input type="hidden" id="action" name="action" value="Write">
<input type="hidden" name="parent_sample_id" value="{$data.parent_sample_id}">
<input type="hidden" name="metadata" id="metadataField" value="{$data.metadata}">
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.sample_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
<div class="form-group">
<label for="scan_label" class="control-label col-md-4">{t}Scannez l'étiquette existante :{/t}</label>
<div class="col-md-5">
<input id="scan_label" class="form-control" placeholder="{t}Placez le curseur dans cette zone et scannez l'étiquette{/t}">
</div>
<div class="col-md-3">
<button class="btn btn-info" type="button" id="scan_label_action">{t}Mettre à jour les champs{/t}</button>
</div>
</div>

<div class="form-group">
<label for="uid" class="control-label col-md-4">{t}UID :{/t}</label>
<div class="col-md-8">
<input id="uid" name="uid" value="{$data.uid}" readonly class="form-control" title="{t}identifiant unique dans la base de données{/t}">
</div>
</div>

<div class="form-group">
<label for="appli" class="control-label col-md-4">{t}Identifiant ou nom :{/t}</label>
<div class="col-md-6">
<input id="identifier" type="text" name="identifier" class="form-control" value="{$data.identifier}" autofocus >
</div>
<div class="col-md-2">
<button class="btn btn-info" type="button" id="identifier_generate" disabled
title="{t}Générez l'identifiant à partir des informations saisies{/t}">{t}Générer{/t}</button>
</div>
</div>

<div class="form-group">
<label for="object_status_id" class="control-label col-md-4"><span class="red">*</span> {t}Statut :{/t}</label>
<div class="col-md-8">
<select id="object_status_id" name="object_status_id" class="form-control">
{section name=lst loop=$objectStatus}
<option value="{$objectStatus[lst].object_status_id}" {if $objectStatus[lst].object_status_id == $data.object_status_id}selected{/if}>
{$objectStatus[lst].object_status_name}
</option>
{/section}
</select>
</div>
</div>

<div class="form-group">
<label for="collection_id" class="control-label col-md-4"><span class="red">*</span> {t}Collection :{/t}</label>
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
<label for="referentId"  class="control-label col-md-4">{t}Référent de l'échantillon :{/t}</label>
<div class="col-md-8">
<select id="referentId" name="referent_id" class="form-control">
      <option value="" {if $data.referent_id == ""}selected{/if}>Choisissez...</option>
      {foreach $referents as $referent}
            <option value="{$referent.referent_id}" {if $data.referent_id == $referent.referent_id}selected{/if}>
            {$referent.referent_name}
            </option>
      {/foreach}
</select>
</div>
</div>

<div class="form-group">
<label for="sample_type_id" class="control-label col-md-4"><span class="red">*</span> {t}Type :{/t}</label>
<div class="col-md-8">
<select id="sample_type_id" name="sample_type_id" class="form-control">
<option disabled selected value >{t}Choisissez...{/t}</option>
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
<label for="dbuid_origin" class="control-label col-md-4">{t}Base de données et UID d'origine :{/t}</label>
<div class="col-md-8">
<input id="dbuid_origin" class="form-control" name="dbuid_origin" value="{$data.dbuid_origin}" placeholder="{t}db:uid. Exemple: col:125{/t}">
</div>
</div>

<div class="form-group">
<label for="sampling_place_id" class="control-label col-md-4">{t}Lieu de prélèvement :{/t}</label>
<div class="col-md-8">
<select id="sampling_place_id" name="sampling_place_id" class="form-control ">
</select>
</div>
</div>
<div class="form-group">
<label for="wy" class="control-label col-md-4">{t}Latitude :{/t}</label>
<div class="col-md-8" id="wy">
<input id="latitude" placeholder="45°01,234N" autocomplete="off" class="form-control">
<input id="wgs84_y" name="wgs84_y" placeholder="45.01300" autocomplete="off" class="form-control taux position" value="{$data.wgs84_y}">
</div>
</div>

<div class="form-group">
<label for="wx" class="control-label col-md-4">{t}Longitude :{/t}</label>
<div class="col-md-8" id="wx">
<input id="longitude" placeholder="0°01,234W" autocomplete="off" class="form-control">
<input id="wgs84_x" name="wgs84_x" placeholder="-0.0156" autocomplete="off" class="form-control taux position" value="{$data.wgs84_x}">
</div>
</div>



<div class="form-group">
<label for="sampling_date"  class="control-label col-md-4">{t}Date de création/échantillonnage de l'échantillon :{/t}</label>
<div class="col-md-8">
<input id="sampling_date" class="form-control datetimepicker" name="sampling_date" value="{$data.sampling_date}"></div>
</div>

<div class="form-group">
<label for="sample_creation_date"  class="control-label col-md-4">{t}Date d'import dans la base de données :{/t}</label>
<div class="col-md-8">
<input id="sample_creation_date" class="form-control" name="sample_creation_date" readonly value="{$data.sample_creation_date}"></div>
</div>
<div class="form-group">
<label for="expiration_date"  class="control-label col-md-4">{t}Date d'expiration de l'échantillon :{/t}</label>
<div class="col-md-8">
<input id="expiration_date" class="form-control datepicker" name="expiration_date"  value="{$data.expiration_date}"></div>
</div>

<fieldset>
<legend>{t}Sous-échantillonnage (si le type le permet){/t}</legend>
<div class="form-group">
<label for="multiple_value"  class="control-label col-md-4">
{t 1=$data.multiple_type_name 2=$data.multiple_unit}Quantité initiale de sous-échantillons (%1:%2) :{/t}</label>
<div class="col-md-8">
<input id="multiple_value" class="form-control taux" name="multiple_value" value="{$data.multiple_value}"></div>
</div>
</fieldset>

<fieldset>
    <legend>{t}Jeu de métadonnées{/t}</legend>
    <div class="form-group">
    <div class="col-md-10 col-sm-offset-1">
    <div id="metadata"></div>
    </div>
    </div>
</fieldset>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.sample_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>

</form>
</fieldset>
<div class="col-md-6">
{include file="gestion/objectMapDisplay.tpl"}
</div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>