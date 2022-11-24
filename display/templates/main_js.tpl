<!-- Jquery -->
<script src="display/node_modules/jquery/dist/jquery.min.js"></script>
<!--script src="display/javascript/jquery-3.6.0.min.js"></script-->

<!-- Bootstrap -->
<link rel="stylesheet" href="display/javascript/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="display/javascript/bootstrap/css/bootstrap-theme.min.css">
<script src="display/javascript/bootstrap/js/bootstrap.min.js"></script>

<!--JqueryUI-->
<script src="display/node_modules/jquery-ui/dist/jquery-ui.min.js"></script>
<script src="display/node_modules/jquery-ui/ui/widgets/tooltip.js"></script>
<link rel="stylesheet" href="display/node_modules/jquery-ui/dist/themes/base/jquery-ui.min.css">

<!--alpaca -->
<script type="text/javascript" src="display/node_modules/handlebars/dist/handlebars.runtime.min.js"></script>
<script type="text/javascript" src="display/node_modules/alpaca/dist/alpaca/bootstrap/alpaca.min.js"></script>
<link rel="stylesheet" href="display/node_modules/alpaca/dist/alpaca/bootstrap/alpaca.min.css">
<!--<script type="text/javascript" src="display/javascript/alpaca/js/alpaca-1.5.23.min.js"></script>
<link rel="stylesheet" href="display/javascript/alpaca/css/alpaca-1.5.23.min.css" >-->

<!-- leaflet -->
<link rel="stylesheet" href="display/node_modules/leaflet/dist/leaflet.css">
<script src="display/node_modules/leaflet/dist/leaflet.js"></script>
<script src="display/node_modules/pouchdb/dist/pouchdb.min.js"></script>
<script src="display/node_modules/leaflet.tilelayer.pouchdbcached/L.TileLayer.PouchDBCached.js"></script>
<script src="display/node_modules/leaflet.polyline.snakeanim/L.Polyline.SnakeAnim.js"></script>
<script src="display/node_modules/leaflet-mouse-position/src/L.Control.MousePosition.js"></script>
<script src="display/node_modules/leaflet-easyprint/dist/bundle.js"></script>
<!-- extension pour le menu -->
<script src="display/node_modules/smartmenus/dist/jquery.smartmenus.min.js" type="text/javascript"></script>
<link type="text/css" href="display/node_modules/smartmenus/dist/addons/bootstrap/jquery.smartmenus.bootstrap.css"
	rel="stylesheet">
<script src="display/node_modules/smartmenus/dist/addons/bootstrap/jquery.smartmenus.bootstrap.min.js"
	type="text/javascript"></script>

<!-- Datatables -->
<script src="display/node_modules/datatables.net/js/jquery.dataTables.min.js"></script>
<script src="display/node_modules/datatables.net-bs/js/dataTables.bootstrap.js"></script>
<link rel="stylesheet" type="text/css" href="display/node_modules/datatables.net-bs/css/dataTables.bootstrap.min.css" />
<script src="display/javascript/intl.js"></script>

<!-- Boutons d'export associes aux datatables - classe datatable-export -->
<script src="display/node_modules/jszip/dist/jszip.min.js"></script>
<script src="display/node_modules/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="display/node_modules/datatables.net-buttons/js/buttons.print.min.js"></script>
<script src="display/node_modules/datatables.net-buttons/js/buttons.html5.min.js"></script>
<script src="display/node_modules/datatables.net-buttons-bs/js/buttons.bootstrap.min.js"></script>
<script src="display/node_modules/datatables.net-buttons/js/buttons.colVis.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="display/node_modules/datatables.net-buttons-bs/css/buttons.bootstrap.min.css" />
<script src="display/node_modules/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js"></script>

<!-- Rajout du tri sur la date/heure -->
<script type="text/javascript" src="display/node_modules/moment/min/moment.min.js"></script>
<script type="text/javascript" src="display/node_modules/datetime-moment/datetime-moment.js"></script>

<!-- composant date/heure -->

