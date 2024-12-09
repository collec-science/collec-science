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
	$( document ).ready( function () {
		var appli_code = "{$APPLI_code}";
		/**
		 * Optical read of qrcode
		 */
		var is_scan = false;
		function testScan() {
			if ( is_scan ) {
				return false;
			} else {
				return true;
			}
		}
		var snd = new Audio( "display/images/sound.ogg" );
		var timer;
		var timer_duration = 500;
		var destination = "object";
		var hasFoundCamera = false;

		const video = document.getElementById( 'qr-video' );
		const videoContainer = document.getElementById( 'video-container' );
		const camHasCamera = document.getElementById( 'cam-has-camera' );
		const camList = document.getElementById( 'cam-list' );
		const camHasFlash = document.getElementById( 'cam-has-flash' );
		const flashToggle = document.getElementById( 'flash-toggle' );
		const flashState = document.getElementById( 'flash-state' );
		const camQrResult = document.getElementById( 'cam-qr-result' );
		function searchCamera() {
			if ( !hasFoundCamera ) {
				QrScanner.listCameras( true ).then( cameras => cameras.forEach( camera => {
					const option = document.createElement( 'option' );
					option.value = camera.id;
					option.text = camera.label;
					camList.add( option );
				} ) );
				hasFoundCamera = true;
			}
		}
		var videosize = Math.min (window.screen.height, window.screen.width) ;
		$("#video-container").width(videosize);
		$("#video-container").height(videosize);

		// ####### Web Cam Scanning #######

		const scanner = new QrScanner( video, result => setResult( camQrResult, result ), {
			onDecodeError: error => {
				camQrResult.textContent = error;
				camQrResult.style.color = 'inherit';
			},
			highlightScanRegion: true,
			highlightCodeOutline: true,

		} );
		const updateFlashAvailability = () => {
			scanner.hasFlash().then( hasFlash => {
				camHasFlash.textContent = hasFlash;
				flashToggle.style.display = hasFlash ? 'inline-block' : 'none';
			} );
		};

		// for debugging
		window.scanner = scanner;

		document.getElementById( 'inversion-mode-select' ).addEventListener( 'change', event => {
			scanner.setInversionMode( event.target.value );
		} );

		camList.addEventListener( 'change', event => {
			scanner.setCamera( event.target.value ).then( updateFlashAvailability );
		} );

		flashToggle.addEventListener( 'click', () => {
			scanner.toggleFlash().then( () => flashState.textContent = scanner.isFlashOn() ? 'on' : 'off' );
		} );

		function setResult( label, result ) {
			//console.log( result.data );
			$( "#search" ).val( getVal( result.data ) );
			snd.play();
			scanner.stop();
			$( "#scannerDiv" ).hide();
			$( "#open" ).submit();
		}

		function extractUidValFromJson( valeur ) {
			/*
			 * Extrait le contenu de la chaine json
			 * Transformation des [] en { }
			 */
			// valeur = valeur.replace("[", String.fromCharCode(123));
			//valeur = valeur.replace ("]", String.fromCharCode(125));
			var data = JSON.parse( valeur );
			if ( data[ "db" ] == appli_code ) {
				return data[ "uid" ];
			} else {
				return data[ "db" ] + ":" + data[ "uid" ];
			}
		}

		function getVal( val ) {
			/*
			 * Extraction de la valeur - cas notamment de la lecture par douchette
			 */
			val = val.trim();

			var firstChar = val.substring( 0, 1 );
			var lastChar = val.substring( vallength - 1, vallength );
			if ( firstChar == "[" || firstChar == String.fromCharCode( 123 ) ) {
				var vallength = val.length;
				var lastChar = val.substring( vallength - 1, vallength );
				if ( lastChar == "]" || lastChar == String.fromCharCode( 125 ) ) {
					val = extractUidValFromJson( val );
				} else {
					val = "";
				}
			} else if ( val.substring( 0, 4 ) == "http" || val.substring( 0, 3 ) == "htp" ) {
				var elements = valeur.split( "/" );
				var nbelements = elements.length;
				if ( nbelements > 0 ) {
					val = elements[ nbelements - 1 ];
				}
			}
			return val;
		}
		/**
		 * read qrcode
		 */
		$( "#qrcode" ).on( "click", function () {
			if ( !is_scan ) {
				is_scan = true;
				$( "#scannerDiv" ).show();
				scanner.start().then( () => {
					updateFlashAvailability();
					searchCamera();
				} );
			} else {
				is_scan = false;
				scanner.stop();
				$( "#scannerDiv" ).hide();
			}
		} );

		var myStorage = window.localStorage;
		/*
		 * Impression de l'etiquette correspondant a l'echantillon courant
		 */

		function sleep( milliseconds ) {
			var start = new Date().getTime();
			for ( var i = 0; i < 1e7; i++ ) {
				if ( ( new Date().getTime() - start ) > milliseconds ) {
					break;
				}
			}
		}
		var tabHover = 0;
		try {
			tabHover = myStorage.getItem( "tabHover" );
		} catch ( Exception ) {
			console.log( Exception );
		}
		if ( tabHover == 1 ) {
			$( "#tabHoverSelect" ).prop( "checked", true );
		}
		$( "#tabHoverSelect" ).change( function () {
			if ( $( this ).is( ":checked" ) ) {
				tabHover = 1;
			} else {
				tabHover = 0;
			}
			myStorage.setItem( "tabHover", tabHover );
		} );
		/* Management of tabs */
		var activeTab = "{$activeTab}";
		if ( activeTab.length == 0 ) {
			try {
				activeTab = myStorage.getItem( "sampleDisplayTab" );
			} catch ( Exception ) {
				activeTab = "";
			}
		}
		try {
			if ( activeTab.length > 0 ) {
				$( "#" + activeTab ).tab( 'show' );
			}
		} catch ( Exception ) { }
		$( '.nav-tabs > li > a' ).hover( function () {
			if ( tabHover == 1 ) {
				$( this ).tab( 'show' );
			}
		} );
		$( 'a[data-toggle="tab"]' ).on( 'shown.bs.tab', function () {
			myStorage.setItem( "sampleDisplayTab", $( this ).attr( "id" ) );
		} );
		$( 'a[data-toggle="tab"]' ).on( "click", function () {
			tabHover = 0;
		} );
		var isReferentDisplayed = false;

		$( "#samplelabels2" ).on( "keypress click", function () {
			$( this.form ).find( "input[name='module']" ).val( "samplePrintLabel" );
			$( this.form ).submit();
		} );
		$( "#sampledirect2" ).on( "keypress click", function () {
			$( this.form ).find( "input[name='module']" ).val( "samplePrintDirect" );
			$( this.form ).submit();
		} );
		$( "#referent_name" ).click( function () {
			var referentId = "{$data.real_referent_id}";
			if ( referentId > 0 && !isReferentDisplayed ) {
				isReferentDisplayed = true;
				$.ajax( {
					url: "referentGetFromId",
					data: {  "referent_id": referentId }
				} )
					.done( function ( value ) {
						value = JSON.parse( value );
						var newval = value.referent_firstname + " " + value.referent_name + "<br>" +
							value.referent_organization + "<br>" +
							value.referent_email + "<br>" +
							value.referent_phone + "<br>" + value.address_name + "<br>"
							+ value.address_line2 + "<br>" + value.address_line3 + "<br>"
							+ value.address_city + "<br>" + value.address_country;
						$( "#referent_name" ).html( newval );
						;
					} );
			}
		} );
		$( "#open" ).submit( function ( event ) {
			/**
			* Recherche si un sample existe
			*/
			var form = $( this );
			var url = "";
			var uid = $( "#search" ).val();
			if ( $( "#search" ).val().length > 0 ) {
				try {
					obj = JSON.parse( $( "#search" ).val() );
					if ( obj.db.length > 0 ) {
						if ( obj.db == appli_code ) {
							uid = obj.uid;
							$( "#search" ).val( uid );
						}
					}
				} catch ( error ) { }
				// search for db:uid
				var tab = uid.toString().split( ":" );
				if ( tab.length == 2 ) {
					if ( tab[ 0 ] == appli_code ) {
						uid = tab[ 1 ];
						$( "#search" ).val( uid );
					}
				}
			}
			var is_container = 2;
			event.preventDefault();
			$.ajax( {
				url: "objectGetDetail",
				method: "GET",
				//async: "false",
				//cache: "false",
				data: { uid: uid, is_container: is_container },
				success: function ( djs ) {
					try {
						var data = JSON.parse( djs );
						if ( data.length > 0 ) {
							if ( !isNaN( data[ 0 ][ "uid" ] ) ) {
								var uid = data[ 0 ][ "uid" ];
								if ( uid > 0 ) {
									$( "#search" ).val( data[ 0 ][ "uid" ] );
									form.get( 0 ).submit();
								}
							}
						}
						$( "#search" ).val( "" );
						form.get( 0 ).event.preventDefault();
					} catch ( error ) {
						$( "#search" ).val( "" );
					}
				}
			} );
		} );
		$( "#rapidAccess" ).on( "click mouseover", function () {
			$( "#rapidAccessForm" ).show();
			$( "#search" ).focus();
		} );
	} );
