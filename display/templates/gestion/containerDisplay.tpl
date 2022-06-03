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
		var tabHover = 0;
		try {
			tabHover = Cookies.get("tabHover");
		} catch (Exception) { }
		if (tabHover == 1) {
			$("#tabHoverSelect").prop("checked", true);
		}
		$("#tabHoverSelect").change(function() {
			if ($(this).is(":checked")) {
				tabHover = 1;
			} else {
				tabHover = 0;
			}
			Cookies.set("tabHover", tabHover, { expires: 365, secure: true });
		});
		/* Management of tabs */
		var activeTab = "{$activeTab}";
    	if (activeTab.length == 0) {
			try {
			activeTab = Cookies.get("containerDisplayTab");
			} catch (Exception) {
				activeTab = "";
			}
		}
		try {
			if (activeTab.length > 0) {
				$("#"+activeTab).tab('show');
			}
		} catch (Exception) { }
		$('.nav-tabs > li > a').hover(function() {
			if (tabHover == 1) {
   				$(this).tab('show');
			}
 		});
		 $('a[data-toggle="tab"]').on('shown.bs.tab', function () {
			Cookies.set("containerDisplayTab",$(this).attr("id"), { secure: true");
		});
		$('a[data-toggle="tab"]').on("click", function () {
			tabHover = 0 ;
		});

		$("#referent_name").click(function() {
			var referentId = "{$data.referent_id}";
			if (referentId > 0) {
			$.ajax( {
				url: "index.php",
				data: { "module": "referentGetFromId", "referent_id": referentId }
			})
			.done (function (value) {
				value = JSON.parse(value);
				var newval = value.referent_firstname + " " + value.referent_name + "<br>" + value.referent_email + "<br>" +
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
			var is_container = 1;
			event.preventDefault();
			$.ajax ( {
				url:url,
			method:"GET",
			data : { module:"objectGetDetail", uid:uid, is_container:is_container },
			success : function ( djs ) {
				try {
					var data = JSON.parse(djs);
					if ( data.length > 0 ) {
						if (!isNaN(data[0]["uid"])) {
							var uid = data[0]["uid"];
							if (uid > 0) {
								$("#search").val(data[0]["uid"]);
								form.get(0).submit();
							}
						}
					}
					$("#search").val("");
					form.get(0).event.preventDefault();
				} catch (error) {
					$("#search").val("");
				}
				}
			} );
		});
		$("#rapidAccess").on("click mouseover", function() {
			$("#rapidAccessForm").show();
			$("#search").focus();
		});
	});
</script>
<div class="row">
	<div class="col-md-12">
		<a href="index.php?module={$moduleListe}">
			<img src="display/images/list.png" height="25">
			{t}Retour à la liste{/t}
		</a>
		&nbsp;
			<a href="#" id="rapidAccess">
			<img src="display/images/boxopen.png" height="25">
			{t}Accès rapide{/t}
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
		<a href="index.php?module=containerDisplay&uid={$data.uid}&allSamples=1" title="Afficher tous les échantillons, y compris ceux stockés dans les contenants inclus">
			<img src="display/images/sample.png" height="25">
			{t}Afficher tous les échantillons{/t}
		</a>
		&nbsp;
		<a href="index.php?module=containerDisplay&uid={$data.uid}">
			<img src="display/images/refresh.png" title="Rafraîchir la page" height="15">
		</a>
	</div>
</div>
<div class="row">
	<div class="col-md-8">
		<h2>{t}Détail du contenant{/t} <i>{$data.uid} {$data.identifier}</i></h2>
	</div>
	<div id="rapidAccessForm" hidden class="col-sm-4 col-lg-offset-2 col-lg-2">
		<form id="open" action="index.php" action="index.php" method="GET">
			<input id="moduleBase" type="hidden" name="moduleBase" value="container">
			<input id="action" type="hidden" name="action" value="Display">
			<div class="form-group">
				<div class="col-md-6 col-sm-offset-2 col-md-offset-0 col-sm-4">
					<input id="search" class="form-control" placeholder="{t}uid ou identifiant{/t}" name="uid" required >
				</div>
				<input type="submit" id="searchExec" class="btn btn-warning col-md-6 col-sm-4" value="{t}Ouvrir{/t}">
			</div>
		</form>
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
			<a class="nav-link lexical" data-lexical="identifier_type" id="tab-id" href="#nav-id"  data-toggle="tab" role="tab" aria-controls="nav-id" aria-selected="false">
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
            <a class="nav-link lexical" data-lexical="container" id="tab-container" href="#nav-container"  data-toggle="tab" role="tab" aria-controls="nav-container" aria-selected="false">
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
				{if count ($objectIdentifiers) > 0}
					<dl class="dl-horizontal">
						<dt class="lexical" data-lexical="identifier_type">{t}Identifiants complémentaires :{/t}</dt>
						<dd>
							{$i = 0}
							{foreach $objectIdentifiers as $oi}
								{if $i > 0}<br>{/if}
								{$oi.identifier_type_name} ({$oi.identifier_type_code}):&nbsp;{$oi.object_identifier_value}
								{$i = $i + 1}
							{/foreach}
						</dd>
					</dl>
				{/if}
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="referent">{t}Référent :{/t}</dt>
					<dd id="referent_name" title="{t}Cliquez pour la description complète{/t}">
						<a href="#">{$data.referent_firstname} {$data.referent_name}</a>
					</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="container_type">{t}Type :{/t}</dt>
					<dd>{$data.container_family_name} - {$data.container_type_name}</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="product">{t}Produit utilisé :{/t}</dt>
					<dd>{$data.storage_product}</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="storage_condition">{t}Conditions de stockage :{/t}</dt>
					<dd>{$data.storage_condition_name}</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="clp">{t}Classification CLP :{/t}</dt>
					<dd>{$data.clp_classification}</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="status">{t}Statut :{/t}</dt>
					<dd>
						{$data.object_status_name}
						{if $data.trashed == 1}
							<span class="red">&nbsp;{t}Contenant mis à la corbeille{/t}</span>
						{/if}
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
				<dl class="dl-horizontal">
					<dt title="{t}Date technique de dernière modification du contenant{/t}">{t}Date de modification :{/t}</dt>
					<dd>{$data.change_date}</dd>
				</dl>
				{if strlen($data.wgs84_x) > 0 || strlen($data.wgs84_y) > 0}
					<dl class="dl-horizontal">
						<dt class="lexical" data-lexical="container_latlong">{t}Latitude :{/t}</dt>
						<dd>{$data.wgs84_y}</dd>
					</dl>
					<dl class="dl-horizontal">
						<dt>{t}Longitude :{/t}</dt>
						<dd>{$data.wgs84_x}</dd>
					</dl>
					{if $data.location_accuracy > 0}
						<dl class="dl-horizontal">
							<dt>{t}Précision de la localisation (en mètres) :{/t}</dt>
							<dd>{$data.location_accuracy}</dd>
						</dl>
					{/if}
				{/if}
				<dl class="dl-horizontal">
					<dt>{t}Commentaire :{/t}</dt>
					<dd class="textareaDisplay">{$data.object_comment}</dd>
				</dl>
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
				<dl class="dl-horizontal">
					<dt>{t}Nbre de slots utilisés / Nbre total :{/t}</dt>
					<dd>{$data.nb_slots_used} / {$data.nb_slots_max}</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="uuid">{t}UUID :{/t}</dt>
					<dd>{$data.uuid}</dd>
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
<div class="row">
	<div class="col-sm-12 messageBas">
		{t}Activer le survol des onglets :{/t}
	<input type="checkbox" id="tabHoverSelect">
	</div>
</div>
