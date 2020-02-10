! Obsolete !
<script>
var sampling_place_init = "{$sampleSearch.sampling_place_id}";
var appli_code ="{$APPLI_code}";
$(document).ready(function () {
	var metadataFieldInitial = [];
	{foreach $sampleSearch.metadata_field as $val}
		metadataFieldInitial.push ( "{$val}" );
	{/foreach}

	/*
	 * Verification que des criteres de selection soient saisis
	 */
	 $("#sample_search").submit (function ( event) {
		 var ok = false;
		 if ($("#name").val().length > 0) {
			 ok = true;
			 try {
				obj = JSON.parse($("#name").val());
				if (obj.db.length > 0) {
					if (obj.db == appli_code) {
						$("#name").val(obj.uid);
					} else {
						$("#name").val(obj.db + ":"+ obj.uid);
					}
				}
			 } catch (error) {}
		 }
		 if ($("#collection_id").val() > 0) ok = true;
		 if ($("#uid_min").val() > 0) ok = true;
		 if ($("#uid_max").val() > 0) ok = true;
		 if ($("#sample_type_id").val() > 0) ok = true;
		 if ($("#sampling_place_id").val() > 0 ) ok = true ;
		 if ($("#object_status_id").val() > 1) ok = true;
		 if ($("#select_date").val().length > 0) ok = true;
		 if ($("#referent_id").val() > 0) ok = true;
		 if ($("#movement_reason_id").val() > 0) ok = true;
		 if ($("#trashed").val() == 1) ok = true;
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
		 $("#metadatarow").hide();
		 $("#metadatarow1").hide();
		 $("#metadatarow2").hide();

		 if (sampleTypeId.length > 0) {
    	    $.ajax( {
    	   		url: "index.php",
    	    	data: { "module": "sampleTypeMetadata", "sample_type_id": sampleTypeId }
    	    })
    	    .done (function (value) {
    	    	if (value.length > 0) {
							$("#metadatarow").show();
    	    		var selected = "";
    	    		var option = '<option value="">{t}Métadonnée :{/t}</option>';
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

 	function getSamplingPlace () {
		var colid = $("#collection_id").val();
		var url = "index.php";
		var data = { "module":"samplingPlaceGetFromCollection", "collection_id": colid };
		$.ajax ( { url:url, data: data})
		.done (function( d ) {
				if (d ) {
				d = JSON.parse(d);
				options = '<option value=""></option>';
				 for (var i = 0; i < d.length; i++) {
					 var libelle = "";
					 if (d[i].sampling_place_code) {
				        	libelle = d[i].sampling_place_code + " - ";
				        }
				        libelle += d[i].sampling_place_name;
				        options += '<option value="'+d[i].sampling_place_id + '"';
				        if (d[i].sampling_place_id == sampling_place_init ) {
				        	options += ' selected="selected" ';
				        	$("#sampling_place_id").next().find(".custom-combobox-input").val(libelle);
				        }
				        options += '>';
				        options += libelle;

				        options += '</option>';
				      };
				$("#sampling_place_id").html(options);
				}
			});
	}

 	$("#collection_id").change ( function () {
 		getSamplingPlace();
 	});
 	/*
 	 * Initialisation a l'ouverture de la page
 	 */
 	 getSamplingPlace();

	 /*
	  * Gestion des metadonnees
	  */
     $("#sample_type_id").change( function() {
    	 getMetadata();
     });
     $("#sample_type_id").combobox({
    	 select: function (event, ui) {
    		 $("#metadata_value").val("");
    		 $("#metadata_value_2").val("");
    		 $("#metadata_value_1").val("");
    		 getMetadata();
    	 }
     });
	 /*
	  * Declenchement de la recherche des metadonnees
	  * si sample_type_id est renseigne au demarrage de la page
	  */
	 $("#metadatarow").hide();
	 if ($("#sample_type_id").val() > 0 ) {
		 getMetadata();
	 }
	 if ($("#metadata_value").val().length == 0) {
     	$("#metadatarow1").hide();
	 }
	 if ($("#metadata_value_1").val().length == 0) {
     	$("#metadatarow2").hide();
	 }
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
 $("#razid").on ("click keyup", function () {
	$("#object_status_id").prop("selectedIndex", 1).change();
	$("#collection_id").prop("selectedIndex", 0).change();
	$("#referent_id").prop("selectedIndex", 0).change();
	$("#sample_type_id").combobox("select", "").change();
	$("#sampling_place_id").combobox("select", "").change();
	$("#movement_reason_id").prop("selectedIndex", 0).change();
	$("#select_date").prop("selectedIndex", 0).change();
	$("#uid_min").val("0");
	$("#uid_max").val("0");
	$("#metadatarow").hide();
	$("#metadata_value").val("");
	$("#metadata_value_1").val("");
	$("#metadata_value_2").val("");
	$("#trashed").val("0");
	var now = new Date();
	$("#date_from").datepicker("setDate", new Date(now.getFullYear() -1, now.getMonth(), now.getDay()));
	$("#date_to").datepicker("setDate", now );
	$("#name").val("");
	$("#name").focus();
 });
});
</script>

<form class="form-horizontal protoform col-md-12" id="sample_search" action="index.php" method="GET">
	<input id="moduleBase" type="hidden" name="moduleBase" value="{if strlen($moduleBase)>0}{$moduleBase}{else}sample{/if}">
	<input id="action" type="hidden" name="action" value="{if strlen($action)>0}{$action}{else}List{/if}">
	<input id="isSearch" type="hidden" name="isSearch" value="1">

	<div class="row">
		<div class="form-group">
			<label for="name" class="col-md-2 control-label">{t}UID ou identifiant :{/t}</label>
			<div class="col-md-3">
				<input id="name" type="text" class="form-control" name="name" value="{$sampleSearch.name}" title="{t}uid, identifiant principal, identifiants secondaires (p. e. : cab:15 possible){/t}">
			</div>
			<label for="collection_id" class="col-md-1 control-label">{t}Collection :{/t}</label>
			<div class="col-md-2">
				<select id="collection_id" name="collection_id" class="form-control">
				<option value="" {if $sampleSearch.collection_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
				{section name=lst loop=$collections}
				<option value="{$collections[lst].collection_id}" {if $collections[lst].collection_id == $sampleSearch.collection_id}selected{/if}>
				{$collections[lst].collection_name}
				</option>
				{/section}
				</select>
			</div>
			<label for="referent_id" class="col-md-1 control-label">{t}Référent :{/t}</label>
			<div class="col-md-2">
				<select id="referent_id" name="referent_id" class="form-control">
				<option value="" {if $sampleSearch.referent_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
				{foreach $referents as $referent}
				<option value="{$referent.referent_id}" {if $sampleSearch.referent_id == $referent.referent_id}selected{/if}>
				{$referent.referent_name}
				</option>
				{/foreach}
				</select>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="form-group">
			<label for="container_family_id" class="col-md-2 control-label">{t}UID entre :{/t}</label>
			<div class="col-md-2">
				<input id="uid_min" name="uid_min" class="nombre form-control" value="{$sampleSearch.uid_min}">
			</div>
			<div class="col-md-2">
				<input id="uid_max" name="uid_max" class="nombre form-control" value="{$sampleSearch.uid_max}">
			</div>

			<label for="sample_type_id" class="col-md-2 control-label">{t}Type :{/t}</label>
			<div class="col-md-4">
				<select id="sample_type_id" name="sample_type_id" class="form-control combobox">
				<option value="" {if $sampleSearch.sample_type_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
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
		<label for="sampling_place_id" class="col-md-2 control-label">{t}Lieu de prélèvement :{/t}</label>
		<div class="col-md-2">
			<select id="sampling_place_id" name="sampling_place_id" class="form-control combobox">
			<option value="" {if $sampleSearch.sampling_place_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
			{section name=lst loop=$samplingPlace}
			<option value="{$samplingPlace[lst].sampling_place_id}" {if $samplingPlace[lst].sampling_place_id == $sampleSearch.sampling_place_id}selected{/if}>
			{if strlen({$samplingPlace[lst].sampling_place_code}) > 0}
			{$samplingPlace[lst].sampling_place_code} -&nbsp;
			{/if}
			{$samplingPlace[lst].sampling_place_name}
			</option>
			{/section}
			</select>
		</div>
		<label for="movement_reason_id" class="col-md-2 control-label">{t}Motif de déstockage :{/t}</label>
		<div class="col-md-2">
			<select id="movement_reason_id" name="movement_reason_id" class="form-control">
				<option value="" {if $sampleSearch.movement_reason_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
				{section name=lst loop=$movementReason}
					<option value="{$movementReason[lst].movement_reason_id}" {if $movementReason[lst].movement_reason_id == $sampleSearch.movement_reason_id}selected{/if}>
						{$movementReason[lst].movement_reason_name}
					</option>
				{/section}
			</select>
		</div>
		<label for="object_status_id" class="col-md-1 control-label">{t}Statut :{/t}</label>
		<div class="col-md-1">
			<select id="object_status_id" name="object_status_id" class="form-control">
			<option value="" {if $sampleSearch.object_status_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
			{section name=lst loop=$objectStatus}
			<option value="{$objectStatus[lst].object_status_id}" {if $objectStatus[lst].object_status_id == $sampleSearch.object_status_id}selected{/if}>
			{$objectStatus[lst].object_status_name}
			</option>
			{/section}
			</select>
		</div>
		<label for="trashed" class="col-md-1 control-label" title="{t}Échantillons mis à la corbeille ?{/t}">{t}Corbeille ?{/t}</label>
		<div class="col-md-1">
			<select id="trashed" name="trashed" class="form-control">
				<option value="" {if $sampleSearch.trashed == ""}selected{/if}>{t}Tous{/t}</option>
				<option value="1" {if $sampleSearch.trashed == "1"}selected{/if}>{t}Oui{/t}</option>
				<option value="0" {if $sampleSearch.trashed == "0"}selected{/if}>{t}Non{/t}</option>
			</select>
		</div>
	</div>
	<div class="row">
		<div class="form-group">
			<label for="select_date" class="col-md-2 control-label">{t}Recherche par date :{/t}</label>
			<div class="col-md-2">
				<select class="form-control" id="select_date" name="select_date">
				<option value="" {if $sampleSearch.select_date == ""}selected{/if}>{t}Choisissez...{/t}</option>
				<option value="cd" {if $sampleSearch.select_date == "cd"}selected{/if}>{t}Date de création dans la base{/t}</option>
				<option value="sd" {if $sampleSearch.select_date == "sd"}selected{/if}>{t}Date d'échantillonnage{/t}</option>
				<option value="ed" {if $sampleSearch.select_date == "ed"}selected{/if}>{t}Date d'expiration{/t}</option>
				<option value="ch" {if $sampleSearch.select_date == "ch"}selected{/if}>{t}Date technique de dernier changement{/t}</option>
				</select>
			</div>
			<div class="col-md-4">
			<label for="date_from" class="col-md-2 control-label">{t}du :{/t}</label>
			<div class="col-md-4">
				<input class="datepicker form-control" id="date_from" name="date_from" value="{$sampleSearch.date_from}">
			</div>
			<label for="date_to" class="col-md-2 control-label">{t}au :{/t}</label>
			<div class="col-md-4">
				<input class="datepicker form-control" id="date_to" name="date_to" value="{$sampleSearch.date_to}">
			</div>
			</div>
			<div class="col-md-2">
				<input type="submit" class="btn btn-success" value="{t}Rechercher{/t}">
			</div>
			<div class="col-md-1">
				<button type="button" id="razid" class="btn btn-warning">{t}RAZ{/t}</button>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="form-group">
			<!--
			<label for="metadata_field" class="col-md-2 control-label">Métadonnées :</label>
			-->
			<div id="metadatarow" hidden>
				<div class="col-md-2">
					<select class="form-control" id="metadata_field" name="metadata_field[]">
					<option value="" {if $sampleSearch.metadata_field.0 == ""}selected{/if}>{t}Métadonnée :{/t}</option>
					{foreach $metadatas as $value}
					<option value="{$value.fieldname}" {if $sampleSearch.metadata_field.0 == $value.fieldname}selected{/if}>
					{$value.fieldname}
					</option>
					{/foreach}
					</select>
				</div>
				<div class="col-md-2">
					<input class="col-md-2 form-control" id="metadata_value" name="metadata_value[]" value="{$sampleSearch.metadata_value.0}" title="{t}Libellé à rechercher dans le champ de métadonnées sélectionné. Si recherche en milieu de texte, préfixez par %{/t}">
				</div>
			</div>
			<!--  metadonnees supplementaires -->
			<div id="metadatarow1" hidden>
				<div class="col-md-2">
					<select class="form-control"  id="metadata_field1" name="metadata_field[]">
					<option value="" {if $sampleSearch.metadata_field.1 == ""}selected{/if}>{t}Métadonnée :{/t}</option>
					{foreach $metadatas as $value}
					<option value="{$value.fieldname}" {if $sampleSearch.metadata_field.1 == $value.fieldname}selected{/if}>
					{$value.fieldname}
					</option>
					{/foreach}
					</select>
				</div>
				<div class="col-md-2">
					<input class="col-md-2 form-control" id="metadata_value_1" name="metadata_value[]" value="{$sampleSearch.metadata_value.1}" title="{t}Libellé à rechercher dans le champ de métadonnées sélectionné. Si recherche en milieu de texte, préfixez par %{/t}">
				</div>
			</div>
			<div id="metadatarow2" hidden>
				<div class="col-md-2">
					<select class="form-control"  id="metadata_field2" name="metadata_field[]">
					<option value="" {if $sampleSearch.metadata_field.2 == ""}selected{/if}>{t}Métadonnée :{/t}</option>
					{foreach $metadatas as $value}
					<option value="{$value.fieldname}" {if $sampleSearch.metadata_field.2 == $value.fieldname}selected{/if}>
					{$value.fieldname}
					</option>
					{/foreach}
					</select>
				</div>
				<div class="col-md-2">
					<input class="col-md-2 form-control" id="metadata_value_2" name="metadata_value[]" value="{$sampleSearch.metadata_value.2}" title="{t}Libellé à rechercher dans le champ de métadonnées sélectionné. Si recherche en milieu de texte, préfixez par % (cela peut ralentir la requête){/t}">
				</div>
			</div>
		</div>
	</div>
</form>
