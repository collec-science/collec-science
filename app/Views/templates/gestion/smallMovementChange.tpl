<script src='display/node_modules/qr-scanner/qr-scanner.umd.min.js'></script>
<!-- from : https://nimiq.github.io/qr-scanner/demo/ -->
<style>
	/*@media all and (max-device-width: 768px){ 
    	. {
			font-size: 3vw;
		}
		*/
	#video-container {
		position: relative;
		/*width: max-content;*/
		width:100%;
		height: max-content;
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
</style>
<script>
	var is_scan = false;
	function testScan() {
		if ( is_scan ) {
			return false;
		} else {
			return true;
		}
	}


	$( document ).ready( function () {
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

		function setResult( label, result ) {
			console.log( result.data );
			$( "#" + destination ).val( result.data );
			snd.play();
			$( "#" + destination ).change();
			scanner.stop();
		}

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
		//$("#video-container").width($(document).width());

		// ####### Web Cam Scanning #######

		$("#video-container").width(videosize);
		$("#video-container").height(videosize);
		
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



		var is_read = false;

		var mouvements = {};
		var objets = {};

		var db = "{$db}";
		/*
		 * Traitement des recherches
		 */
		$( "#object_search" ).on( 'keyup change', function () {
			clearTimeout( timer );
			timer = setTimeout( object_search, timer_duration );
		} );

		function object_search() {
			var val = getVal( $( "#object_search" ).val() );
			if ( val ) {
				search( "objectGetDetail", "object_uid", val, 0 );
			}
		}

		function container_search() {
			var val = getVal( $( "#container_search" ).val() );
			if ( val ) {
				search( "objectGetDetail", "container_uid", val, 1 );
			}
		}
		$( "#container_search" ).on( 'keyup change', function () {
			clearTimeout( timer );
			timer = setTimeout( container_search, timer_duration );
		} );
		$( "#object_search,#container_search" ).focus( function () {
			is_scan = true;
		} );
		$( "#object_search,#container_search" ).blur( function () {
			is_scan = false;
		} );

		$( "#object_uid" ).on( "change", function () {
			var uid = $( "#object_uid" ).val();
			var position = "";
			if ( objets[ uid ] ) {
				if ( objets[ uid ][ "position" ] ) {
					if ( objets[ uid ][ "position" ] == 1 ) {
						position = "{t}Dans le stock{/t}";
					} else {
						position = "{t}Hors du stock{/t}";
					}
				}
				$( "#position_stock" ).val( position );
			}

			search( "objectGetLastEntry", "container_uid", $( "#object_uid" ).val(), false );
		} );
		$( '#start' ).click( function () {
			destination = "container_search";
			scanner.start().then( () => {
				updateFlashAvailability();
				searchCamera();
			} );
		} );
		$( '#start2' ).click( function () {
			destination = "object_search";
			scanner.start().then( () => {
				updateFlashAvailability();
				searchCamera();
			} );
		} );


		$( '#stop' ).click( function () {
			scanner.stop();
		} );


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

		function search( module, fieldid, value, is_container ) {
			/*
			 * Declenchement de la recherche Ajax
			 */
			/*
			 * Traitement des caracteres parasites de ean128
			 */
			if ( value ) {
				/*
				 * Traitement des caracteres parasites de ean128
				 */
				if ( value.length > 0 ) {
					value = value.replace( /]C1/g, "" );
				}
				var url = "";
				var chaine;
				var options = "";
				if ( is_container == true ) {
					mouvements = {};
				} else {
					objets = {};
				}
				$.ajax( {
					url: url, method: "GET", data: { module: module, uid: value, is_container: is_container, is_partial: true }, success: function ( djs ) {
						var data = JSON.parse( djs );
						for ( var i = 0; i < data.length; i++ ) {
							var uid = data[ i ].uid;
							if ( module == "objectGetLastEntry" ) {
								uid = data[ i ].parent_uid;
							}
							if ( module == "objectGetDetail" ) {
								objets[ uid ] = {};
								objets[ uid ][ "position" ] = data[ i ].last_movement_type;
							}
							options += '<option value="' + uid + '">' + uid + "-" + data[ i ].identifier;
							if ( module == "objectGetLastEntry" ) {
								options += " col:" + data[ i ].column_number + " line:" + data[ i ].line_number;
								mouvements[ uid ] = {};
								mouvements[ uid ][ "col" ] = data[ i ].column_number;
								mouvements[ uid ][ "line" ] = data[ i ].line_number;
							}
							options += "</option>";
						}
						$( "#" + fieldid ).html( options );
						$( "#" + fieldid ).change();
					}
				} );
			}
		}

		function extractUidValFromJson( valeur ) {
			/*
			 * Extrait le contenu de la chaine json
			 * Transformation des [] en { }
			 */
			// valeur = valeur.replace("[", String.fromCharCode(123));
			//valeur = valeur.replace ("]", String.fromCharCode(125));
			var data = JSON.parse( valeur );
			if ( data[ "db" ] == db ) {
				return data[ "uid" ];
			} else {
				return data[ "db" ] + ":" + data[ "uid" ];
			}
		}

		$( "#container_uid" ).change( function () {
			var val = $( "#container_uid" ).val();
			if ( val > 0 && mouvements[ val ] ) {
				$( "#col" ).val( mouvements[ val ][ "col" ] );
				$( "#line" ).val( mouvements[ val ][ "line" ] );
			} else {
				$( "#col" ).val( 1 );
				$( "#line" ).val( 1 );
			}
		} );

		/*
		 * Declenchement des mouvements
		 */
		$( "#entry" ).click( function ( event ) {
			/*
			 * Verification qu'un objet et un container soient selectionnes
			 */
			var ok = false;
			var ouid = $( "#object_uid" ).val();
			var cuid = $( "#container_uid" ).val();
			if ( ouid && cuid ) {
				if ( ouid.length > 0 && cuid.length > 0 ) {
					ok = true;
				}
			}
			if ( ok ) {
				$( "#movement_type_id" ).val( "1" );
				write();
			}
			event.preventDefault();
		} );

		$( "#exit" ).click( function ( event ) {
			/*
			  * Verification qu'un objet soit selectionne
			  */
			var ok = false;
			var ouid = $( "#object_uid" ).val();
			if ( ouid ) {
				if ( ouid.length > 0 ) {
					ok = true;
				}
			}
			if ( ok ) {
				$( "#movement_type_id" ).val( "2" );
				write();
			}
			event.preventDefault();
		} );

		function write() {
			$.ajax( {
				url: "",
				method: "POST",
				data: {
					module: "smallMovementWriteAjax",
					movement_type_id: $( "#movement_type_id" ).val(),
					object_uid: $( "#object_uid" ).val(),
					container_uid: $( "#container_uid" ).val(),
					movement_reason_id: $( "#movement_reason_id" ).val(),
					column_number: $( "#column_number" ).val(),
					line_number: $( "#line_number" ).val()
				}
				, success: function ( res ) {
					var result = JSON.parse( res );
					console.log( result );
					if ( result.error_code == 200 ) {
						$( "#message" ).html( "{t}Mouvement créé{/t}" );
						$( "#message" ).toggleClass( "message", true );
						$( "#message" ).toggleClass( "messageError", false );
						$( "#object_search" ).val( "" );
						$( "#object_uid" ).val( "" );
						$( "#position_stock" ).empty();
						$( "#object_search" ).focus();
					} else {
						$( "#message" ).html( result.error_message );
						$( "#message" ).toggleClass( "message", false );
						$( "#message" ).toggleClass( "messageError", true );
					}
				}
			} );
		}
		/*
		 * Remise a zero des zones de recherche
		 */
		$( "#clear_container_search" ).click( function ( event ) {
			$( "#container_search" ).val( "" );
			$( "#container_uid" ).empty();
			$( "#container_search" ).focus();
		} );
		$( "#clear_object_search" ).click( function ( event ) {
			$( "#object_search" ).val( "" );
			$( "#object_uid" ).empty();
			$( "#object_search" ).focus();
		} );
		/*
		 * Inhibition de l'envoi du formulaire si vide
		 */
		$( "#smallMovement" ).submit( function ( event ) {
			var valobj = $( "#object_uid" ).val();
			if ( valobj ) {
				if ( valobj.length != 0 ) {
					write()
				}
			}
			event.preventDefault();
		} );
	} );
