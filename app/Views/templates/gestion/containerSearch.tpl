<script>
	var appli_code ="{$APPLI_code}";
	$(document).ready(function() {
		var type_init = {if $containerSearch.container_type_id > 0}{$containerSearch.container_type_id}{else}0{/if};
		function searchType() {
			var family = $("#container_family_id").val();
			var url = "";
			$.getJSON ( url, { "module":"containerTypeGetFromFamily", "container_family_id":family } , function( data ) {
				if (data != null) {
					options = '<option value="">{t}Choisissez...{/t}</option>';
					for (var i = 0; i < data.length; i++) {
							options += '<option value="' + data[i].container_type_id + '"';
							if (data[i].container_type_id == type_init) {
								options += ' selected ';
							}
							options += '>' + data[i].container_type_name + '</option>';
						};
					$("#container_type_id").html(options);
				}
			} ) ;
		}
		$("#container_family_id").change(function (){
		searchType();
		});
		/*
		* Verification que des criteres de selection soient saisis
		*/
		$("#container_search").submit (function ( event) {
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
			if ($("#container_family_id").val() > 0) ok = true;
			if ($("#uid_min").val() > 0) ok = true;
			if ($("#uid_max").val() > 0) ok = true;
			if ($("#container_type_id").val() > 0) ok = true;
			if ($("#object_status_id").val() > 1) ok = true;
			if ($("#trashed").val() == 1) ok = true;
			if ($("#referent_id").val() > 0) ok = true;
			if (ok == false) event.preventDefault();
		});

		searchType();
		$("#razid").on ("click keyup", function () {
			$("#object_status_id").prop("selectedIndex", 1).change();
			$("#uid_min").val("0");
			$("#uid_max").val("0");
			$("#container_family_id").prop("selectedIndex", 0).change();
			$("#container_type_id").prop("selectedIndex", 0).change();
			$("#select_date").prop("selectedIndex", 0).change();
			$("#referent_id").prop("selectedIndex", 0).change();
			var now = new Date();
			$("#date_from").datepicker("setDate", new Date(now.getFullYear() -1, now.getMonth(), now.getDay()));
			$("#date_to").datepicker("setDate", now );
			$("#name").val("");
			$("#trashed").val("0");
			$("#name").focus();
		});
	});

</script>

