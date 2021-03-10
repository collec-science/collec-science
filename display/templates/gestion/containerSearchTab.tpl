<script>
	var appli_code ="{$APPLI_code}";
	$(document).ready(function() {
		var type_init = {if $containerSearch.container_type_id > 0}{$containerSearch.container_type_id}{else}0{/if};
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
      if ($("#event_type_id").val() > 1) ok = true;
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
      $("#event_type_id").prop("selectedIndex",0).change();
			var now = new Date();
			$("#date_from").datepicker("setDate", new Date(now.getFullYear() -1, now.getMonth(), now.getDay()));
			$("#date_to").datepicker("setDate", now );
			$("#name").val("");
			$("#trashed").val("0");
			$("#name").focus();
		});
	});

</script>
<div class="row col-lg-10 col-md-12">
	<form class="form-horizontal protoform" id="container_search" action="index.php" method="GET">
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
        <a class="nav-link searchTab" id="tabsearch-divers" href="#navsearch-others"  data-toggle="tab" role="tab" aria-controls="navsearch-others" aria-selected="false">
            {t}Autres informations{/t}
        </a>
    </li>

  </ul>
  <div class="tab-content col-lg-12 form-horizontal" id="search-tabContent">
      <div class="tab-pane active in" id="navsearch-uid" role="tabpanel" aria-labelledby="tabsearch-uid">
          <div class="row">
              <div class="form-group">
                  <label for="name" class= "col-sm-3 control-label">{t}UID ou identifiant :{/t}</label>
                  <div class="col-sm-6">
                      <input id="name" type="text" class="form-control" name="name" value="{$sampleSearch.name}" title="{t}uid, identifiant principal, identifiants secondaires (p. e. : cab:15 possible){/t}">
                  </div>
              </div>
          </div>
          <div class="row">
              <div class="form-group">
                  <label for="uid_min" class="col-sm-3 control-label">{t}UID entre :{/t}</label>
                  <div class="col-sm-3">
                      <input id="uid_min" name="uid_min" class="nombre form-control" value="{$sampleSearch.uid_min}">
                  </div>
                  <div class="col-sm-3">
                      <input id="uid_max" name="uid_max" class="nombre form-control" value="{$sampleSearch.uid_max}">
                  </div>
              </div>
          </div>


        </div>


  </form>
</div>
