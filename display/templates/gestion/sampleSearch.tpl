<script>
$(document).ready(function () {
	var metadataFieldInitial = [];
	{foreach $sampleSearch.metadata_field as $val}
	metadataFieldInitial.push ( "{$val}" );
	{/foreach}
	console.log (metadataFieldInitial);

	/*
	 * Verification que des criteres de selection soient saisis
	 */
	 $("#sample_search").submit (function ( event) { 
		 var ok = false;
		 if ($("#name").val().length > 0) ok = true;
		 if ($("#collection_id").val() > 0) ok = true;
		 if ($("#uid_min").val() > 0) ok = true;
		 if ($("#uid_max").val() > 0) ok = true;
		 if ($("#sample_type_id").val() > 0) ok = true;
		 if ($("#sampling_place_id").val() > 0 ) ok = true ;
		 if ($("#object_status_id").val() > 1) ok = true;
		 if ($("#select_date").val().length > 0) ok = true;
		 var mf = $("#metadata_field").val();
		 if ( mf != null) {
			 if (mf.length > 0 && $("#metadata_value").val().length > 0) {
				 ok = true;			 
			 }
		 }
		 if (ok == false) event.preventDefault();
	 });
	
	 function getMetadata() {
		 var sampleTypeId = $("#sample_type_id").val();
		 $("#metadata_field").empty();
		 //$("#metadata_value").val("");
		 $("#metadata_field1").empty();
		 //$("#metadata_value_1").val("");
		 $("#metadata_field2").empty();
		 //$("#metadata_value_2").val("");
		 $("#metadatarow1").hide();
		 $("#metadatarow2").hide();
		 
		 if (sampleTypeId.length > 0) {
    	    $.ajax( { 
    	   		url: "index.php",
    	    	data: { "module": "sampleTypeMetadata", "sample_type_id": sampleTypeId }
    	    })
    	    .done (function (value) {
    	    	if (value.length > 0) {
    	    		var selected = "";
    	    		var option = '<option value="">Métadonnée :</option>';
    	    		$("#metadata_field").append(option);
    	    		$("#metadata_field1").append(option);
    	    		$("#metadata_field2").append(option);
    	   			$.each(JSON.parse(value), function(i, obj) {
    	   				if (obj.isSearchable == "yes") {
    	    			var nom = obj.name.replace(/ /g,"_");
    	    			if (nom == metadataFieldInitial[0]) {
    	    				selected = "selected";
    	    				$("#metadatarow1").show();
    	    			}
    	    			option = '<option value="'+nom+'" '+selected+'>'+nom+'</option>';
    	    			$("#metadata_field").append(option);
    	    			/* second champ */
    	    			selected = "";
    	    			if (nom == metadataFieldInitial[1]) {
    	    				selected = "selected";
    	    				$("#metadatarow2").show();
    	    			}
    	    			option = '<option value="'+nom+'" '+selected+'>'+nom+'</option>';
    	    			$("#metadata_field1").append(option);
    	    			/* 3eme champ */
    	    			selected = "";
    	    			if (nom == metadataFieldInitial[2]) {
    	    				selected = "selected";
    	    			}
    	    			option = '<option value="'+nom+'" '+selected+'>'+nom+'</option>';
    	    			$("#metadata_field2").append(option);
    	    			selected = "";
    	    			
    	   				}
    	    		})
    	    	}
    	   	})
    	   	;
	 	}
     }
	 
     $("#sample_type_id").change( function() {
    	 getMetadata();
     });
     getMetadata();
     $("#sample_type_id").combobox({
    	 select: function (event, ui) {
    		 $("#metadata_value").val("");
    		 $("#metadata_value_2").val("");
    		 $("#metadata_value_1").val("");
    		 getMetadata();
    	 }
     });
     $("#metadatarow1").hide();
     $("#metadatarow2").hide();
     $("#metadata_value").change(function () { 
    		 if ($(this).val().length > 0) {
    			 $("#metadatarow1").show();
    		 }
     });
     $("#metadata_value_1").change(function () { 
		 if ($(this).val().length > 0) {
			 $("#metadatarow2").show();
		 }
 });
});
</script>

<form class="form-horizontal protoform col-md-12" id="sample_search" action="index.php" method="GET">
<input id="moduleBase" type="hidden" name="moduleBase" value="{if strlen($moduleBase)>0}{$moduleBase}{else}sample{/if}">
<input id="action" type="hidden" name="action" value="{if strlen($action)>0}{$action}{else}List{/if}">
<input id="isSearch" type="hidden" name="isSearch" value="1">
<div class="row">
<div class="form-group">
<label for="name" class="col-md-2 control-label">uid ou identifiant :</label>
<div class="col-md-4">
<input id="name" type="text" class="form-control" name="name" value="{$sampleSearch.name}" title="uid, identifiant principal, identifiants secondaires (p. e. : cab:15 possible)">
</div>
<label for="collection_id" class="col-md-2 control-label">Collection :</label>
<div class="col-md-4">
<select id="collection_id" name="collection_id" class="form-control">
<option value="" {if $sampleSearch.collection_id == ""}selected{/if}>{$LANG.appli.2}</option>
{section name=lst loop=$collections}
<option value="{$collections[lst].collection_id}" {if $collections[lst].collection_id == $sampleSearch.collection_id}selected{/if}>
{$collections[lst].collection_name}
</option>
{/section}
</select>
</div>
</div>
</div>

