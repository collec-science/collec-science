<script>
	var appli_code ="{$APPLI_code}";
	$(document).ready(function() {
		function sleep(milliseconds) {
			var start = new Date().getTime();
			for (var i = 0; i < 1e7; i++) {
				if ((new Date().getTime() - start) > milliseconds){
					break;
				}
			}
		}
		/* select the current tab */
		var activeTab = "{$activeTab}";
    	if (activeTab.length > 0) {
			//console.log(activeTab);
			$("#"+activeTab).tab('show');
    	}
		$("#referent_name").click(function() { 
			var referentName = $(this).text();
			if (referentName.length > 0) {
			$.ajax( { 
				url: "index.php",
				data: { "module": "referentGetFromName", "referent_name": referentName }
			})
			.done (function (value) {
				value = JSON.parse(value);
				var newval = value.referent_name + "<br>" + value.referent_email + "<br>" +
						value.referent_phone + "<br>" + value.address_name + "<br>"
						+ value.address_line2 + "<br>" + value.address_line3 + "<br>"
						+ value.address_city + "<br>" + value.address_country;
						$("#referent_name").html (newval);
					;
			});
			}
		});
		$("#open").submit (function ( event) { 
			/**
			* Recherche si un container existe
			*/
			var form = $(this);
			var url = "index.php";
			var uid = $("#search").val();
			if ($("#search").val().length > 0) {
			 try {
				obj = JSON.parse($("#search").val());
				if (obj.db.length > 0) {
					if (obj.db == appli_code) {
						uid = obj.uid;
						$("#search").val(uid);
					}
				}
			 } catch (error) {
			 }		 	 
			 // search for db:uid
			 var tab = uid.toString().split(":");
			if (tab.length == 2) {
				if (tab[0] == appli_code) {
					uid = tab[1];
					$("#search").val(uid);
				}
			}
			}
			$("#spinner").show();
			var is_container = 1;
			event.preventDefault();
			$.ajax ( { 
				url:url, 
			method:"GET",
			//async: "false",
			//cache: "false", 
			data : { module:"objectGetDetail", uid:uid, is_container:is_container }, 
			success : function ( djs ) {
				try {
					var data = JSON.parse(djs);
					console.log(data);
					if ( data.length > 0 ) {
						sleep(1000);
						form.get(0).submit();
					} else {
						$("#search").val("");
						$("#spinner").hide();
					}
				} catch (error) {
					$("#search").val("");
					$("#spinner").hide();
				}
				}
			} );
		});
	});
</script>

<div class="row">
	<div class="col-md-8">
		<h2>{t}Détail du contenant{/t} <i>{$data.uid} {$data.identifier}</i></h2>
	</div>
	<div class="col-md-4">
		<form id="open" action="index.php" action="index.php" method="GET">
			<input id="moduleBase" type="hidden" name="moduleBase" value="container">
			<input id="action" type="hidden" name="action" value="Display">
			<div class="form-group">
				<div class="col-md-5">
					<input id="search" class="form-control" placeholder="uid" name="uid" required autofocus>
				</div>
				<div class="col-md-1">
					<img id="spinner" src="display/images/spinner.gif" style="display:none" height="25">
				</div>
				<input type="submit" id="searchExec" class="btn btn-warning col-md-6" value="{t}Ouvrir{/t}">
			</div>
		</form>
	</div>
</div>

<div class="row">
	<div class="col-md-12">
		<a href="index.php?module={$moduleListe}">
			<img src="display/images/list.png" height="25">
			{t}Retour à la liste{/t}
		</a>
		{if $droits.gestion == 1}
			&nbsp;
			<a href="index.php?module=containerChange&uid=0">
				<img src="display/images/new.png" height="25">
				{t}Nouveau contenant{/t}
			</a>
			&nbsp;
			<a href="index.php?module=containerChange&uid={$data.uid}">
				<img src="display/images/edit.gif" height="25">
				{t}Modifier{/t}
			</a>
			<!-- Entrée ou sortie -->
			&nbsp;
			<span id="input">
				<a href="index.php?module=movementcontainerInput&movement_id=0&uid={$data.uid}" id="input" title="Entrer ou déplacer le contenant dans un autre contenant">
					<img src="display/images/input.png" height="25">
					{t}Entrer ou déplacer...{/t}
				</a>
			</span>
			&nbsp;
			<span id="output">
				<a href="index.php?module=movementcontainerOutput&movement_id=0&uid={$data.uid}" id="output" title="Sortir le contenant du stock">
					<img src="display/images/output.png" height="25">
					{t}Sortir du stock...{/t}
				</a>
			</span>
		{/if}
		&nbsp;
		<a href="index.php?module=containerDisplay&uid={$data.uid}">
			<img src="display/images/refresh.png" title="Rafraîchir la page" height="15">
		</a>
	</div>
