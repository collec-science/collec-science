<script>
	var appli_code ="{$APPLI_code}";
	$(document).ready(function() {
		var type_init = "{if $containerSearch.container_type_id > 0}{$containerSearch.container_type_id}{else}0{/if}";
		function searchType() {
			var family = $("#container_family_id").val();
			var url = "index.php";
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
                            $("#uidsearch").val(obj.uid);
                            $("#name").val("");
                        } else {
                            $("#name").val(obj.db + ":"+ obj.uid);
                        }
                    }
			 } catch (error) {}
		 	}
			if ($("#container_family_id").val() > 0) ok = true;
			if ($("#uidsearch").val() > 0) ok = true;
			if ($("#uid_min").val() > 0) ok = true;
			if ($("#uid_max").val() > 0) ok = true;
			if ($("#container_type_id").val() > 0) ok = true;
			if ($("#object_status_id").val() > 1) ok = true;
      if ($("#event_type_id").val() > 1) ok = true;
			if ($("#trashed").val() == 1) ok = true;
			if ($("#referent_id").val() > 0) ok = true;
			if ($("#movement_reason_id").val() > 0) ok = true;
			if (ok == false) event.preventDefault();
		});

		searchType();
		$("#razid").on ("click keyup", function () {
			$("#object_status_id").prop("selectedIndex", 1).change();
			$("#uidsearch").val("");
			$("#uid_min").val("0");
			$("#uid_max").val("0");
			$("#container_family_id").prop("selectedIndex", 0).change();
			$("#container_type_id").prop("selectedIndex", 0).change();
			$("#select_date").prop("selectedIndex", 0).change();
			$("#referent_id").prop("selectedIndex", 0).change();
      $("#event_type_id").prop("selectedIndex",0).change();
			$("#movement_reason_id").prop("selectedIndex", 0).change();
			var now = new Date();
			$("#date_from").datepicker("setDate", new Date(now.getFullYear() -1, now.getMonth(), now.getDay()));
			$("#date_to").datepicker("setDate", now );
			$("#name").val("");
			$("#trashed").val("0");
			$("#uidsearch").focus();
		});
		/* Management of tabs */
		var myStorage = window.localStorage;
		var activeTab = "";
        try {
        activeTab = myStorage.getItem("containerSearchTab");
        } catch (Exception) {
        }
		try {
			if (activeTab.length > 0) {
				$("#"+activeTab).tab('show');
			}
		} catch (Exception) { }
		/*$('.nav-tabs > li > a').hover(function() {
			$(this).tab('show');
 		});*/
		 $('.searchTab').on('shown.bs.tab', function () {
			myStorage.setItem("containerSearchTab", $(this).attr("id"));
		});
	});