<div class="row">
<div class="form-group">
<label for="container_family_id" class="col-md-2 control-label">UID entre :</label>
<div class="col-md-2">
<input id="uid_min" name="uid_min" class="nombre form-control" value="{$sampleSearch.uid_min}">
</div>
<div class="col-md-2">
<input id="uid_max" name="uid_max" class="nombre form-control" value="{$sampleSearch.uid_max}">
</div>

<label for="sample_type_id" class="col-md-2 control-label">Type :</label>
<div class="col-md-4">
<select id="sample_type_id" name="sample_type_id" class="form-control combobox">
<option value="" {if $sampleSearch.sample_type_id == ""}selected{/if}>Sélectionnez...</option>
{section name=lst loop=$sample_type}
<option value="{$sample_type[lst].sample_type_id}" {if $sample_type[lst].sample_type_id == $sampleSearch.sample_type_id}selected{/if} title="{$sample_type[lst].sample_type_description}">
{$sample_type[lst].sample_type_name}
</option>
{/section}
</select>
</div>
</div>
</div>

<div class="row">
<label for="sampling_place_id" class="col-md-2 control-label">Lieu de prélèvement :</label>
<div class="col-md-4">
<select id="sampling_place_id" name="sampling_place_id" class="form-control combobox">
<option value="" {if $sampleSearch.sampling_place_id == ""}selected{/if}>Sélectionnez...</option>
{section name=lst loop=$samplingPlace}
<option value="{$samplingPlace[lst].sampling_place_id}" {if $samplingPlace[lst].sampling_place_id == $sampleSearch.sampling_place_id}selected{/if}>
{$samplingPlace[lst].sampling_place_name}
</option>
{/section}
</select>
</div>

<label for="object_status_id" class="col-md-2 control-label">Statut :</label>
<div class="col-md-4">
<select id="object_status_id" name="object_status_id" class="form-control">
<option value="" {if $sampleSearch.object_status_id == ""}selected{/if}>Sélectionnez...</option>
{section name=lst loop=$objectStatus}
<option value="{$objectStatus[lst].object_status_id}" {if $objectStatus[lst].object_status_id == $sampleSearch.object_status_id}selected{/if}>
{$objectStatus[lst].object_status_name}
</option>
{/section}
</select>
</div>
</div>
 
<div class="row">
<div class="form-group">
<!--
<label for="limit" class="col-md-2 control-label">Nbre limite à afficher :</label>

<div class="col-md-2">

<input type="number" id="limit" name="limit" value="{$sampleSearch.limit}" class="form-control">

</div>
 -->
 <label for="metadata_field" class="col-md-2 control-label">Recherche par date :</label>
 <div class="col-md-2">
 <select class="form-control" id="select_date" name="select_date">
 <option value="" {if $sampleSearch.select_date == ""}selected{/if}>Sélectionnez...</option>
  <option value="cd" {if $sampleSearch.select_date == "cd"}selected{/if}>Date de création dans la base</option>
  <option value="sd" {if $sampleSearch.select_date == "sd"}selected{/if}>Date d'échantillonnage</option>
  <option value="ed" {if $sampleSearch.select_date == "ed"}selected{/if}>Date d'expiration</option>
 </select>
 </div>
 <div class="col-md-1">du :</div>
<div class="col-md-2">
<input class="datepicker form-control" id="date_from" name="date_from" value="{$sampleSearch.date_from}">
</div> 
<div class="col-md-1">au :</div>
<div class="col-md-2">
<input class="datepicker form-control" id="date_to" name="date_to" value="{$sampleSearch.date_to}">
</div>

<div class="col-md-2">
<input type="submit" class="btn btn-success" value="{$LANG['message'][21]}">
</div>
</div>
</div>
<div class="row">
<div class="form-group">
<!-- 
<label for="metadata_field" class="col-md-2 control-label">Métadonnées :</label>
 -->
 <div class="col-md-2">
 <select class="form-control" id="metadata_field" name="metadata_field[]">
 </select>
 </div>
 <div class="col-md-2">
 <input class="col-md-2 form-control" id="metadata_value" name="metadata_value[]" value="{$sampleSearch.metadata_value.0}" title="Libellé à rechercher dans le champ de métadonnées sélectionné. Si recherche en milieu de texte, préfixez par %">
 </div>
 <!--  metadonnees supplementaires -->
 <div id="metadatarow1">
 <div class="col-md-2">
 <select class="form-control"  id="metadata_field1" name="metadata_field[]">
 </select>
 </div>
 <div class="col-md-2">
 <input class="col-md-2 form-control" id="metadata_value_1" name="metadata_value[]" value="{$sampleSearch.metadata_value.1}" title="Libellé à rechercher dans le champ de métadonnées sélectionné. Si recherche en milieu de texte, préfixez par %">
 </div>
 </div>
  <div id="metadatarow2">
 <div class="col-md-2">
 <select class="form-control"  id="metadata_field2" name="metadata_field[]">
  </select>
 </div>
 <div class="col-md-2">
 <input class="col-md-2 form-control" id="metadata_value_2" name="metadata_value[]" value="{$sampleSearch.metadata_value.2}" title="Libellé à rechercher dans le champ de métadonnées sélectionné. Si recherche en milieu de texte, préfixez par %">
 </div>
 </div>
 </div>
</form>
</div>