<script type="text/javascript" charset="utf-8"
	src="display/node_modules/jquery-ui/ui/i18n/datepicker-en-GB.js"></script>
<script type="text/javascript" charset="utf-8" src="display/node_modules/jquery-ui/ui/i18n/datepicker-fr.js"></script>
<script type="text/javascript" charset="utf-8"
	src="display/javascript/jquery-timepicker-addon/jquery-ui-timepicker-addon.min.js"></script>
<script type="text/javascript" charset="utf-8"
	src="display/javascript/jquery-timepicker-addon/i18n/jquery-ui-timepicker-fr.js"></script>
<link rel="stylesheet" type="text/css" href="display/node_modules/jquery-ui-dist/jquery-ui.min.css" />
<link rel="stylesheet" type="text/css" href="display/node_modules/jquery-ui-dist/jquery-ui.theme.min.css" />
<link rel="stylesheet" type="text/css"
	href="display/javascript/jquery-timepicker-addon/jquery-ui-timepicker-addon.min.css" />
	<link rel="stylesheet" type="text/css" href="display/CSS/bootstrap-prototypephp.css">
<script type="text/javascript" charset="utf-8" src="display/javascript/jquery-ui-custom/combobox.js"></script>

<!-- Affichage des photos -->
<link rel="stylesheet" href="display/node_modules/magnific-popup/dist/magnific-popup.css">
<script src="display/node_modules/magnific-popup/dist/jquery.magnific-popup.min.js"></script>

<!-- Cookies -->
<script src="display/javascript/js-cookie-master/src/js.cookie.js"></script>

<!-- Code specifique -->
<script type="text/javascript" src="display/javascript/bootstrap-prototypephp.js"></script>