</script>
<div class="row">
	<div class="col-md-8">
		<img id="qrcode" src="display/images/qrcode.png" height="25" title="{t}Scan du QRCODE{/t}">
		<a href="{$moduleListe}">
			<img src="display/images/list.png" height="25">
			{t}Retour à la liste{/t}
		</a>
		&nbsp;
		<a href="#" id="rapidAccess">
			<img src="display/images/boxopen.png" height="25">
			{t}Accès rapide{/t}
		</a>
		{if $rights.manage == 1}
		<a href="sampleChange?uid=0">
			<img src="display/images/new.png" height="25">
			{t}Nouvel échantillon{/t}
		</a>
		{if $data.uid > 0}
			&nbsp;
			<a href="sampleChange?uid=0&last_sample_id={$data.uid}&is_duplicate=1"
				title="{t}Nouvel échantillon avec duplication des informations, dont le parent{/t}">
				<img src="display/images/copy.png" height="25">
				{t}Dupliquer{/t}
			</a>
			{if $modifiable == 1}
			&nbsp;
			<a href="sampleChange?uid={$data.uid}">
				<img src="display/images/edit.gif" height="25">
				{t}Modifier{/t}
			</a>
			{/if}
			<!-- Entrée ou sortie -->
			<span id="input">
				<a href="movementsampleInput?movement_id=0&uid={$data.uid}" id="input"
					title="{t}Entrer ou déplacer l'échantillon dans un contenant{/t}">
					<img src="display/images/input.png" height="25">
					{t}Entrer ou déplacer...{/t}
				</a>
			</span>
			<span id="output">
				<a href="movementsampleOutput?movement_id=0&uid={$data.uid}" id="output"
					title="{t}Sortir l'échantillon du stock{/t}">
					<img src="display/images/output.png" height="25">
					{t}Sortir du stock...{/t}
				</a>
			</span>
			{/if}
		{/if}
		&nbsp;
		<a href="sampleDisplay?uid={$data.uid}">
			<img src="display/images/refresh.png" title="{t}Rafraîchir la page{/t}" height="15">
		</a>
	</div>
	<div class="col-md-4">
		<div class="pull-right bg-info">
			{if $rights.manage == 1}
			<a href="sampleChange?uid=0">
				<img src="display/images/new.png" height="25">
				{t}Nouvel échantillon{/t}
			</a>
			{/if}
		</div>
	</div>
