<script src='display/node_modules/qr-scanner/qr-scanner.umd.min.js'></script>
<!-- from : https://nimiq.github.io/qr-scanner/demo/ -->
<style>
	/*@media all and (max-device-width: 768px){ 
    	. {
			font-size: 3vw;
		}
		*/
	/*#video-container {
		position: relative;
		/*width: max-content;*/
	/*width: 100%;
		height: max-content;
		overflow: hidden;
	}*/
	#video-container {
		line-height: 0;
		position: relative;
		width: inherit !important;
		height: inherit !important;
		overflow: hidden;
	}

	#video-container .scan-region-highlight {
		border-radius: 30px;
		outline: rgba(0, 0, 0, .25) solid 50vmax;
	}

	#video-container .scan-region-highlight-svg {
		display: none;
	}

	#video-container .code-outline-highlight {
		stroke: rgba(255, 255, 255, .5) !important;
		stroke-width: 15 !important;
		stroke-dasharray: none !important;
	}

	#flash-toggle {
		display: none;
	}

	#qr-video {
		display: flex;
		align-items: center;
		justify-content: center;
		justify-items: center;
		margin-left: auto;
		margin-right: auto;
		padding: auto;
		height: inherit;
		width: inherit;
		object-fit: cover;
		overflow: hidden;
	}