</div>
	<!-- Boite d'onglets -->
<div class="row">
	<ul class="nav nav-tabs" id="myTab" role="tablist" >
        <li class="nav-item active">
            <a class="nav-link" id="tab-detail" data-toggle="tab"  role="tab" aria-controls="nav-detail" aria-selected="true" href="#nav-detail">
				<img src="display/images/zoom.png" height="25">
				{t}Détails{/t}
			</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" id="tab-id" href="#nav-id"  data-toggle="tab" role="tab" aria-controls="nav-id" aria-selected="false">
				<img src="display/images/label.png" height="25">
				{t}Identifiants{/t}
			</a>
		</li>
		<li class="nav-item">
            <a class="nav-link" id="tab-event" href="#nav-event"  data-toggle="tab" role="tab" aria-controls="nav-event" aria-selected="false">
				<img src="display/images/events.png" height="25">
				{t}Événements/prêts{/t}
			</a>
		</li>
		<li class="nav-item">
            <a class="nav-link" id="tab-movement" href="#nav-movement"  data-toggle="tab" role="tab" aria-controls="nav-movement" aria-selected="false">
				<img src="display/images/movement.png" height="25">
				{t}Mouvements{/t}
			</a>
		</li>
		<li class="nav-item">
            <a class="nav-link" id="tab-container" href="#nav-container"  data-toggle="tab" role="tab" aria-controls="nav-container" aria-selected="false">
				<img src="display/images/box.png" height="25">
				{t}Contenants présents{/t}
			</a>
		</li>
		<li class="nav-item">
            <a class="nav-link" id="tab-sample" href="#nav-sample"  data-toggle="tab" role="tab" aria-controls="nav-sample" aria-selected="false">
				<img src="display/images/sample.png" height="25">
				{t}Échantillons présents{/t}
			</a>
		</li>
		{if $nblignes > 1 || $nbcolonnes > 1}
			<li class="nav-item">
				<a class="nav-link" id="tab-grid" href="#nav-grid"  data-toggle="tab" role="tab" aria-controls="nav-grid" aria-selected="false">
					<img src="display/images/grid.png" height="25">
					{t}Grille d'objets{/t}
				</a>
			</li>
		{/if}
		<li class="nav-item">
            <a class="nav-link" id="tab-document" href="#nav-document"  data-toggle="tab" role="tab" aria-controls="nav-document" aria-selected="false">
				<img src="display/images/camera.png" height="25">
				{t}Documents associés{/t}
			</a>
		</li>
		<li class="nav-item">
            <a class="nav-link" id="tab-booking" href="#nav-booking"  data-toggle="tab" role="tab" aria-controls="nav-booking" aria-selected="false">
				<img src="display/images/crossed-calendar.png" height="25">
				{t}Réservations{/t}
			</a>
		</li>
	</ul>
	<div class="tab-content" id="nav-tabContent">
		<div class="tab-pane active in" id="nav-detail" role="tabpanel" aria-labelledby="tab-detail">
			<div class="form-display col-md-6">
				<dl class="dl-horizontal">
					<dt>{t}UID et référence :{/t}</dt>
					<dd>{$data.uid} {$data.identifier}</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt>{t}Référent :{/t}</dt>
					<dd id="referent_name" title="{t}Cliquez pour la description complète{/t}">
						<a href="#">{$data.referent_name}</a>
					</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt>{t}Type :{/t}</dt>
					<dd>{$data.container_family_name} - {$data.container_type_name}</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt>{t}Produit utilisé :{/t}</dt>
					<dd>{$data.storage_product}</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt>{t}Conditions de stockage :{/t}</dt>
					<dd>{$data.storage_condition_name}</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt>{t}Classification CLP :{/t}</dt>
					<dd>{$data.clp_classification}</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt>{t}Statut :{/t}</dt>
					<dd>
						{$data.object_status_name}
						{if $data.object_status_id == 6}
						&nbsp;{t}le{/t}&nbsp;{$data.borrowing_date}
							&nbsp;{t}à{/t}&nbsp;
							<a href="index.php?module=borrowerDisplay&borrower_id={$data.borrower_id}">
								{$data.borrower_name}
							</a>
							
							<br>
							{t}Retour prévu le{/t}&nbsp;{$data.expected_return_date}
						{/if}
					</dd>
				</dl>
				{if strlen($data.wgs84_x) > 0 || strlen($data.wgs84_y) > 0}
					<dl class="dl-horizontal">
						<dt>{t}Latitude :{/t}</dt>
						<dd>{$data.wgs84_y}</dd>
					</dl>
					<dl class="dl-horizontal">
						<dt>{t}Longitude :{/t}</dt>
						<dd>{$data.wgs84_x}</dd>
					</dl>
				{/if}
				<dl class="dl-horizontal">
					<dt>{t}Emplacement :{/t}</dt>
					<dd>
						{section name=lst loop=$parents}
						<a href="index.php?module=containerDisplay&uid={$parents[lst].uid}">
							{$parents[lst].uid} {$parents[lst].identifier} {$container_type_name}
						</a>
						{if not $smarty.section.lst.last}
							<br>
						{/if}
					{/section}
					</dd>
				</dl>
			</div>				
			{if strlen($data.wgs84_x) > 0 && strlen($data.wgs84_y) > 0}
				<div class="col-md-6">
					{include file="gestion/objectMapDisplay.tpl"}
				</div>
			{/if}
		</div>
		<div class="tab-pane fade" id="nav-event" role="tabpanel" aria-labelledby="tab-event">
			<div class="col-md-12">
				<fieldset>
					<legend>{t}Événements{/t}</legend>
					{include file="gestion/eventList.tpl"}
				</fieldset>
				<fieldset>
					<legend>{t}Liste des prêts{/t}</legend>
					{include file="gestion/borrowingList.tpl"}
				</fieldset>
			</div>
		</div>
		<div class="tab-pane fade" id="nav-id" role="tabpanel" aria-labelledby="tab-id">
			<div class="col-md-12">
				{include file="gestion/objectIdentifierList.tpl"}
			</div>
		</div>
		<div class="tab-pane fade" id="nav-movement" role="tabpanel" aria-labelledby="tab-movement">
			<div class="col-md-12">
				{include file="gestion/objectMovementList.tpl"}
			</div>
		</div>
		<div class="tab-pane fade" id="nav-container" role="tabpanel" aria-labelledby="tab-container">
			{if $droits.gestion == 1 && $modifiable == 1}
				<a href="index.php?module=containerChange&uid=0&container_parent_uid={$data.uid}">
					<img src="display/images/new.png" height="25">
					{t}Nouveau contenant associé{/t}
				</a>
			{/if}
			{include file="gestion/containerListDetail.tpl"}
		</div>
		<div class="tab-pane fade" id="nav-sample" role="tabpanel" aria-labelledby="tab-sample">
			<div class="col-md-12">
				{include file="gestion/sampleListDetail.tpl"}
			</div>
		</div>
		<div class="tab-pane fade" id="nav-grid" role="tabpanel" aria-labelledby="tab-grid">
			<div class="col-md-12">
				{include file="gestion/containerDisplayOccupation.tpl"}
			</div>
		</div>
		<div class="tab-pane fade" id="nav-document" role="tabpanel" aria-labelledby="tab-document">
			<div class="col-md-12">
				{include file="gestion/documentList.tpl"}
			</div>
		</div>
		<div class="tab-pane fade" id="nav-booking" role="tabpanel" aria-labelledby="tab-booking">
			<div class="col-md-12">
				{include file="gestion/bookingList.tpl"}
			</div>
		</div>
	</div>
</div>