</script>
<div class="row col-lg-10 col-md-12">
	<form class="" id="container_search" action="index.php" method="GET">
		<input id="moduleBase" type="hidden" name="moduleBase" value="{if strlen($moduleBase)>0}{$moduleBase}{else}container{/if}">
		<input id="action" type="hidden" name="action" value="{if strlen($action)>0}{$action}{else}List{/if}">
		<input id="isSearch" type="hidden" name="isSearch" value="1">
    <!-- Tab box -->
    <ul class="nav nav-tabs" id="searchTab" role="tablist" >
      <li class="nav-item active">
          <a class="nav-link searchTab" id="tabsearch-uid" data-toggle="tab"  role="tab" aria-controls="navsearch-uid" aria-selected="true" href="#navsearch-uid">
              {t}UID/identifiant/type{/t}
          </a>
      </li>
      <li class="nav-item">
        <a class="nav-link searchTab" id="tabsearch-others" href="#navsearch-others"  data-toggle="tab" role="tab" aria-controls="navsearch-others" aria-selected="false">
            {t}Autres informations{/t}
        </a>
    	</li>
  	</ul>
  <div class="tab-content col-lg-12 form-horizontal" id="search-tabContent">
      <div class="tab-pane active in" id="navsearch-uid" role="tabpanel" aria-labelledby="tabsearch-uid">
				<div class="row">
						<div class="form-group">
							<label for="uidsearch" class= "col-sm-2 control-label">{t}UID :{/t}</label>
							<div class="col-sm-1">
								<input id="uidsearch" name="uidsearch" class="form-control nombre" value="{$containerSearch.uidsearch}">
							</div>

							<label for="name" class= "col-sm-2 control-label">
								{t}Identifiant ou UUID :{/t}
								<img src="display/images/qrcode.png" height="25">
							</label>
							<div class="col-sm-3">
									<input id="name" type="text" class="form-control" name="name" value="{$containerSearch.name}" title="{t}identifiant principal, identifiants secondaires (p. e. : cab:15), UUID (p. e. : e1b1bdd8-d1e7-4f07-8e96-0d71e7aada2b){/t}">
							</div>
					</div>
				</div>
				<div class="row">
						<div class="form-group">
								<label for="uid_min" class="col-sm-2 control-label">{t}UID entre :{/t}</label>
								<div class="col-sm-3">
										<input id="uid_min" name="uid_min" class="nombre form-control" value="{$containerSearch.uid_min}">
								</div>
								<div class="col-sm-3">
										<input id="uid_max" name="uid_max" class="nombre form-control" value="{$containerSearch.uid_max}">
								</div>
						</div>
				</div>
				<div class="row">
					<div class="form-group">
						<label for="container_family_id" class="col-sm-2 control-label lexical" data-lexical="container_family">{t}Famille :{/t}</label>
						<div class="col-sm-4">
							<select id="container_family_id" name="container_family_id" class="form-control">
								<option value="" {if $containerSearch.container_family_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
								{section name=lst loop=$containerFamily}
									<option value="{$containerFamily[lst].container_family_id}" {if $containerFamily[lst].container_family_id == $containerSearch.container_family_id}selected{/if}>
										{$containerFamily[lst].container_family_name}
									</option>
								{/section}
							</select>
						</div>
						<label for="container_type_id" class="col-sm-2 control-label lexical" data-lexical="container_type">{t}Type :{/t}</label>
						<div class="col-sm-3">
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
				</div>
				<div class="row">
					<div class="form-group">
						<label for="object_status_id" class="col-sm-2 control-label lexical" data-lexical="status">{t}Statut :{/t}</label>
						<div class="col-sm-2">
							<select id="object_status_id" name="object_status_id" class="form-control">
								<option value="" {if $containerSearch.object_status_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
								{section name=lst loop=$objectStatus}
									<option value="{$objectStatus[lst].object_status_id}" {if $objectStatus[lst].object_status_id == $containerSearch.object_status_id}selected{/if}>
									{$objectStatus[lst].object_status_name}
									</option>
								{/section}
							</select>
					</div>
					<label for="trashed" class="col-sm-4 control-label lexical" data-lexical="trashed" title="{t}Échantillons mis à la corbeille{/t}">{t}En attente de suppression :{/t}</label>
					<div class="col-sm-2">
							<select id="trashed" name="trashed" class="form-control">
									<option value="" {if $containerSearch.trashed == ""}selected{/if}>{t}Tous{/t}</option>
									<option value="1" {if $containerSearch.trashed == "1"}selected{/if}>{t}Oui{/t}</option>
									<option value="0" {if $containerSearch.trashed == "0"}selected{/if}>{t}Non{/t}</option>
							</select>
						</div>
					</div>
			</div>
      </div>
			<div class="tab-pane fade" id="navsearch-others" role="tabpanel" aria-labelledby="tabsearch-others">
				<div class="row">
					<div class="form-group">
						<label for="referent_id" class="col-sm-3 control-label lexical" data-lexical="referent">{t}Référent :{/t}</label>
						<div class="col-sm-6">
							<select id="referent_id" name="referent_id" class="form-control">
								<option value="" {if $containerSearch.referent_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
								{foreach $referents as $referent}
									<option value="{$referent.referent_id}" {if $containerSearch.referent_id == $referent.referent_id}selected{/if}>
									{$referent.referent_firstname} {$referent.referent_name}
									</option>
							{/foreach}
							</select>
						</div>
					</div>
				</div>
				<div class="row">
				<div class="form-group">
					<label for="event_type_id" class="col-sm-3 control-label">{t}Type d'événement :{/t}</label>
					<div class="col-sm-6">
						<select id="event_type_id" class="form-control" name="event_type_id">
							<option value="" {if $containerSearch.event_type_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
							{foreach $eventType as $et}
								<option value="{$et.event_type_id}" {if $containerSearch.event_type_id == $et.event_type_id}selected{/if}>{$et.event_type_name}</option>
							{/foreach}
						</select>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="form-group">
					<label for="movement_reason_id" class="col-sm-3 control-label">{t}Motif de déstockage :{/t}</label>
					<div class="col-sm-6">
						<select id="movement_reason_id" name="movement_reason_id" class="form-control">
							<option value="" {if $containerSearch.movement_reason_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
							{section name=lst loop=$movementReason}
								<option value="{$movementReason[lst].movement_reason_id}" {if $movementReason[lst].movement_reason_id == $containerSearch.movement_reason_id}selected{/if}>
									{$movementReason[lst].movement_reason_name}
								</option>
							{/section}
						</select>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="form-group">
					<label for="select_date" class="col-sm-3 control-label">{t}Recherche par date :{/t}</label>
					<div class="col-sm-6">
						<select class="form-control" id="select_date" name="select_date">
							<option value="" {if $containerSearch.select_date == ""}selected{/if}>{t}Choisissez...{/t}</option>
							<option value="ch" {if $containerSearch.select_date == "ch"}selected{/if}>{t}Date technique de dernier changement{/t}</option>
						</select>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="form-group">
					<label for="date_from" class="col-sm-1 col-sm-offset-3 control-label">{t}du :{/t}</label>
					<div class="col-sm-2">
							<input class="datepicker form-control" id="date_from" name="date_from" value="{$containerSearch.date_from}">
					</div>
					<label for="date_to" class="col-sm-1 control-label">{t}au :{/t}</label>
					<div class="col-sm-2">
							<input class="datepicker form-control" id="date_to" name="date_to" value="{$containerSearch.date_to}">
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-offset-3 col-sm-6 center">
				<input type="submit" class="btn btn-success" value="{t}Rechercher{/t}">
				<button type="button" id="razid" class="btn btn-warning">{t}RAZ{/t}</button>
			</div>
	</div>
  </form>
</div>
</div>