</style>
<script>
	$(document).ready(function () {
		var appli_code = "{$APPLI_code}";
		/**
		 * Optical read of qrcode
		 */
		var is_scan = false;
		function testScan() {
			if (is_scan) {
				return false;
			} else {
				return true;
			}
		}
		var snd = new Audio("display/images/sound.ogg");
		var timer;
		var timer_duration = 500;
		var destination = "object";
		var hasFoundCamera = false;

		const video = document.getElementById('qr-video');
		const videoContainer = document.getElementById('video-container');
		const camHasCamera = document.getElementById('cam-has-camera');
		const camList = document.getElementById('cam-list');
		const camHasFlash = document.getElementById('cam-has-flash');
		const flashToggle = document.getElementById('flash-toggle');
		const flashState = document.getElementById('flash-state');
		const camQrResult = document.getElementById('cam-qr-result');
		function searchCamera() {
			if (!hasFoundCamera) {
				QrScanner.listCameras(true).then(cameras => cameras.forEach(camera => {
					const option = document.createElement('option');
					option.value = camera.id;
					option.text = camera.label;
					camList.add(option);
				}));
				hasFoundCamera = true;
			}
		}
		var videosize = Math.min(window.screen.height, window.screen.width);
		$("#video-container").width(videosize);
		$("#video-container").height(videosize);

		// ####### Web Cam Scanning #######

		const scanner = new QrScanner(video, result => setResult(camQrResult, result), {
			onDecodeError: error => {
				camQrResult.textContent = error;
				camQrResult.style.color = 'inherit';
			},
			highlightScanRegion: true,
			highlightCodeOutline: true,

		});
		const updateFlashAvailability = () => {
			scanner.hasFlash().then(hasFlash => {
				camHasFlash.textContent = hasFlash;
				flashToggle.style.display = hasFlash ? 'inline-block' : 'none';
			});
		};

		// for debugging
		window.scanner = scanner;

		document.getElementById('inversion-mode-select').addEventListener('change', event => {
			scanner.setInversionMode(event.target.value);
		});

		camList.addEventListener('change', event => {
			scanner.setCamera(event.target.value).then(updateFlashAvailability);
		});

		flashToggle.addEventListener('click', () => {
			scanner.toggleFlash().then(() => flashState.textContent = scanner.isFlashOn() ? 'on' : 'off');
		});

		function setResult(label, result) {
			$("#search").val(getVal(result.data));
			snd.play();
			scanner.stop();
			$("#scannerDiv").hide();
			$("#rapidAccessForm").submit();
		}

		function extractUidValFromJson(valeur) {
			/*
			 * Extrait le contenu de la chaine json
			 * Transformation des [] en { }
			 */
			// valeur = valeur.replace("[", String.fromCharCode(123));
			//valeur = valeur.replace ("]", String.fromCharCode(125));
			var data = JSON.parse(valeur);
			if (data["db"] == appli_code) {
				return data["uid"];
			} else {
				return data["db"] + ":" + data["uid"];
			}
		}

		function getVal(val) {
			/*
			 * Extraction de la valeur - cas notamment de la lecture par douchette
			 */
			val = val.trim();

			var firstChar = val.substring(0, 1);
			var lastChar = val.substring(vallength - 1, vallength);
			if (firstChar == "[" || firstChar == String.fromCharCode(123)) {
				var vallength = val.length;
				var lastChar = val.substring(vallength - 1, vallength);
				if (lastChar == "]" || lastChar == String.fromCharCode(125)) {
					val = extractUidValFromJson(val);
				} else {
					val = "";
				}
			} else if (val.substring(0, 4) == "http" || val.substring(0, 3) == "htp") {
				var elements = valeur.split("/");
				var nbelements = elements.length;
				if (nbelements > 0) {
					val = elements[nbelements - 1];
				}
			}
			return val;
		}
		/**
		 * read qrcode
		 */
		$("#qrcode").on("click", function () {
			if (!is_scan) {
				is_scan = true;
				$("#scannerDiv").show();
				scanner.start().then(() => {
					updateFlashAvailability();
					searchCamera();
				});
			} else {
				is_scan = false;
				scanner.stop();
				$("#scannerDiv").hide();
			}
		});

		var myStorage = window.localStorage;
		/*
		 * Impression de l'etiquette correspondant a l'echantillon courant
		 */

		function sleep(milliseconds) {
			var start = new Date().getTime();
			for (var i = 0; i < 1e7; i++) {
				if ((new Date().getTime() - start) > milliseconds) {
					break;
				}
			}
		}
		var tabHover = 0;
		try {
			tabHover = myStorage.getItem("tabHover");
		} catch (Exception) {
			console.log(Exception);
		}
		if (tabHover == 1) {
			$("#tabHoverSelect").prop("checked", true);
		}
		$("#tabHoverSelect").change(function () {
			if ($(this).is(":checked")) {
				tabHover = 1;
			} else {
				tabHover = 0;
			}
			myStorage.setItem("tabHover", tabHover);
		});
		/* Management of tabs */
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
				$("#" + activeTab).tab('show');
			}
		} catch (Exception) { }
		$('.nav-tabs > li > a').hover(function () {
			if (tabHover == 1) {
				$(this).tab('show');
			}
		});
		$('a[data-bs-toggle="tab"]').on('shown.bs.tab', function () {
			myStorage.setItem("sampleDisplayTab", $(this).attr("id"));
		});
		$('a[data-bs-toggle="tab"]').on("click", function () {
			tabHover = 0;
		});
		var isReferentDisplayed = false;

		$("#samplelabels2").on("keypress click", function () {
			$(this.form).find("input[name='module']").val("samplePrintLabel");
			$(this.form).submit();
		});
		$("#sampledirect2").on("keypress click", function () {
			$(this.form).find("input[name='module']").val("samplePrintDirect");
			$(this.form).submit();
		});
		$("#referent_name").click(function () {
			var referentId = "{$data.real_referent_id}";
			if (referentId > 0 && !isReferentDisplayed) {
				isReferentDisplayed = true;
				$.ajax({
					url: "referentGetFromId",
					data: { "referent_id": referentId }
				})
					.done(function (value) {
						value = JSON.parse(value);
						var newval = value.referent_firstname + " " + value.referent_name + "<br>" +
							value.referent_organization + "<br>" +
							value.referent_email + "<br>" +
							value.referent_phone + "<br>" + value.address_name + "<br>"
							+ value.address_line2 + "<br>" + value.address_line3 + "<br>"
							+ value.address_city + "<br>" + value.address_country;
						$("#referent_name").html(newval);
						;
					});
			}
		});
		$("#rapidAccessForm").submit(function (event) {
			/**
			* Recherche si un sample existe
			*/
			var form = $(this);
			var url = "";
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
				} catch (error) { }
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
			$.ajax({
				url: "objectGetDetail",
				method: "GET",
				//async: "false",
				//cache: "false",
				data: { uid: uid, is_container: is_container },
				success: function (djs) {
					try {
						var data = JSON.parse(djs);
						if (data.length > 0) {
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
			});
		});
		$("#rapidAccess").on("click mouseover", function () {
			$("#rapidAccessForm").show();
			$("#search").focus();
		});
		$("#rapidAccessForm").hide();
		$("#scannerDiv").hide();
		setTimeout(backToTop, 0);
	});