<!--  implementation automatique des classes -->
<script>
	var dataTableLanguage = {
		"sProcessing": "{t}Traitement en cours...{/t}",
		"sSearch": "{t}Rechercher :{/t}",
		"sLengthMenu": "{t}Afficher _MENU_ éléments{/t}",
		"sInfo": "{t}Affichage de l'élément _START_ à _END_ sur _TOTAL_ éléments{/t}",
		"sInfoEmpty": "{t}Affichage de l'élément 0 à 0 sur 0 élément{/t}",
		"sInfoFiltered": "{t}(filtré de _MAX_ éléments au total){/t}",
		"sInfoPostFix": "",
		"sLoadingRecords": "{t}Chargement en cours...{/t}",
		"sZeroRecords": "{t}Aucun élément à afficher{/t}",
		"sEmptyTable": "{t}Aucune donnée disponible dans le tableau{/t}",
		"oPaginate": {
			"sFirst": "{t}Premier{/t}",
			"sPrevious": "{t}Précédent{/t}",
			"sNext": "{t}Suivant{/t}",
			"sLast": "{t}Dernier{/t}"
		},
		"oAria": {
			"sSortAscending": "{t}: activer pour trier la colonne par ordre croissant{/t}",
			"sSortDescending": "{t}: activer pour trier la colonne par ordre décroissant{/t}"
		},
		"buttons": {
			"pageLength": {
				_: "{t}Afficher %d éléments{/t}",
				'-1': "{t}Tout afficher{/t}"
			}
		}
	};
		var scroll = "50vh";
	$( document ).ready( function () {
		var pageLength = Cookies.get( "pageLength" );
		if ( !pageLength ) {
			pageLength = 10;
		}
		var locale = "{$LANG['date']['locale']}";
		$.fn.dataTable.ext.order.intl( locale, { "sensitivity": "base" } );
		$.fn.dataTable.ext.order.htmlIntl( locale, { "sensitivity": "base" } );
		$.fn.dataTable.moment( '{$LANG["date"]["formatdatetime"]}' );
		$.fn.dataTable.moment( '{$LANG["date"]["formatdate"]}' );
		$( '.datatable' ).DataTable( {
			"language": dataTableLanguage,
			"searching": false,
			dom: 'Bfrtip',
			"pageLength": pageLength,
			"lengthMenu": [ [ 10, 25, 50, 100, 500, -1 ], [ 10, 25, 50, 100, 500, "All" ] ],
			buttons: [
				"pageLength"
			]
		} );
		$( '.datatable-nopaging-nosearching' ).DataTable( {
			"language": dataTableLanguage,
			"searching": false,
			"paging": false,
			"scrollY":scroll,
			"scrollX":true,
			fixedHeader: {
            header: true,
            footer: true
        }
		} );
		$( '.datatable-searching' ).DataTable( {
			"language": dataTableLanguage,
			"searching": true,
			dom: 'Bfrtip',
			"pageLength": pageLength,
			"lengthMenu": [ [ 10, 25, 50, 100, 500, -1 ], [ 10, 25, 50, 100, 500, "All" ] ],
			buttons: [
				"pageLength"
			]
		} );
		$( '.datatable-nopaging' ).DataTable( {
			"language": dataTableLanguage,
			"paging": false,
			"searching": true,
			"scrollY":scroll,
			"scrollX":true,
			fixedHeader: {
            header: true,
            footer: true
        }
		} );
		$( '.datatable-nopaging-nosort' ).DataTable( {
			"language": dataTableLanguage,
			"paging": false,
			"searching": false,
			"ordering": false,
			"scrollY":scroll,
			fixedHeader: {
            header: true,
            footer: true
        }
		} );
		$( '.datatable-nosort' ).DataTable( {
			"language": dataTableLanguage,
			"searching": false,
			"ordering": false,
			dom: 'Bfrtip',
			"pageLength": pageLength,
			"lengthMenu": [ [ 10, 25, 50, 100, 500, -1 ], [ 10, 25, 50, 100, 500, "All" ] ],
			buttons: [
				"pageLength"
			]
		} );
		$( '.datatable-export' ).DataTable( {
			dom: 'Bfrtip',
			"language": dataTableLanguage,
			"paging": false,
			"scrollY":scroll,
			"scrollX":true,
			fixedHeader: {
            header: true,
            footer: true
        },
			"searching": true,
			buttons: [
				'copyHtml5',
				'excelHtml5',
				'csvHtml5',
				/* {
					 extend: 'pdfHtml5',
					 orientation: 'landscape'
				 },*/
				'print'
			]
		} );
		$( '.datatable-export-paging' ).DataTable( {
			dom: 'Bfrtip',
			"language": dataTableLanguage,
			"paging": true,
			"searching": true,
			"pageLength": pageLength,
			"lengthMenu": [ [ 10, 25, 50, 100, 500, -1 ], [ 10, 25, 50, 100, 500, "All" ] ],
			buttons: [
				'pageLength',
				'copyHtml5',
				'excelHtml5',
				{
					extend: 'csvHtml5',
					filename: 'export_' + new Date().toISOString()
				},
				'print'
			]
		} );

		$( ".datatable, .datatable-export-paging, .datatable-searching, .datatable-nosort" ).on( 'length.dt', function ( e, settings, len ) {
			Cookies.set( 'pageLength', len, { expires: 180, secure: true } );
		} );
		/* Initialisation for paging datatables */
		$( ".datatable, .datatable-export-paging, .datatable-searching, .datatable-nosort" ).DataTable().page.len( pageLength ).draw();

		$( '.taux,nombre' ).attr( 'title', '{t}Valeur numérique...{/t}' );
		$( '.taux' ).attr( {
			'pattern': '-?[0-9]+(\.[0-9]+)?',
			'maxlength': "10"
		} );
		$( '.nombre' ).attr( {
			'pattern': '-?[0-9]+',
			'maxlength': "10"
		} );
		{literal}
		$( '.uuid' ).attr( {
			'pattern': '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
			'maxlength': "36"
		} );
		{/literal}

			$( ".date" ).datepicker( $.datepicker.regional[ '{$LANG["date"]["locale"]}' ] );
			$( ".datepicker" ).datepicker( $.datepicker.regional[ '{$LANG["date"]["locale"]}' ] );
			$.datepicker.setDefaults( $.datepicker.regional[ '{$LANG["date"]["locale"]}' ] );
			$( ".timepicker" ).timepicker( {
				timeFormat: 'HH:mm:ss'
			} );
			$( '.timepicker' ).attr( 'pattern', '[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]' );
			$.timepicker.setDefaults( $.timepicker.regional[ '{$LANG["date"]["locale"]}' ] );
			$( '.datetimepicker' ).datetimepicker( {
				dateFormat: '{$LANG["date"]["formatdatecourt"]}',
				timeFormat: 'HH:mm:ss',
				timeInput: true
			} );
			$( '.date, .datepicker, .timepicker, .datetimepicker' ).attr( 'autocomplete', 'off' );

			var lib = "{t}Confirmez-vous la suppression ?{/t}";
			$( '.button-delete' ).keypress( function () {
				if ( confirm( lib ) == true ) {
					$( this.form ).find( "input[name='action']" ).val( "Delete" );
					$( this.form ).submit();
				} else
					return false;
			} );
			$( ".button-delete" ).click( function () {
				if ( confirm( lib ) == true ) {
					$( this.form ).find( "input[name='action']" ).val( "Delete" );
					$( this.form ).submit();
				} else {
					return false;
				}
			} );
			/*
			 * Initialisation des combobox
			 */
			$( ".combobox" ).combobox();
			/**
			 * Get a confirmation
			 */
			 $(".confirm").on("click keydown", function(event) {
				 if (confirm("{t}Confirmez-vous l'opération ?{/t}") == false) {
					 event.preventDefault();
				 }
			 });
			/**
			 * Add support of tabulation in textarea
			 */
			 $(".textarea-edit").keydown(function(event) {
				if(event.keyCode===9){
					var v=this.value,s=this.selectionStart,e=this.selectionEnd;
					this.value=v.substring(0, s)+'\t'+v.substring(e);
					this.selectionStart=this.selectionEnd=s+1;
					return false;
					}
			 });
		});
	function encodeHtml( rawStr ) {
		if ( rawStr && rawStr.length > 0 ) {
			try {
				var encodedStr = rawStr.replace( /[\u00A0-\u9999<>\&]/gim, function ( i ) {
					return '&#' + i.charCodeAt( 0 ) + ';';
				} );
			} catch ( Exception ) { }
			return encodedStr;
		} else {
			return "";
		}
	}
	/**
	 * Generate a popup for lexical entries, when mouse is over a question icon
	 * the field must have a class lexical and the attribute data-lexical with
	 * the value to found
	 */
	$( document ).ready( function () {
		var lexicalDelay = 1000, lexicalTimer, tooltipContent;
		$( ".lexical" ).mouseenter( function () {
			var objet = $( this );
			lexicalTimer = setTimeout( function () {
				var entry = objet.data( "lexical" );
				if ( entry.length > 0 ) {
					var url = "index.php";
					var data = {
						"module": "lexicalGet",
						"lexical": entry
					}
					$.ajax( { url: url, data: data } )
						.done( function ( d ) {
							if ( d ) {
								d = JSON.parse( d );
								if ( d.lexical ) {
									var content = d.lexical.split( " " );
									var length = 0;
									tooltipContent = "";
									content.forEach( function ( word ) {
										if ( length > 40 ) {
											tooltipContent += "<br>";
											length = 0;
										}
										tooltipContent += word + " ";
										length += word.length + 1;
									} );
									tooltipDisplay( objet );
								}
							}
						} );
				}
			}, lexicalDelay );
		} ).mouseleave( function () {
			clearTimeout( lexicalTimer );
			if($(this).is(':ui-tooltip')) {
				$(this).tooltip("close");
			}
		} );
		function tooltipDisplay( object ) {
			$(object).tooltip( {
				content: tooltipContent
			} );
			//object.tooltip("option", "content", tooltipContent);
			$(object).attr( "title", tooltipContent );
			$(object).tooltip( "open" );
		}
	} );
</script>