</script>
<div id="message"></div>
<div class="row">
	<div class="col-xs-12 col-md-6">
		<form class="form-horizontal" id="smallMovement" method="post" action="smallMovementWrite"
			onsubmit="return(testScan());">
			<input type="hidden" name="moduleBase" value="smallMovement">
			<input type="hidden" name="movement_id" value="0">
			<input type="hidden" id="movement_type_id" name="movement_type_id" value="1">

			<div class="row">
				<div class="col-xs-12 col-md-6">
					<div class="row">
						<div class="col-xs-9 col-md-8">
							<input id="object_search" type="text" name="object_search"
								placeholder="{t}Objet à entrer ou déplacer / sortir{/t}" value=""
								class="form-control " autofocus autocomplete="off">
						</div>
						<div class="col-xs-3 col-md-4">
							<button id="clear_object_search" class="btn btn-block  btn-info "
								type="button">{t}Effacer{/t}</button>
						</div>
						<div class="col-xs-12 col-md-12">
							<select id="object_uid" name="object_uid" class="form-control ">
							</select>
						</div>
						<div class="col-xs-3 col-md-12">
							<input id="position_stock" class="form-control " disabled value="">
						</div>
						<div class="col-xs-12">
							<select id="movement_reason_id" name="movement_reason_id" class="form-control ">
								<option value="" {if $movement_reason_id=="" }selected{/if}>
									{t}Motif du déstockage...{/t}
								</option>
								{section name=lst loop=$movementReason}
								<option value="{$movementReason[lst].movement_reason_id}" {if
									$movement_reason_id==$movementReason[lst].movement_reason_id}selected{/if}>
									{$movementReason[lst].movement_reason_name}
								</option>
								{/section}
							</select>
						</div>
					</div>
				</div>
				<div class="col-xs-12 col-md-6">
					<div class="row">
						<div class="col-xs-9 col-md-8">
							<input id="container_search" type="text" name="container_search"
								placeholder="{t}Contenant de destination{/t}" value="" class="form-control "
								autofocus autocomplete="off">
						</div>
						<div class="col-xs-3 col-md-4">
							<button id="clear_container_search" class="btn btn-block btn-info "
								type="button">{t}Effacer{/t}</button>
						</div>
						<div class="col-xs-12 col-md-12">
							<select id="container_uid" name="container_uid" class="form-control ">
							</select>
						</div>
						<div class="col-xs-2 col-md-2 ">{t}Col:{/t}</div>
						<div class="col-xs-4 col-md-4 ">
							<input id="col" name="column_number" value="1" class="form-control ">
						</div>
						<div class="col-xs-2 col-md-2 ">{t}Ligne:{/t}</div>
						<div class="col-xs-4 col-md-4">
							<input id="line" name="line_number" value="1" class="form-control ">
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-6">
					<button id="entry" class="btn btn-block btn-info " type="button">
						<span >
							{t}Entrer{/t}
						</span>
					</button>
				</div>
				<div class="col-xs-6">
					<button id="exit" class="btn btn-block btn-danger " type="button">
						<span >
							{t}Sortir{/t}
						</span>
					</button>
				</div>
			</div>
	</div>
	<div class="row">

	</div>
	{$csrf}</form>
</div>
</div>
<!-- Rajout pour la lecture optique -->
<div class="row col-xs-12" id="optical">
	<fieldset>
		<legend >{t}Lecture par la caméra de l'ordinateur ou du smartphone{/t}</legend>

		<div class="col-xs-12 col-lg-10">
			<div class="form-horizontal ">
				<div class="row">
					<div class="col-xs-4">
						<button id="start2" class="btn btn-success btn-block " type="button">
							<span >
								{t}Lecture de l'objet{/t}
							</span>
						</button>
					</div>
					<div class="col-xs-4">
						<button id="start" class="btn btn-success btn-block ">
							<span >
								{t}Lecture du contenant{/t}
							</span>
						</button>
					</div>
					<div class="col-xs-4">
						<button id="stop" class="btn btn-danger btn-block ">
							<span >
								{t}Arrêter la lecture{/t}
							</span>
						</button>
					</div>

				</div>
			</div>
		</div>
</div>

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
			<span id="cam-has-flash" ></span>
			<button id="flash-toggle" >
				📸 Flash: <span id="flash-state" >{t}off{/t}</span>
			</button>
		</div>
	</div>
	<span id="cam-qr-result" hidden></span>
</div>
</fieldset>
</div>