</div>
<div id="scannerDiv" hidden>
	<div class="row">
		<div class="col-xs-12 center">
			<div id="video-container">
				<video id="qr-video"></video>
			</div>
		</div>
	</div>
	<div class="form-horizontal col-xs-12 col-lg-10">
		<div class="form-group">
			<label class="col-xs-4 control-label ">{t}Caméra :{/t}</label>
			<div class="col-xs-8">
				<select id="cam-list" class="form-control ">
					<option value="environment" selected>{t}Caméra arrière (défaut){/t}</option>
					<option value="user">{t}Caméra frontale{/t}</option>
				</select>
			</div>
		</div>
		<div class="form-group">
			<label class="col-xs-4 control-label ">{t}Mode couleur :{/t}</label>
			<div class="col-xs-8">
				<select id="inversion-mode-select" class="form-control ">
					<option value="original">Scan original (dark QR code on bright background)</option>
					<option value="invert">Scan with inverted colors (bright QR code on dark background)
					</option>
					<option value="both">Scan both</option>
				</select>
			</div>
		</div>
		<div class="form-group">
			<label for="cam-has-flash" class="col-xs-4 control-label ">{t}Flash présent :{/t}</label>
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

<div class="row">
	<div class="col-sm-8 col-md-8">
		{if $data.uid > 0}
		<h2>{t}Détail de l'échantillon{/t} <i>{$data.uid} {$data.identifier}</i></h2>
		{/if}
	</div>
	<div id="rapidAccessForm" hidden class="col-sm-4 col-lg-offset-2 col-lg-2">
		<form id="open" action="sampleDisplay" method="GET">
			<div class="form-group">
				<div class="col-md-6 col-sm-offset-2 col-md-offset-0 col-sm-4">
					<input id="search" class="form-control" placeholder="{t}uid ou identifiant{/t}" name="uid" required>
				</div>
				<input type="submit" id="searchExec" class="btn btn-warning col-md-6 col-sm-4" value="{t}Ouvrir{/t}">
			</div>
		{$csrf}</form>
	</div>
