{* Objets > échantillons > Rechercher > UID d'un échantillon *}
<script>
	var appli_code ="{$APPLI_code}";
	/*
	 * Impression de l'etiquette correspondant a l'echantillon courant
	 */
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
		var myStorage = window.localStorage;
		var activeTab = "{$activeTab}";
    	if (activeTab.length == 0) {
			try {
			activeTab = myStorage.getItem("sampleDisplayTab");
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
			myStorage.setItem("sampleDisplayTab", $(this).attr("id"));
		});
		$('a[data-toggle="tab"]').on("click", function () {
			tabHover = 0 ;
		});
		$("#sampleSpinner2").hide();
		var isReferentDisplayed = false;

		$("#samplelabels2").on ("keypress click", function() {
			$(this.form).find("input[name='module']").val("samplePrintLabel");
			$("#sampleSpinner2").show();
			$(this.form).submit();
		});
		$("#sampledirect2").on ("keypress click",function() {
			$(this.form).find("input[name='module']").val("samplePrintDirect");
			$("#sampleSpinner2").show();
			$(this.form).submit();
		});
		$("#referent_name").click(function() {
			var referentId = "{$data.real_referent_id}";
			if (referentId > 0 && !isReferentDisplayed) {
				isReferentDisplayed = true;
			$.ajax( {
    	   		url: "index.php",
    	    	data: { "module": "referentGetFromId", "referent_id": referentId }
    	    })
    	    .done (function (value) {
				value = JSON.parse(value);
				var newval = value.referent_firstname + " " + value.referent_name + "<br>" +
						value.referent_organization + "<br>" +
						value.referent_email + "<br>" +
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
			* Recherche si un sample existe
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
			 } catch (error) {}
			 // search for db:uid
			 var tab = uid.toString().split(":");
			if (tab.length == 2) {
				if (tab[0] == appli_code) {
					uid = tab[1];
					$("#search").val(uid);
				}
			}
		 	}
			var is_container = 2;
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
		<div class="col-md-8">
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
			<a href="index.php?module=sampleChange&uid=0">
					<img src="display/images/new.png" height="25">
					{t}Nouvel échantillon{/t}
				</a>
				&nbsp;
				<a href="index.php?module=sampleChange&uid=0&last_sample_id={$data.uid}&is_duplicate=1" title="{t}Nouvel échantillon avec duplication des informations, dont le parent{/t}">
					<img src="display/images/copy.png" height="25">
					{t}Dupliquer{/t}
					</a>
				{if $modifiable == 1}
					&nbsp;
					<a href="index.php?module=sampleChange&uid={$data.uid}">
						<img src="display/images/edit.gif" height="25">
						{t}Modifier{/t}
					</a>
				{/if}
				<!-- Entrée ou sortie -->
				<span id="input">
					<a href="index.php?module=movementsampleInput&movement_id=0&uid={$data.uid}" id="input" title="{t}Entrer ou déplacer l'échantillon dans un contenant{/t}">
						<img src="display/images/input.png" height="25">
						{t}Entrer ou déplacer...{/t}
					</a>
				</span>
				<span id="output">
					<a href="index.php?module=movementsampleOutput&movement_id=0&uid={$data.uid}" id="output" title="{t}Sortir l'échantillon du stock{/t}">
						<img src="display/images/output.png" height="25">
						{t}Sortir du stock...{/t}
					</a>
				</span>
			{/if}
			&nbsp;
			<a href="index.php?module=sampleDisplay&uid={$data.uid}">
				<img src="display/images/refresh.png" title="{t}Rafraîchir la page{/t}" height="15">
			</a>
		</div>
		<div class="col-md-4">
			<div class="pull-right bg-info">
				{if $droits.gestion == 1}
					<a href="index.php?module=sampleChange&uid=0">
							<img src="display/images/new.png" height="25">
							{t}Nouvel échantillon{/t}
						</a>
				{/if}
			</div>
		</div>
	</div>
<div class="row">
	<div class="col-sm-8 col-md-8">
		<h2>{t}Détail de l'échantillon{/t} <i>{$data.uid} {$data.identifier}</i></h2>
	</div>
	<div id="rapidAccessForm" hidden class="col-sm-4 col-lg-offset-2 col-lg-2">
		<form id="open" action="index.php" action="index.php" method="GET">
			<input id="moduleBase" type="hidden" name="moduleBase" value="sample">
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


<!-- boite d'onglets -->
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
            <a class="nav-link lexical" data-lexical="sample_derivated" id="tab-sample" href="#nav-sample"  data-toggle="tab" role="tab" aria-controls="nav-sample" aria-selected="false">
				<img src="display/images/sample.png" height="25">
				{t}Échantillons dérivés{/t}
			</a>
		</li>
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
		{if $data.multiple_type_id > 0}
		<li class="nav-item">
            <a class="nav-link" id="tab-subsample" href="#nav-subsample"  data-toggle="tab" role="tab" aria-controls="nav-subsample" aria-selected="false">
				<img src="display/images/subsample.png" height="25">
				{t}Sous-échantillonnage{/t}
			</a>
		</li>
		{/if}
	</ul>
	<div class="tab-content" id="nav-tabContent">
		<div class="tab-pane active in" id="nav-detail" role="tabpanel" aria-labelledby="tab-detail">
			<div class="form-display col-md-6">
				{if $droits.gestion == 1}
					<form method="GET" id="SampleDisplayFormListPrint" action="index.php">
						<input type="hidden" id="modulePrint" name="module" value="sampleUniquePrintLabel">
						<input type="hidden" id="uid2" name="uids" value="{$data.uid}">
						<input type="hidden" name="uid" value="{$data.uid}">
						<input type="hidden" name="lastModule" value="sampleDisplay">
						<div class="row">
							<div class="center">
								<select id="labels2" name="label_id">
									<option value="" {if $label_id == ""}selected{/if}>{t}Étiquette par défaut{/t}</option>
									{section name=lst loop=$labels}
										<option value="{$labels[lst].label_id}" {if $labels[lst].label_id == $label_id}selected{/if}>
											{$labels[lst].label_name}
										</option>
									{/section}
								</select>
								<button id="samplelabels2" class="btn btn-primary">{t}Étiquettes{/t}</button>
								<img id="sampleSpinner2" src="display/images/spinner.gif" height="25">
								{if count($printers) > 0}
									<select id="printers2" name="printer_id">
									{section name=lst loop=$printers}
										<option value="{$printers[lst].printer_id}">
											{$printers[lst].printer_name}
										</option>
									{/section}
									</select>
									<button id="sampledirect2" class="btn btn-primary">{t}Impression directe{/t}</button>
								{/if}
							</div>
						</div>
					</form>
				{/if}
				<dl class="dl-horizontal">
					<dt>{t}UID et identifiant métier :{/t}</dt>
					<dd>{$data.uid} {$data.identifier}</dd>
				</dl>
				{if count ($objectIdentifiers) > 0}
					<dl class="dl-horizontal">
						<dt class="lexical" data-lexical="identifier-type">{t}Identifiants complémentaires :{/t}</dt>
						<dd>
							{$i = 0}
							{foreach $objectIdentifiers as $oi}
								{if $i > 0}<br>{/if}
								{$oi.identifier_type_name} {if !empty($oi.identifier_type_code)}({$oi.identifier_type_code}){/if}:&nbsp;{$oi.object_identifier_value}
								{$i = $i + 1}
							{/foreach}
						</dd>
					</dl>
				{/if}
				{if strlen($data.dbuid_origin) > 0}
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="dbuid">{t}DB et UID d'origine :{/t}</dt>
					<dd>{$data.dbuid_origin}</dd>
				</dl>
				{/if}
				<dl class="dl-horizontal">
					<dt>{t}Collection :{/t}</dt>
					<dd>{$data.collection_name}</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="referent">{t}Référent :{/t}</dt>
					<dd id="referent_name" title="{t}Cliquez pour la description complète{/t}"><a href="#">{$data.referent_firstname} {$data.referent_name}</a></dd>
				</dl>
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="sample_type">{t}Type :{/t}</dt>
					<dd>{$data.sample_type_name}
					{if strlen($data.container_type_name) > 0}
						<br>
						{$data.container_type_name}
					{/if}
						{if strlen($data.clp_classification) > 0}
						<br>
						{t}clp :{/t} {$data.clp_classification}
					{/if}
					</dd>
				</dl>
				{if $data.operation_id > 0}
					<dl class="dl-horizontal">
						<dt class="lexical" data-lexical="protocol">{t}Protocole et opération :{/t}</dt>
						<dd>{$data.protocol_year} {$data.protocol_name} {$data.protocol_version} / {$data.operation_name} {$data.operation_version}
						</dd>
					</dl>
				{/if}
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="status">{t}Statut :{/t}</dt>
					<dd>{$data.object_status_name}
						{if $data.trashed == 1}
							<span class="red">&nbsp;{t}Échantillon mis à la corbeille{/t}</span>
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
					<dt>{t}Date de création	de l'échantillon (d'échantillonnage) :{/t}</dt>
					<dd>{$data.sampling_date}</dd>
				</dl>
				<dl class="dl-horizontal"><dt>{t}Date d'import dans la base de données :{/t}
					</dt>
					<dd>{$data.sample_creation_date}</dd>
				</dl>
				{if strlen($data.expiration_date) > 0}
					<dl class="dl-horizontal">
						<dt title="{t}Date d'expiration de l'échantillon{/t}">{t}Date d'expiration :{/t}</dt>
						<dd>{$data.expiration_date}</dd>
					</dl>
				{/if}
				<dl class="dl-horizontal">
					<dt title="{t}Date technique de dernière modification de l'échantillon{/t}">{t}Date de modification :{/t}</dt>
					<dd>{$data.change_date}</dd>
				</dl>
				{if $data.multiple_type_id > 0}
					<dl class="dl-horizontal">
						<dt class="lexical" data-lexical="subsample" title="{t 1=$data.multiple_unit}Quantité de sous-échantillons (%1){/t}">{t 1=$data.multiple_unit}Qté de sous-échantillons (%1) :{/t}</dt>
						<dd>{$data.multiple_value}</dd>
					</dl>
				{/if}
				{if $data.parent_uid > 0}
					<dl class="dl-horizontal">
						<dt title="{t}Échantillon parent{/t}">{t}Échantillon parent :{/t}</dt>
						<dd>
							<a href="index.php?module=sampleDisplay&uid={$data.parent_uid}">
								{$data.parent_uid} {$data.parent_identifier}
							</a>
						</dd>
					</dl>
				{/if}
				{if $data.no_localization == 0}
					{if $data.campaign_id > 0}
						<dl class="dl-horizontal">
							<dt>{t}Campagne de prélèvement :{/t}</dt>
							<dd><a href="index.php?module=campaignDisplay&campaign_id={$data.campaign_id}">{$data.campaign_name}</a></dd>
						</dl>
					{/if}
					{if $data.sampling_place_id > 0}
						<dl class="dl-horizontal">
							<dt class="lexical" data-lexical="sampling_place">{t}Lieu de prélèvement :{/t}</dt>
							<dd>{$data.sampling_place_name}</dd>
						</dl>
					{/if}
					{if $data.country_id > 0}
						<dl class="dl-horizontal">
							<dt class="lexical" data-lexical="country">{t}Pays de collecte :{/t}</dt>
							<dd>{$data.country_name}</dd>
						</dl>
					{/if}
					{if $data.country_origin_id > 0}
						<dl class="dl-horizontal">
							<dt class="lexical" data-lexical="country_origin">{t}Pays de provenance :{/t}</dt>
							<dd>{$data.country_origin_name}</dd>
						</dl>
					{/if}
					{if strlen($data.wgs84_x) > 0 || strlen($data.wgs84_y) > 0}
						<dl class="dl-horizontal">
							<dt class="lexical" data-lexical="sample_latlong">{t}Latitude :{/t}</dt>
							<dd>{$data.wgs84_y}</dd>
						</dl>
						<dl class="dl-horizontal">
							<dt>{t}Longitude :{/t}</dt>
							<dd>{$data.wgs84_x}</dd>
						</dl>
						{if $data.location_accuracy > 0}
							<dl class="dl-horizontal">
								<dt class="lexical" data-lexical="accuracy">{t}Précision de la localisation (en mètres) :{/t}</dt>
								<dd>{$data.location_accuracy}</dd>
							</dl>
						{/if}
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
					<dt class="lexical" data-lexical="uuid">{t}UUID :{/t}</dt>
					<dd>{$data.uuid}</dd>
				</dl>
				{if count($metadata) >0}
					<fieldset>
						<legend class="lexical" data-lexical="metadata">{t}Métadonnées associées{/t}</legend>
						{foreach $metadata as $key=>$value}
							<dl class="dl-horizontal">
								<dt>{t 1=$key}%1 :{/t}</dt>
								<dd>
								{if is_array($value) }
									{foreach $value as $val}
										{if is_array($val)}
											{$last = ""}
											{foreach $val as $val1}
												{if $val1 != $last}
													{$val1}<br>
													{$last = $val1}
												{/if}
											{/foreach}
										{else}
											{$val}<br>
										{/if}
									{/foreach}
								{else}
									{if substr($value, 0, 5) == "http:" || substr($value, 0, 6) == "https:"}
										<a href="{$value}" target="_blank">{$value}</a>
									{else}
										{$value}
									{/if}
								{/if}
								</dd>
							</dl>
						{/foreach}
					</fieldset>
				{/if}
			</div>
			{if strlen($data.wgs84_x) > 0 && strlen($data.wgs84_y) > 0 && $data.no_localization != 1}
				<div class="col-md-6">
					{include file="gestion/objectMapDisplay.tpl"}
				</div>
			{/if}
		</div>
		<div class="tab-pane fade" id="nav-event" role="tabpanel" aria-labelledby="tab-event">
			<div class="col-md-12">
				<fieldset>
					<legend class="lexical" data-lexical="event_type">{t}Événements{/t}</legend>
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
		<div class="tab-pane fade" id="nav-sample" role="tabpanel" aria-labelledby="tab-sample">
			<div class="col-md-12">
				{if $droits.gestion == 1 && $modifiable == 1}
					<a href="index.php?module=sampleChange&uid=0&parent_uid={$data.uid}">
					<img src="display/images/new.png" height="25">
					{t}Nouvel échantillon dérivé...{/t}
					</a>
				{/if}
				{include file="gestion/sampleListDetail.tpl"}
			</div>
		</div>
		<div class="tab-pane fade" id="nav-document" role="tabpanel" aria-labelledby="tab-document">
			<div class="col-md-12">
				{include file="gestion/documentList.tpl"}
				{if $externalStorageEnabled == 1}
				{include file="gestion/documentExternalAdd.tpl"}
				{/if}
			</div>
		</div>
		<div class="tab-pane fade" id="nav-booking" role="tabpanel" aria-labelledby="tab-booking">
			<div class="col-md-12">
				{include file="gestion/bookingList.tpl"}
			</div>
		</div>
		{if $data.multiple_type_id > 0}
		<div class="tab-pane fade" id="nav-subsample" role="tabpanel" aria-labelledby="tab-subsample">
			<div class="col-md-12">
				{include file="gestion/subsampleList.tpl"}
			</div>
		</div>
		{/if}
	</div>
</div>
<div class="row">
	<div class="col-sm-12 messageBas">
			{t}Activer le survol des onglets :{/t}
		<input type="checkbox" id="tabHoverSelect">
	</div>
</div>