<div class="row">
	<form class="form-horizontal " id="container_search" action="{if strlen($moduleBase)>0}{$moduleBase}{else}container{/if}{if strlen($action)>0}{$action}{else}List{/if}" method="GET">
		<input id="moduleBase" type="hidden" name="moduleBase" value="{if strlen($moduleBase)>0}{$moduleBase}{else}container{/if}">
		<input id="isSearch" type="hidden" name="isSearch" value="1">
		<div class="form-group">
			<label for="name" class="col-md-2 control-label">{t}UID ou identifiant :{/t}</label>
			<div class="col-md-4">
			<input id="name" type="text" class="form-control" name="name" value="{$containerSearch.name}" title="{t}uid, identifiant principal, identifiants secondaires (p. e. : cab:15 possible){/t}" >
			</div>
			<label for="object_status_id" class="col-md-1 control-label lexical" data-lexical="status">{t}Statut :{/t}</label>
			<div class="col-md-3">
				<select id="object_status_id" name="object_status_id" class="form-control">
					<option value="" {if $containerSearch.object_status_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
					{section name=lst loop=$objectStatus}
						<option value="{$objectStatus[lst].object_status_id}" {if $objectStatus[lst].object_status_id == $containerSearch.object_status_id}selected{/if}>
							{$objectStatus[lst].object_status_name}
						</option>
					{/section}
				</select>
			</div>
			<label for="trashed" class="col-md-1 control-label lexical" data-lexical="trashed" title="{t}Contenants en attente de suppression (mis à la corbeille){/t}">{t}Corbeille :{/t}</label>
			<div class="col-md-1">
				<select id="trashed" name="trashed" class="form-control">
					<option value="" {if $containerSearch.trashed == ""}selected{/if}>{t}Tous{/t}</option>
					<option value="1" {if $containerSearch.trashed == "1"}selected{/if}>{t}Oui{/t}</option>
					<option value="0" {if $containerSearch.trashed == "0"}selected{/if}>{t}Non{/t}</option>
				</select>
			</div>
		</div>
		<div class="form-group">
			<label for="select_date" class="col-md-2 control-label">{t}Recherche par date :{/t}</label>
			<div class="col-md-2">
				<select class="form-control" id="select_date" name="select_date">
				<option value="" {if $containerSearch.select_date == ""}selected{/if}>{t}Choisissez...{/t}</option>
				<option value="ch" {if $containerSearch.select_date == "ch"}selected{/if}>{t}Date technique de dernier changement{/t}</option>
				</select>
			</div>
			<label for="date_from" class="col-md-1 control-label">{t}du :{/t}</label>
			<div class="col-md-3">
				<input class="datepicker form-control" id="date_from" name="date_from" value="{$containerSearch.date_from}">
			</div>
			<label for="date_to" class="col-md-1 control-label">{t}au :{/t}</label>
			<div class="col-md-3">
				<input class="datepicker form-control" id="date_to" name="date_to" value="{$containerSearch.date_to}">
			</div>
		</div>
		<div class="form-group">
			<label for="uid_min" class="col-md-2 control-label">{t}UID entre :{/t}</label>
			<div class="col-md-2">
				<input id="uid_min" name="uid_min" class="nombre form-control" value="{$containerSearch.uid_min}">
			</div>
			<div class="col-md-2">
				<input id="uid_max" name="uid_max" class="nombre form-control" value="{$containerSearch.uid_max}">
			</div>
			<label for="container_family_id" class="col-md-2 control-label lexical" data-lexical="container_family">{t}Famille :{/t}</label>
			<div class="col-md-4">
				<select id="container_family_id" name="container_family_id" class="form-control">
					<option value="" {if $containerSearch.container_family_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
					{section name=lst loop=$containerFamily}
						<option value="{$containerFamily[lst].container_family_id}" {if $containerFamily[lst].container_family_id == $containerSearch.container_family_id}selected{/if}>
							{$containerFamily[lst].container_family_name}
						</option>
					{/section}
				</select>
			</div>
		</div>
		<div class="form-group">
		<!--
		<label for="limit" class="col-md-2 control-label">Nbre limite à afficher :</label>
		<div class="col-md-2">
		<input type="number" id="limit" name="limit" value="{$containerSearch.limit}" class="form-control">
		</div>
		-->
			<label for="referent_id" class="col-md-2 control-label lexical" data-lexical="referent">{t}Référent :{/t}</label>
			<div class="col-md-2">
				<select id="referent_id" name="referent_id" class="form-control">
					<option value="" {if $containerSearch.referent_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
					{foreach $referents as $referent}
						<option value="{$referent.referent_id}" {if $referent.referent_id == $containerSearch.referent_id}selected{/if}>{$referent.referent_name}</option>
					{/foreach}
				</select>
			</div>
			<div class="col-md-3 center">
				<input type="submit" class="btn btn-success" value="{t}Rechercher{/t}">

				<button type="button" id="razid" class="btn btn-warning">{t}RAZ{/t}</button>
			</div>
			<label for="container_type_id" class="col-md-1 control-label lexical" data-lexical="container_type">{t}Type :{/t}</label>
			<div class="col-md-4">
				<select id="container_type_id" name="container_type_id" class="form-control">
					<option value="" {if $containerSearch.container_type_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
					{section name=lst loop=$container_type}
						<option value="{$container_type[lst].container_type_id}" {if $container_type[lst].container_type_id == $containerSearch.container_type_id}selected{/if} title="{$container_type[lst].container_type_description}">
							{$container_type[lst].container_type_name}
						</option>
					{/section}
				</select>
			</div>
		</div>
	{$csrf}</form>
</div>