</script>
<div class="container-fluid">
	<div class="row align-items-center">
		<div class="col-auto">
			<img id="qrcode" src="display/images/qrcode.png" height="25" title="{t}Scan du QRCODE{/t}">
			<a href="{$moduleListe}">
				<img src="display/images/list.png" height="25">
				{t}Retour à la liste{/t}
			</a>
		</div>
		<div class="col-auto">
			<a href="#" id="rapidAccess">
				<img src="display/images/boxopen.png" height="25">
				{t}Accès rapide{/t}
			</a>
		</div>
		{if $rights.manage == 1}
		{if $data.uid > 0}
		<div class="col-auto">
			<a href="sampleChangeTab?uid=0&last_sample_id={$data.uid}&is_duplicate=1" title="{t}Nouvel échantillon avec duplication des informations, dont le parent{/t}">
				<img src="display/images/copy.png" height="25">
				{t}Dupliquer{/t}
			</a>
		</div>
		{if $modifiable == 1}
		<div class="col-auto">
			<a href="sampleChangeTab?uid={$data.uid}">
				<img src="display/images/edit.gif" height="25">
				{t}Modifier{/t}
			</a>
		</div>
		{/if}
		<!-- Entrée ou sortie -->
		<div class="col-auto">
			<span id="input">
				<a href="movementsampleInput?movement_id=0&uid={$data.uid}" id="input" title="{t}Entrer ou déplacer l'échantillon dans un contenant{/t}">
					<img src="display/images/input.png" height="25">
					{t}Entrer ou déplacer...{/t}
				</a>
			</span>
		</div>
		<div class="col-auto">
			<span id="output">
				<a href="movementsampleOutput?movement_id=0&uid={$data.uid}" id="output" title="{t}Sortir l'échantillon du stock{/t}">
					<img src="display/images/output.png" height="25">
					{t}Sortir du stock...{/t}
				</a>
			</span>
		</div>
		{/if}
		{/if}
		<div class="col-auto">

			<a href="sampleDisplay?uid={$data.uid}">
				<img src="display/images/refresh.png" id="refresh" title="{t}Rafraîchir la page{/t}" height="15">
			</a>
		</div>
		<div class="col-auto">
			{$help}
		</div>
		{if $rights.manage == 1}
		<div class="col-auto pull-right bg-info">
			<a href="sampleChangeTab?uid=0">
				<img src="display/images/new.png" height="25">
				{t}Nouvel échantillon{/t}
			</a>
			{/if}
		</div>
	</div>
	<div id="scannerDiv">
		<div class="row">
			<div class="col-xs-12 center">
				<div id="video-container">
					<video id="qr-video"></video>
				</div>
			</div>
		</div>
		<div class="form-horizontal col-xs-12 col-10">
			<div class="row">
				<label class="col-xs-4 form-label ">{t}Caméra :{/t}</label>
				<div class="col-xs-8">
					<select id="cam-list" class="form-select ">
						<option value="environment" selected>{t}Caméra arrière (défaut){/t}</option>
						<option value="user">{t}Caméra frontale{/t}</option>
					</select>
				</div>
			</div>
			<div class="row">
				<label class="col-xs-4 form-label ">{t}Mode couleur :{/t}</label>
				<div class="col-xs-8">
					<select id="inversion-mode-select" class="form-select ">
						<option value="original">Scan original (dark QR code on bright background)</option>
						<option value="invert">Scan with inverted colors (bright QR code on dark background)
						</option>
						<option value="both">Scan both</option>
					</select>
				</div>
			</div>
			<div class="row">
				<label for="cam-has-flash" class="col-xs-4 form-label ">{t}Flash présent :{/t}</label>
				<div class="col-xs-8">
					<span id="cam-has-flash" class=""></span>
					<button id="flash-toggle" class="">
						📸 Flash: <span id="flash-state" class="">{t}off{/t}</span>
					</button>
				</div>
			</div>
			<span id="cam-qr-result" hidden></span>
		</div>
	</div>

	<form id="rapidAccessForm" action="sampleDisplay" method="GET">
		<div class="row align-items-center">
			<div class="col-md-4">
				<input id="search" class="form-control" placeholder="{t}uid ou identifiant{/t}" name="uid" required>
			</div>
			<div class="col-md-4">
				<button type="submit" id="searchExec" class="btn btn-primary">{t}Ouvrir{/t}</button>
			</div>
		</div>
		{$csrf}
	</form>
	{if $data.uid > 0}
	<h2>
		{t}Détail de l'échantillon{/t} <i>{$data.uid} {$data.identifier}</i>
	</h2>
	<!-- boite d'onglets -->
	<div class="row">
		<ul class="nav nav-tabs" id="myTab" role="tablist">
			<li class="nav-item">
				<a class="nav-link active" id="tab-detail" data-bs-toggle="tab" role="tab" aria-controls="nav-detail" aria-selected="true" href="#nav-detail">
					<img src="display/images/zoom.png" height="25">
					{t}Détails{/t}
				</a>
			</li>
			<li class="nav-item">
				<a class="nav-link lexical" data-lexical="identifier_type" id="tab-id" href="#nav-id" data-bs-toggle="tab" role="tab" aria-controls="nav-id" aria-selected="false">
					<img src="display/images/label.png" height="25">
					{t}Identifiants{/t}
				</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" id="tab-event" href="#nav-event" data-bs-toggle="tab" role="tab" aria-controls="nav-event" aria-selected="false">
					<img src="display/images/events.png" height="25">
					{t}Événements/prêts{/t}
				</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" id="tab-movement" href="#nav-movement" data-bs-toggle="tab" role="tab" aria-controls="nav-movement" aria-selected="false">
					<img src="display/images/movement.png" height="25">
					{t}Mouvements{/t}
				</a>
			</li>
			<li class="nav-item">
				<a class="nav-link lexical" data-lexical="sample_derivated" id="tab-sample" href="#nav-sample" data-bs-toggle="tab" role="tab" aria-controls="nav-sample" aria-selected="false">
					<img src="display/images/sample.png" height="25">
					{t}Échantillons dérivés{/t}
				</a>
			</li>
			{if $modifiable == 1 || $consultSeesAll == 1}
			<li class="nav-item">
				<a class="nav-link" id="tab-document" href="#nav-document" data-bs-toggle="tab" role="tab" aria-controls="nav-document" aria-selected="false">
					<img src="display/images/camera.png" height="25">
					{t}Documents associés{/t}
				</a>
			</li>

			{/if}
			<li class="nav-item">
				<a class="nav-link" id="tab-booking" href="#nav-booking" data-bs-toggle="tab" role="tab" aria-controls="nav-booking" aria-selected="false">
					<img src="display/images/crossed-calendar.png" height="25">
					{t}Réservations{/t}
				</a>
			</li>
			{if $data.multiple_type_id > 0}
			<li class="nav-item">
				<a class="nav-link" id="tab-subsample" href="#nav-subsample" data-bs-toggle="tab" role="tab" aria-controls="nav-subsample" aria-selected="false">
					<img src="display/images/subsample.png" height="25">
					{t}Sous-échantillonnage{/t}
				</a>
			</li>
			{/if}
			{if $modifiable == 1 || $consultSeesAll == 1}
			<li class="nav-item">
				<a class="nav-link" id="tab-histo" href="#nav-histo" data-bs-toggle="tab" role="tab" aria-controls="nav-histo" aria-selected="false">
					<img src="display/images/history.png" height="25">
					{t}Historique des modifications{/t}
				</a>
			</li>
			{/if}
		</ul>
	</div>
	<div class="tab-content" id="nav-tabContent">
		<div class="tab-pane active in" id="nav-detail" role="tabpanel" aria-labelledby="tab-detail">
			{include file="gestion/sampleDetail.tpl"}
		</div>
		<div class="tab-pane fade" id="nav-event" role="tabpanel" aria-labelledby="tab-event">
			<div class="col-12">
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
			<div class="col-12">
				{include file="gestion/objectIdentifierList.tpl"}
			</div>
		</div>
		<div class="tab-pane fade" id="nav-movement" role="tabpanel" aria-labelledby="tab-movement">
			<div class="col-12">
				{include file="gestion/objectMovementList.tpl"}
			</div>
		</div>
		<div class="tab-pane fade" id="nav-sample" role="tabpanel" aria-labelledby="tab-sample">
			<div class="col-12">
				{if $rights.manage == 1 && $modifiable == 1}
				<a href="sampleChangeTab?uid=0&parent_uid={$data.uid}">
					<img src="display/images/new.png" height="25">
					{t}Nouvel échantillon dérivé...{/t}
				</a>
				{/if}
				{include file="gestion/sampleListDetail.tpl"}
			</div>
		</div>
		{if $modifiable == 1 || $consultSeesAll == 1 }
		<div class="tab-pane fade" id="nav-document" role="tabpanel" aria-labelledby="tab-document">
			<div class="col-12">
				{include file="gestion/documentList.tpl"}
				{if $externalStorageEnabled == 1}
				{include file="gestion/documentExternalAdd.tpl"}
				{/if}
			</div>
		</div>
		{/if}
		<div class="tab-pane fade" id="nav-booking" role="tabpanel" aria-labelledby="tab-booking">
			<div class="col-12">
				{include file="gestion/bookingList.tpl"}
			</div>
		</div>
		{if $data.multiple_type_id > 0}
		<div class="tab-pane fade" id="nav-subsample" role="tabpanel" aria-labelledby="tab-subsample">
			<div class="col-12">
				{include file="gestion/subsampleList.tpl"}
			</div>
		</div>
		{/if}
		{if $modifiable == 1 || $consultSeesAll == 1 }
		<div class="tab-pane fade" id="nav-histo" role="tabpanel" aria-labelledby="tab-histo">
			<div class="col-12">
				{include file="gestion/sampleHistory.tpl"}
			</div>
		</div>
		{/if}
	</div>
	{/if}
	<div class="row">
		<div class="col-12 messageBas">
			<label for="tabHoverSelect" class="form-check-label">
				{t}Activer le survol des onglets :{/t}
			</label>
			<input type="checkbox" id="tabHoverSelect" class="form-check-input">
		</div>
	</div>


</div>