</div>
{if $data.uid > 0}

<!-- boite d'onglets -->
<div class="row">
	<ul class="nav nav-tabs" id="myTab" role="tablist">
		<li class="nav-item active">
			<a class="nav-link" id="tab-detail" data-toggle="tab" role="tab" aria-controls="nav-detail"
				aria-selected="true" href="#nav-detail">
				<img src="display/images/zoom.png" height="25">
				{t}Détails{/t}
			</a>
		</li>
		<li class="nav-item">
			<a class="nav-link lexical" data-lexical="identifier_type" id="tab-id" href="#nav-id" data-toggle="tab"
				role="tab" aria-controls="nav-id" aria-selected="false">
				<img src="display/images/label.png" height="25">
				{t}Identifiants{/t}
			</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" id="tab-event" href="#nav-event" data-toggle="tab" role="tab" aria-controls="nav-event"
				aria-selected="false">
				<img src="display/images/events.png" height="25">
				{t}Événements/prêts{/t}
			</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" id="tab-movement" href="#nav-movement" data-toggle="tab" role="tab"
				aria-controls="nav-movement" aria-selected="false">
				<img src="display/images/movement.png" height="25">
				{t}Mouvements{/t}
			</a>
		</li>
		<li class="nav-item">
			<a class="nav-link lexical" data-lexical="sample_derivated" id="tab-sample" href="#nav-sample"
				data-toggle="tab" role="tab" aria-controls="nav-sample" aria-selected="false">
				<img src="display/images/sample.png" height="25">
				{t}Échantillons dérivés{/t}
			</a>
		</li>
		{if $modifiable == 1 || $consultSeesAll == 1}
		<li class="nav-item">
			<a class="nav-link" id="tab-document" href="#nav-document" data-toggle="tab" role="tab"
				aria-controls="nav-document" aria-selected="false">
				<img src="display/images/camera.png" height="25">
				{t}Documents associés{/t}
			</a>
		</li>
		{/if}
		<li class="nav-item">
			<a class="nav-link" id="tab-booking" href="#nav-booking" data-toggle="tab" role="tab"
				aria-controls="nav-booking" aria-selected="false">
				<img src="display/images/crossed-calendar.png" height="25">
				{t}Réservations{/t}
			</a>
		</li>
		{if $data.multiple_type_id > 0}
		<li class="nav-item">
			<a class="nav-link" id="tab-subsample" href="#nav-subsample" data-toggle="tab" role="tab"
				aria-controls="nav-subsample" aria-selected="false">
				<img src="display/images/subsample.png" height="25">
				{t}Sous-échantillonnage{/t}
			</a>
		</li>
		{/if}
	</ul>
	<div class="tab-content" id="nav-tabContent">
		<div class="tab-pane active in" id="nav-detail" role="tabpanel" aria-labelledby="tab-detail">
			<div class="form-display col-md-6">
				{if $rights.manage == 1}
				<form method="GET" id="SampleDisplayFormListPrint" action="samplePrintLabel" target="_blank">
					<input type="hidden" id="uid2" name="uids" value="{$data.uid}">
					<input type="hidden" name="uid" value="{$data.uid}">
					<input type="hidden" name="lastModule" value="sampleDisplay">
					<div class="row">
						<div class="center">
							<select id="labels2" name="label_id">
								<option value="" {if $label_id=="" }selected{/if}>{t}Étiquette par défaut{/t}</option>
								{section name=lst loop=$labels}
								<option value="{$labels[lst].label_id}" {if
									$labels[lst].label_id==$label_id}selected{/if}>
									{$labels[lst].label_name}
								</option>
								{/section}
							</select>
							<button id="samplelabels2" class="btn btn-primary">{t}Étiquettes{/t}</button>
							{if !empty($printers)}
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
				{$csrf}</form>
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
						{$oi.identifier_type_name} {if
						!empty($oi.identifier_type_code)}({$oi.identifier_type_code}){/if}:&nbsp;{$oi.object_identifier_value}
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
					<dd id="referent_name" title="{t}Cliquez pour la description complète{/t}"><a
							href="#">{$data.referent_firstname} {$data.referent_name}</a></dd>
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
					<dd>{$data.protocol_year} {$data.protocol_name} {$data.protocol_version} / {$data.operation_name}
						{$data.operation_version}
					</dd>
				</dl>
				{/if}
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="status">{t}Statut :{/t}</dt>
					<dd>{$data.object_status_name}
						{if $data.trashed == 't'}
						<span class="red">&nbsp;{t}Échantillon mis à la corbeille{/t}</span>
						{/if}
						{if $data.object_status_id == 6}
						&nbsp;{t}le{/t}&nbsp;{$data.borrowing_date}
						&nbsp;{t}à{/t}&nbsp;
						<a href="borrowerDisplay?borrower_id={$data.borrower_id}">
							{$data.borrower_name}
						</a>

						<br>
						{t}Retour prévu le{/t}&nbsp;{$data.expected_return_date}
						{/if}
					</dd>
				</dl>

				<dl class="dl-horizontal">
					<dt>{t}Date de création de l'échantillon (d'échantillonnage) :{/t}</dt>
					<dd>{$data.sampling_date}</dd>
				</dl>
				<dl class="dl-horizontal">
					<dt>{t}Date d'import dans la base de données :{/t}
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
					<dt title="{t}Date technique de dernière modification de l'échantillon{/t}">
						{t}Date de modification :{/t}
					</dt>
					<dd>{$data.change_date}</dd>
				</dl>
				{if $data.multiple_type_id > 0}
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="subsample"
						title="{t 1=$data.multiple_unit}Quantité de sous-échantillons (%1){/t}">{t
						1=$data.multiple_unit}Qté de sous-échantillons (%1) :{/t}</dt>
					<dd>{$data.multiple_value}</dd>
				</dl>
				{/if}
				{if $data.parent_uid > 0}
				<dl class="dl-horizontal">
					<dt title="{t}Échantillon parent{/t}">{t}Échantillon parent :{/t}</dt>
					<dd>
						<a href="sampleDisplay?uid={$data.parent_uid}">
							{$data.parent_uid} {$data.parent_identifier}
						</a>
					</dd>
				</dl>
				{/if}
				{if !empty($sampleparents)}
				<dl class="dl-horizontal">
					<dt class="lexical" data-lexical="composite">{t}Parents (échantillon composé){/t}</dt>
					<dd>
						{foreach $sampleparents as $p}
						<a href="sampleDisplay?uid={$p.uid}">
							{$p.uid}&nbsp;{$p.identifier}
						</a><br>
						{/foreach}
					</dd>
				</dl>
				{/if}
				{if $data.no_localization != 1}
				{if $data.campaign_id > 0}
				<dl class="dl-horizontal">
					<dt>{t}Campagne de prélèvement :{/t}</dt>
					<dd><a href="campaignDisplay?campaign_id={$data.campaign_id}">
						{$data.campaign_name}
					</a>
					</dd>
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
						<a href="containerDisplay?uid={$parents[lst].uid}">
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
				{if !empty($metadata)}
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
			<div class="col-md-6">
			{if strlen($data.wgs84_x) > 0 && strlen($data.wgs84_y) > 0 && $data.no_localization != 1}
				{include file="gestion/objectMapDisplay.tpl"}
			{/if}
			</div>
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
				{if $rights.manage == 1 && $modifiable == 1}
				<a href="sampleChange?uid=0&parent_uid={$data.uid}">
					<img src="display/images/new.png" height="25">
					{t}Nouvel échantillon dérivé...{/t}
				</a>
				{/if}
				{include file="gestion/sampleListDetail.tpl"}
			</div>
		</div>
		{if $modifiable == 1 || $consultSeesAll == 1 }
		<div class="tab-pane fade" id="nav-document" role="tabpanel" aria-labelledby="tab-document">
			<div class="col-md-12">
				{include file="gestion/documentList.tpl"}
				{if $externalStorageEnabled == 1}
				{include file="gestion/documentExternalAdd.tpl"}
				{/if}
			</div>
		</div>
		{/if}
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
{/if}