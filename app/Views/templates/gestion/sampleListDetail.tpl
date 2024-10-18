<!--  Liste des échantillons pour affichage-->
<script>
	$( document ).ready( function () {
		var totalNumber = "{$totalNumber}";
		var limit = "{$sampleSearch['limit']}";
		var searchByColumn = 0;
		var myStorageSample = window.localStorage;
		var metadatafilter = "{$sampleSearch['metadatafilter']}";
        try {
		searchByColumn = myStorageSample.getItem("searchByColumn");
		if (!searchByColumn) {
			searchByColumn = 0;
		}
        } catch (Exception) {
        }
		var pageLength = 10;
		try {
			pageLength = myStorageSample.getItem("samplePageLength");
			if (pageLength == -1) {
				pageLength = 10;
			}
		} catch (Exception) {
		}
		var scrolly = "2000pt";
		var isGestion = "{$rights.manage}";
		var maxcol = 21;
		/*if (limit < 5 && limit > 0 || totalNumber < 5 && totalNumber > 0) {
			scrolly = "20vh";
		}*/
		try {
			var hb = JSON.parse(myStorageSample.getItem("sampleSearchColumns"));
			if (hb.length == 0) {
				if (isGestion == 1) {
					hb = [11,12,13,14,15,16,17,18,19,20,21];
				} else {
					hb = [10,11,12,13,14,15,16,17,18,19,20];
					maxcol = 20;
				}
			}
		} catch {
			if (isGestion == 1) {
					var hb = [11,12,13,14,15,16,17,18,19,20,21];
				} else {
					var hb = [10,11,12,13,14,15,16,17,18,19,20];
					maxcol = 20;
				}
		}
		var lengthMenu = [10, 25, 50, 100, 500, { label:'all',value: -1}];
		var buttons = [
				'pageLength',
				{
					extend: 'colvis',
					text: '{t}Colonnes affichées{/t}'
				},
				{
					extend: 'csv',
					text: 'csv',
					filename: 'samples',
					exportOptions: {
						columns: [1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18]
					},
					customize: function (csv) {
						var split_csv = csv.split("\n");
						//set headers
						split_csv[0] = '"uid","identifier","other_identifiers","collection","type","status","sample_parent","last_movement","place","storage_condition_name","referent","campaign","sampling_place","sampling_date","creation_date","expiration_date","available_quantity"';
						csv = split_csv.join("\n");
            return csv;
					}
				},
				{
					extend: 'copy',
					text: '{t}Copier{/t}',
					exportOptions: {
						columns: [1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18]
					},
					customize: function (csv) {
						var split_csv = csv.split("\n");
						//set headers
						split_csv[3] = 'uid\tidentifier\tother_identifiers\tcollection\ttype\tstatus\tsample_parent\tlast_movement\tplace\tstorage_condition_name\treferent\tcampaign\tsampling_place\tsampling_date\tcreation_date\texpiration_date\tavailable_quantity';
						split_csv.shift();
						split_csv.shift();
						split_csv.shift();
						csv = split_csv.join("\n");
            return csv;
					}
				}
			];
			if (searchByColumn == 1) { 
				var tableList = $( '#sampleList' ).DataTable( {
					//dom: 'Birtp',
					"language": dataTableLanguage,
					"paging": true,
					"searching": true,
					"stateSave": false,
					"stateDuration": 60 * 60 * 24 * 30,
					"columnDefs" : [
						{
						"targets": hb,
						"visible": false
						}
					],
					layout: {
						topStart: {
							buttons: buttons
						}
					},
					lengthMenu: lengthMenu,
					pageLength: pageLength,
					fixedHeader: {
						header: false,
						footer: true
					},
				});
			} else {
				var tableList = $( '#sampleList' ).DataTable( {
					"order": [[1, "asc"]],
					//dom: 'Bfirtp',
					"language": dataTableLanguage,
					"paging": true,
					"searching": true,
					//scrollY:scrolly,
					scrollX:true,
					fixedHeader: {
						header: true,
						footer: true
					},
					"stateDuration": 60 * 60 * 24 * 30,
					"columnDefs" : [
						{
						"targets": hb,
						"visible": false
						}
					],
					layout: {
						topStart: {
							buttons: buttons
						}
					},
					lengthMenu: lengthMenu,
					pageLength: pageLength
				} );
			}
		tableList.on( 'buttons-action', function ( e, buttonApi, dataTable, node, config ) {
			var hb = [];
			tableList.columns().every(function () {
				if (!this.visible()) {
					hb.push(this.index());
				}
				myStorageSample.setItem("sampleSearchColumns", JSON.stringify(hb));
			});
		} );
		$("#sampleList").on('length.dt', function (e, settings, len) {
			if (len > -1) {
				myStorage.setItem('samplePageLength', len);
			}
        });
		/**
		 * select or unselect samples
		 */
		$( ".checkSampleSelect" ).change( function () {
			var libelle = "{t}Tout cocher{/t}";
			if ( this.checked ) {
				libelle = "{t}Tout décocher{/t}";
			}
			$( '.checkSample' ).prop( 'checked', this.checked );
			$( "#lsamplechek" ).text( libelle );
		} );

		$( "#sampleSpinner" ).hide();
		/**
		 * Actions on the list, for export and print
		 */
		$( '#samplecsvfile' ).on( 'keypress click', function () {
			$( this.form ).find( "input[name='module']" ).val( "sampleExportCSV" );
			$( this.form ).prop( 'target', '_self' ).submit();
		} );
		$( "#samplelabels" ).on( "keypress click", function () {
			$( "#samplemodule" ).val( "samplePrintLabel" );
			$("#sampleSpinner").show();
			$( this.form ).submit();
		} );
		$( "#sampledirect" ).on( "keypress click", function () {
			$( "#samplemodule" ).val( "samplePrintDirect" );
			$( "#sampleSpinner" ).show();
			$( this.form ).prop( 'target', '_self' ).submit();
		} );
		$( "#sampleExport" ).on( "keypress click", function () {
			$( "#samplemodule" ).val( "sampleExport" );
			$( this.form ).prop( 'target', '_self' ).submit();
		} );

		$( "#checkedButtonSample" ).on( "keypress click", function ( event ) {
			var nbchecked = $ (".checkSample:checked").length;
			if (nbchecked > 0) {
				var action = $( "#checkedActionSample" ).val();
				var ok = true;
				if ( action.length > 0 ) {
					if (action == "samplesCreateEvent") {
						if (!$("#due_date").val()  && !$("#event_date").val()) {
							alert(("{t}La date de réalisation ou la date prévue doit être indiquée{/t}"));
							event.preventDefault();
							ok = false;
						}
					} 
					if (ok) {
						var conf = confirm( "{t}Attention : cette opération est définitive. Est-ce bien ce que vous voulez faire ?{/t}" );
						if ( conf == true ) {
							$( this.form ).find( "input[name='module']" ).val( action );
							$( this.form ).prop( 'target', '_self' ).submit();
						} else {
							event.preventDefault();
						}
					}
				} else {
					event.preventDefault();
				}
			} else {
				alert("{t}Aucun échantillon sélectionné !{/t}");
				event.preventDefault();
			}
		} );
		/**
		 * Actions for the list of samples - bottom of the list
		 */
		var actions = {
			"samplesAssignReferent": "referentid",
			"samplesCreateEvent": "event",
			"samplesLending": "borrowing",
			"samplesSetTrashed": "trashedgroupsample",
			"samplesEntry": "entry",
			"samplesSetCountry": "country",
			"samplesSetCollection": "collection",
			"samplesSetCampaign": "campaign",
			"samplesSetStatus": "status",
			"samplesSetParent": "parentid",
			"samplesDocument": "document",
			"samplesExit": "samplesExit",
			"lotCreate":"lotCreate",
			"samplesCreateComposite":"createComposite"
		};
		$( "#checkedActionSample" ).change( function () {
			var action = $( this ).val();
			var actionClass = actions[ action ];
			var value;
			$("#sampleFormListPrint").attr("action", action);
			for ( const key in actions ) {
				if ( actions.hasOwnProperty( key ) ) {
					value = actions[ key ];
					if ( value == actionClass ) {
						$( "." + value ).show();
					} else {
						$( "." + value ).hide();
					}
				}
			};
			/**
			 * set the event_type from collection_id
			 */
			if (actionClass == "event") {
				getTypeEvents();
			}
		} );
		var tooltipContent;
		/**
		 * Display the content of a sample
		 */
		var delay = 1000, timer, ajaxDone = true;
		$( ".sample" ).mouseenter( function () {
			var objet = $( this );
			timer = setTimeout( function () {
				var uid = objet.data( "uid" );
				if ( !objet.is( ':ui-tooltip' ) ) {
					if ( uid > 0 && ajaxDone ) {
						ajaxDone = false;
						var url = "sampleDetail";
						var data = { "uid": uid };
						$.ajax( { url: url, data: data } )
							.done( function ( d ) {
								ajaxDone = true;
								if ( d ) {
									d = JSON.parse( d );
									if ( !d.error_code ) {
										var content = "{t}UID et référence :{/t} "
											+ encodeHtml( d.uid.toString() ) + "&nbsp;" + encodeHtml( d.identifier );
										if ( d.dbuid_origin ) {
											content += "<br>{t}DB et UID d'origine :{/t} " + encodeHtml( d.dbuid_origin );
										}
										if ( d.identifiers ) {
											d.identifiers.split( "," ).forEach( function ( dc ) {
												//content += "<br>" + encodeHtml(dc.identifier_type_code)+ ":" + encodeHtml(dc.object_identifier_value);
												content += "<br>" + encodeHtml( dc );
											} );
										}
										content += "<br>{t}Collection :{/t} " + encodeHtml( d.collection_name );
										content += "<br>{t}Référent :{/t} " + encodeHtml( d.referent_name ) + " " + encodeHtml(d.referent_firstname);
										content += "<br>{t}Type :{/t} " + encodeHtml( d.sample_type_name );
										if ( d.container_type_name ) {
											content += " / " + encodeHtml( d.container_type_name );
										}
										if ( d.clp_classification ) {
											content += " / {t}clp :{/t} " + encodeHtml( d.clp_classification );
										}
										if ( d.campaign_id > 0 ) {
											content += "<br>{t}Campagne :{/t} " + encodeHtml( d.campaign_name );
										}
										if ( d.operation_id > 0 ) {
											content += "<br>{t}Protocole et opération :{/t} " + encodeHtml( d.protocol_year ) + " " + encodeHtml( d.protocol_name ) + " " + encodeHtml( d.operation_name ) + " " + encodeHtml( d.operation_version );
										}
										content += "<br>{t}Statut :{/t} " + encodeHtml( d.object_status_name );
										content += "<br>{t}Date de création	de l'échantillon (d'échantillonnage) :{/t} " + encodeHtml( d.sampling_date );
										content += "<br>{t}Date d'import dans la base de données :{/t} " + encodeHtml( d.sample_creation_date );
										if ( d.expiration_date ) {
											content += "<br>{t}Date d'expiration de l'échantillon :{/t} " + encodeHtml( d.expiration_date );
										}
										if (d.multiple_value) {
											content +="<br>{t}Quantité initiale :{/t} " + encodeHtml(d.multiple_value) +" " + d.multiple_unit;
											content +="<br>{t}Reste disponible :{/t} "+ encodeHtml(d.subsample_quantity);
										}
										if ( d.parent_uid ) {
											content += "<br>{t}Échantillon parent :{/t} " + encodeHtml( d.parent_uid.toString() ) + " " + encodeHtml( d.parent_identifier );
										}
										if ( d.sampling_place_id ) {
											content += "<br>{t}Lieu de prélèvement :{/t} " + encodeHtml( d.sampling_place_name );
										}
										if ( d.country_name ) {
											content += "<br>{t}Pays de collecte :{/t} " + encodeHtml( d.country_name );
										}
										if ( d.country_origin_name ) {
											content += "<br>{t}Pays de provenance :{/t} " + encodeHtml( d.country_origin_name );
										}
										if (d.object_comment) {
											content += "<br>{t}Commentaires :{/t} " + encodeHtml (d.object_comment);
										}
										if ( d.metadata ) {
											content += "<br><u>{t}Métadonnées :{/t}</u>";
											dm = d.metadata;
											var comma = "";
											for ( key in dm ) {
												dmunitname = "md_" + key + "_unit";
												if (d[dmunitname]) {
													mdunit = " ("+ encodeHtml(d[dmunitname]) + ")";
												} else {
													mdunit = "";
												}
												content += "<br>" + key + mdunit + "{t} : {/t}";
												if ( Array.isArray( dm[ key ] ) ) {
													$.each( dm[ key ], function ( i, md ) {
														content += comma;
														if (!md.value) {
														content += encodeHtml( md );
														} else {
															content += encodeHtml (md.value);
														}
														comma = ", ";
													} );
												} else {
													try {
														content += encodeHtml( dm[ key ].toString() );
													} catch ( Exception ) { }
												}
											}
										}
										if ( d.container.length > 0 ) {
											content += "<br><u>{t}Contenants :{/t}</u> ";
											d.container.forEach( function ( dc ) {
												content += "<br>" + encodeHtml( dc.uid.toString() ) + " " + encodeHtml( dc.identifier ) + " <i>" + encodeHtml( dc.container_type_name ) + "</i>";
											} );
										}
										if ( d.events.length > 0 ) {
											content += "<br><u>{t}Événements :{/t}</u> ";
											d.events.forEach( function ( dc ) {
												content += "<br>" + encodeHtml( dc.event_type_name ) + "{t} : {/t}" + encodeHtml( dc.event_date );
											} );
										}
										tooltipContent = content;
										tooltipDisplay( objet );
									}
								}
							} );
					}
				}
			}, delay );

		} ).mouseleave( function () {
			clearTimeout( timer );
			if($(this).is(':ui-tooltip')) {
				$(this).tooltip("close");
			}
		} );
		function tooltipDisplay( object ) {
			object.tooltip( {
				content: tooltipContent,
			} );
			object.attr( "title", tooltipContent );
			object.tooltip( "open" );
		}
		/**
		 * Add the search on columns headers
		 */
		if (searchByColumn == 1) {
			$( '#sampleList thead th' ).each( function () {
				var title = $( this ).text();
				var size = title.trim().length;
				if ( size > 0 ) {
					$( this ).html( '<input type="text" placeholder="' + title + '" size="' + size + '" class="searchInput" title="'+title+'">' );
				}
			} );
			tableList.columns().every( function () {
				var that = this;
				if ( that.index() > 0 ) {
					$( 'input', this.header() ).on( 'keyup change clear', function () {
						if ( that.search() !== this.value ) {
							that.search( this.value ).draw();
						}
					} );
				}
			} );
			$( ".searchInput" ).hover( function () {
				$( this ).focus();
			} );
		}
		/**
		 * Search container for movement creation
		 */
		function searchType() {
			var family = $( "#container_family_id" ).val();
			var url = "containerTypeGetFromFamily";
			$.getJSON( url, { "container_family_id": family }, function ( data ) {
				if ( data != null ) {
					options = '<option value="" selected>{t}Choisissez...{/t}</option>';
					for ( var i = 0; i < data.length; i++ ) {
						if ( data[ i ].container_type_id ) {
							options += '<option value="' + data[ i ].container_type_id + '"';
							options += '>' + data[ i ].container_type_name + '</option>';
						};
					}
					$( "#container_type_id" ).html( options );
				}
			} );
		}
		function searchContainer() {
			var containerType = $( "#container_type_id" ).val();
			var url = "containerGetFromType";
			$.getJSON( url, {  "container_type_id": containerType }, function ( data ) {
				if ( data != null ) {
					options = '';
					for ( var i = 0; i < data.length; i++ ) {
						options += '<option value="' + data[ i ].container_id + '"';
						if ( i == 0 ) {
							options += ' selected ';
							$( "#container_id" ).val( data[ i ].container_id );
							$( "#container_uidChange" ).val( data[ i ].uid );
						}
						options += '>' + data[ i ].uid + " " + data[ i ].identifier + " (" + data[ i ].object_status_name + ")</option>";
					}
					$( "#containersSample" ).html( options );
				}
			} );
		}
		function getTypeEvents() {
			var col_id = $("#collection_id").val();
			if (col_id > 0) {
				var url="eventTypeGetAjax";
				$.getJSON( url, { "object_type": "1", "collection_id" : col_id }, function ( data ) {
				if ( data != null ) {
					options = '';
					for ( var i = 0; i < data.length; i++ ) {
						if ( data[ i ].event_type_id ) {
							options += '<option value="' + data[ i ].event_type_id + '"';
							options += '>' + data[ i ].event_type_name + '</option>';
						};
					}
					$( "#eventsType" ).html( options );
				}
			} );
			}
		}
		$( "#containersSample" ).change( function () {
			var id = $( "#containersSample" ).val();
			$( "#container_id" ).val( id );
			var texte = $( "#containersSample option:selected" ).text();
			var a_texte = texte.split( " " );
			$( "#container_uidChange" ).val( a_texte[ 0 ] );
		} );
		$( "#container_uidChange" ).change( function () {
			var url = "containerGetFromUid";
			var uid = $( this ).val();
			$.getJSON( url, {  "uid": uid }, function ( data ) {
				if ( data.container_id ) {
					var options = '<option value="' + data.container_id + '" selected>' + data.uid + " " + data.identifier + " (" + data.object_status_name + ")</option>";
					$( "#container_id" ).val( data.container_id );
					$( "#containersSample" ).html( options );
				}
			} );
		} );
		$( "#container_family_id" ).change( function () {
			searchType();
		} );
		$( "#container_type_id" ).change( function () {
			searchContainer();
		} );
		/*$("#collection_id").change ( function () {
            getTypeEvents();
        });*/
		/*
		* Search from parent
		*/
		$("#parent_search").on("focusout", function() {
			var chaine = $("#parent_search").val();
			if (chaine.length > 0) {
				var url = "sampleSearchAjax";
				var is_container = 2;
				var sample_id = $("#sample_id").val();
				var collection = "";
				var type = "";
				$.ajax ( { url:url, method:"GET", data : { name:chaine, uidsearch:chaine }, success : function ( djs ) {
					var options = "";
					try {
						var data = JSON.parse(djs);
						for (var i = 0; i < data.length; i++) {
							if (sample_id != data[i].sample_id) {
								options += '<option value="' + data[i].sample_id +'">' + data[i].uid + "-" + data[i].identifier+"</option>";
								if (i == 0) {
									collection = data[0].collection_name;
									type = data[0].sample_type_name;
									parent_uid = data[0].uid;
								}
							}
						}
					} catch (error) {}
					$("#parent_sample_id").html(options);
					}
				});
			}
		});
		/**
		 * Add children
		 */
		 $(".plus").click(function() { 
			var objet = $(this);
			addChildren(objet);
		 });
		function addChildren(objet) {
			var uid = objet.data( "uid" );
			var url = "sampleGetChildren";
			var data = { "uid": uid };
			objet.hide();
			var id = objet.attr('id');
			$.ajax( { url: url, data: data } )
				.done( function ( d ) {
					if ( d ) {
						samples = JSON.parse( d );
						var table = $("#sampleList").DataTable();
						for (var lst = 0; lst < samples.length; lst++) {
							var row = "";
							if (isGestion == 1) {
								row += '<td class="center"> <input type="checkbox" class="checkSample" name="uids[]" value="' + samples[lst].uid +'"></td>';
							}
							row += '<td class="text-center">';
							row += '<a href="sampleDisplay?uid='+samples[lst].uid+'" title="{t}Consultez le détail{/t}">';
							row += samples[lst].uid;
							row += '</a>';
							var localId = parseFloat(9000000) + parseFloat( samples[lst].uid);
							if (samples[lst].nb_derivated_sample > 0) {
								row += '<img class="plus hover" id="' + id + '-' + localId.toString() +'"';
								row += 'data-uid="'+ samples[lst].uid + '" src="display/images/plus.png" height="10">';
							}
							row += '</td>';
							row += '<td class="sample nowrap" data-uid="'+samples[lst].uid+'" title="">';
							row += '<a class="tooltiplink" href="sampleDisplay?uid='+samples[lst].uid+'" title="">';
							row += samples[lst].identifier;
							row += '</a>';
							row += '</td>';
							row += '<td class="nowrap"> '+ samples[lst].identifiers;
							if (samples[lst].dbuid_origin.length > 0) {
								if (samples[lst].identifiers.length > 0) {
									row += '<br>';
								}
								row += "<span title='{t}UID de la base de données d'origine{/t}''>" + samples[lst].dbuid_origin + '</span>';
							}
							row += '</td>';
							row += '<td class="nowrap">'+samples[lst].collection_name+'</td>';
							row += '<td class="nowrap">'+samples[lst].sample_type_name+'</td>';
							row += '<td';
							if (samples[lst].trashed==1) {
								row += 'class="trashed" title="{t}Échantillon mis à la corbeille{/t}"';
							}
							row += '>';
							row += samples[lst].object_status_name+'</td>';
							row += '<td class="nowrap">';
							if (samples[lst].parent_uid.length > 0) {
								row += '<a class="sample" data-uid="'+samples[lst].parent_uid+'"';
								row += 'href="sampleDisplay?uid='+samples[lst].parent_uid+'">';
								row += '<span class="tooltiplink">'+samples[lst].parent_uid+'&nbsp;'+samples[lst].parent_identifier+'</span>';
								row += '</a>';
							}
							row += '</td>';
							row += '<td class="center">';
							if (samples[lst].document_id > 0){
								row += '<a class="image-popup-no-margins"';
								row += 'href="documentGet?document_id='+samples[lst].document_id+'&attached=0&phototype=1" title="{t}aperçu de la photo{/t}">';
								row += ' <img src="documentGet?document_id='+samples[lst].document_id+'&attached=0&phototype=2" height="30">';
								row += '</a>';
							}
							row += '</td>';
							row += '<td class="nowrap">';
							if (samples[lst].movement_date.length > 0 ) {
								if (samples[lst].movement_type_id == 1) {
									row += '<span class="green">';
								} else {
									row += '<span class="red">';
								}
								row += samples[lst].movement_date;
								row += '</span>';
							}
							row += '</td>';
							row += '<td class="nowrap">';
							if (samples[lst].container_uid > 0) {
								row += '<a href="containerDisplay?uid='+samples[lst].container_uid+'">';
								row += samples[lst].container_identifier;
								row += '</a>';
								row += '<br>{t}col:{/t}'+samples[lst].column_number+' {t}ligne:{/t}'+samples[lst].line_number;
							}
							row += '</td>';
							row += '<td class="nowrap">' + samples[lst].storage_condition_name + '</td>';
							row += '<td class="nowrap">'+samples[lst].referent_name + ' ' + samples[lst].referent_firstname + '</td>';
							row += '<td class="nowrap">'+samples[lst].campaign_name + '</td>';
							row += '<td class="nowrap">'+samples[lst].sampling_place_name+'</td>';
							row += '<td class="nowrap">'+samples[lst].sampling_date+'</td>';
							row += '<td class="nowrap">'+samples[lst].sample_creation_date+'</td>';
							row += '<td class="nowrap">'+samples[lst].expiration_date+'</td>';
							row += '<td>'+samples[lst].subsample_quantity+'</td>';
							row += '<td>';
							if (metadatafilter.length > 0) {
								row += samples[lst].metadata;
							} else {
								var l = 0;
								var metadata =  samples[lst].metadata_array;
								for (const meta in metadata) {
									if (l > 0) {
										row += '<br>';
									}
									l ++;
									row += meta+':';
									if (Array.isArray(metadata[meta])) {
										const iterator = metadata[meta].values();
										for (const item of iterator){
											if (item) {
											row += item + '&nbsp;';
											}
										}
									} else {
										row += metadata[meta];
									}
								}
							}
							row += '</td>';
							row += '<td class="textareaDisplay">'+samples[lst].object_comment+'</td>'; 
							row += '<td>'+ id + '-' + (9000000 + parseFloat(samples[lst].uid))+'</td>';
							var jRow = $('<tr>').append(row);
							table.row.add(jRow);
							$(document).on ("click", "#"+ id + '-' + localId.toString(),function() {
								addChildren($(this));
							})
						}
						table.order([[maxcol, 'asc']]).draw();
					}
				});
		};
	});
	
</script>
<div class="col-lg-12">
{include file="gestion/displayPhotoScript.tpl"}
	<form method="POST" id="sampleFormListPrint" target="_blank" action="samplePrintLabel" enctype="multipart/form-data">
		<input type="hidden" id="moduleFrom" name="moduleFrom" value="{$moduleFrom}">
		<input type="hidden" id="containerUid" name="containerUid" value="{$containerUid}">
		{if $rights.manage == 1}
		<div class="row">
			<div class="center">
				<label id="lsamplecheck" for="checkSample">{t}Tout cocher{/t}</label>
				<input type="checkbox" id="checkSample1" class="checkSampleSelect checkSample">
				<select id="labels" name="label_id">
					<option value="" {if $label_id=="" }selected{/if}>{t}Étiquette par défaut{/t}</option>
					{section name=lst loop=$labels}
					<option value="{$labels[lst].label_id}" {if $labels[lst].label_id==$label_id}selected{/if}>
						{$labels[lst].label_name}
					</option>
					{/section}
				</select>
				<button id="samplelabels" class="btn btn-primary">{t}Étiquettes{/t}</button>
				<img id="sampleSpinner" src="display/images/spinner.gif" height="25">

				{if !empty($printers)}
				<select id="printers" name="printer_id">
					{section name=lst loop=$printers}
					<option value="{$printers[lst].printer_id}">
						{$printers[lst].printer_name}
					</option>
					{/section}
				</select>
				<button id="sampledirect" class="btn btn-primary">{t}Impression directe{/t}</button>
				{/if}
				<button id="samplecsvfile" class="btn btn-primary">{t}Fichier CSV pour impression externe{/t}</button>
				{if $rights["manage"] == 1}
				<button id="sampleExport" class="btn btn-primary"
					title="{t}Export pour import dans une autre base Collec-Science{/t}">
					{t}Export vers autre base{/t}</button>
				{/if}
			</div>
		</div>
		{/if}
		<div class="row">
			<div class="col-md-12">
				<table id="sampleList" class="table table-bordered table-hover display" title="{t}Liste des échantillons{/t}">
					<thead class="nowrap">
						<tr>{if $rights.manage == 1}
							<th class="center">
								<input type="checkbox" id="checkSample2" class="checkSampleSelect checkSample">
							</th>
							{/if}
							<th>{t}UID{/t}</th>
							<th>{t}Identifiant ou nom{/t}</th>
							<th>{t}Autres identifiants{/t}</th>
							<th class="d-none d-lg-table-cell">{t}Collection{/t}</th>
							<th>{t}Type{/t}</th>
							<th>{t}Statut{/t}</th>
							<th>{t}Parent{/t}</th>
							<th>{t}Photo{/t}</th>
							<th>{t}Dernier mouvement{/t}</th>
							<th>{t}Emplacement{/t}</th>
							<th>{t}Condition de stockage{/t}</th>
							<th>{t}Référent{/t}</th>
							<th>{t}Campagne{/t}</th>
							<th>{t}Lieu de prélèvement{/t}</th>
							<th>{t}Date d'échantillonnage{/t}</th>
							<th>{t}Date de création dans la base{/t}</th>
							<th>{t}Date d'expiration{/t}</th>
							<th>{t}Quantité restante{/t}</th>
							<th>{t}Métadonnées{/t}&nbsp;{$sampleSearch.metadatafilter}</th>
							<th>{t}Commentaires{/t}</th>
							<th>{t}Tri technique{/t}</th>
						</tr>
					</thead>
					<tbody>
						{section name=lst loop=$samples}
						<tr>
							{if $rights.manage == 1}
							<td class="center">
								<input type="checkbox" class="checkSample" name="uids[]" value="{$samples[lst].uid}">
							</td>
							{/if}
							<td class="text-center">
								<a href="sampleDisplay?uid={$samples[lst].uid}" title="{t}Consultez le détail{/t}">
									{$samples[lst].uid}
								</a>
								{if $samples[lst].nb_derivated_sample > -1}
								<img class="plus hover" id="{$samples[lst].uid + 9000000}" data-uid="{$samples[lst].uid}" src="display/images/plus.png" height="15">
								{/if}
							</td>
							<td class="sample nowrap" data-uid="{$samples[lst].uid}" title="">
								<a class="tooltiplink" href="sampleDisplay?uid={$samples[lst].uid}" title="">
									{$samples[lst].identifier}
								</a>
							</td>
							<td class="nowrap">{$samples[lst].identifiers}
								{if strlen($samples[lst].dbuid_origin) > 0}
								{if strlen($samples[lst].identifiers) > 0}<br>{/if}
								<span title="{t}UID de la base de données d'origine{/t}">{$samples[lst].dbuid_origin}</span>
								{/if}
							</td>
							<td class="nowrap">{$samples[lst].collection_name}</td>
							<td class="nowrap">{$samples[lst].sample_type_name}</td>
							<td {if $samples[lst].trashed==1}class="trashed" title="{t}Échantillon mis à la corbeille{/t}" {/if}>
								{$samples[lst].object_status_name}</td>
							<td>
								{if strlen($samples[lst].parent_uid) > 0}
								<span class="nowrap">
									<a class="sample" data-uid="{$samples[lst].parent_uid}"
										href="sampleDisplay?uid={$samples[lst].parent_uid}">
										<span class="tooltiplink">{$samples[lst].parent_uid}&nbsp;{$samples[lst].parent_identifier}</span>
									</a>
								</span>
								{/if}
								{if strlen($samples[lst].sample_parents) > 0}
								{$samples[lst].sample_parents}
								{/if}
							</td>
							<td class="center">{if $samples[lst].document_id > 0} <a class="image-popup-no-margins"
									href="documentGet?document_id={$samples[lst].document_id}&attached=0&phototype=1"
									title="{t}aperçu de la photo{/t}"> <img
										src="documentGet?document_id={$samples[lst].document_id}&attached=0&phototype=2"
										height="30">
								</a> {/if}
							</td>
							<td class="nowrap">
								{if strlen($samples[lst].movement_date) > 0 }
								{if $samples[lst].movement_type_id == 1}
								<span class="green">{else}
									<span class="red">
										{/if}
										{$samples[lst].movement_date}
									</span>
									{/if}
							</td>
							<td class="nowrap">
								{if $samples[lst].container_uid > 0}
								<a href="containerDisplay?uid={$samples[lst].container_uid}">
									{$samples[lst].container_identifier}
								</a>
								<br>{t}col:{/t}{$samples[lst].column_number} {t}ligne:{/t}{$samples[lst].line_number}
								{/if}
							</td>
							<td>{$samples[lst].storage_condition_name}</td>
							<td class="nowrap">{$samples[lst].referent_name} {$samples[lst].referent_firstname}</td>
							<td class="nowrap">{$samples[lst].campaign_name}</td>
							<td class="nowrap">{$samples[lst].sampling_place_name}</td>
							<td class="nowrap">{$samples[lst].sampling_date}</td>
							<td class="nowrap">{$samples[lst].sample_creation_date}</td>
							<td class="nowrap">{$samples[lst].expiration_date}</td>
							<td>{$samples[lst].subsample_quantity}</td>
							<td>
								{if empty($sampleSearch.metadatafilter)}
								{$l = 0}
								{foreach $samples[lst].metadata_array as $k => $v}
									{if $l > 0}<br>{/if}
									{$l = $l+1}
									{$k}:
									{if is_array($v)}
										{foreach $v as $val}
											{$val}&nbsp;
										{/foreach}
									{else}
										{$v}
									{/if}
								{/foreach}
								{else}
								{$samples[lst].metadata}
								{/if}
							</td>
							<td class="textareaDisplay">{$samples[lst].object_comment}</td>
							<td>{$samples[lst].uid + 9000000}</td>
							
						</tr>
						{/section}
					</tbody>
				</table>
			</div>
		</div>


		<!-- form at the bottom of the list-->
		{if $rights.collection == 1}
		<div class="row">
			<div class="col-md-6 form-horizontal">
				{t}Pour les éléments cochés :{/t}
				<input type="hidden" name="lastModule" value="{$lastModule}">
				<input type="hidden" name="uid" value="{$data.uid}">
				<input type="hidden" name="collection_id" value="{$sampleSearch.collection_id}">
				<input type="hidden" name="is_action" value="1">
				<select id="checkedActionSample" class="form-control">
					<option value="" selected>{t}Choisissez{/t}</option>
					<option value="samplesAssignReferent">{t}Assigner un référent aux échantillons{/t}</option>
					<option value="samplesCreateEvent">{t}Créer un événement{/t}</option>
					<option value="samplesLending">{t}Prêter les échantillons{/t}</option>
					<option value="samplesExit">{t}Sortir les échantillons{/t}</option>
					<option value="lotCreate" {if $sampleSearch.collection_id == 0}disabled{/if}>{t}Créer un lot d'export{/t}</option>
					<option value="samplesSetCountry">{t}Affecter un pays de collecte{/t}</option>
					<option value="samplesSetCampaign">{t}Attacher à une campagne de prélèvement{/t}</option>
					<option value="samplesSetStatus">{t}Modifier le statut{/t}</option>
					<option value="samplesEntry">{t}Entrer ou déplacer les échantillons au même emplacement{/t}</option>
					<option value="samplesSetCollection">{t}Modifier la collection d'affectation{/t}</option>
					<option value="samplesSetParent">{t}Assigner un parent aux échantillons{/t}</option>
					<option value="samplesCreateComposite">{t}Créer un échantillon composé à partir des échantillons sélectionnés{/t}</option>
					<option value="samplesSetTrashed">{t}Mettre ou sortir de la corbeille{/t}</option>
					<option value="samplesDelete">{t}Supprimer les échantillons{/t}</option>
					<option value="samplesDeleteWithChildren">{t}Supprimer les échantillons et tous les échantillons dérivés{/t}</option>
					<option value="samplesDocument">{t}Ajouter les mêmes documents aux échantillons{/t}</option>
				</select>
				<div class="referentid" hidden>
					<select id="referentid" name="referent_id" class="form-control">
						<option value="">{t}Choisissez le référent...{/t}</option>
						{foreach $referents as $referent}
						<option value="{$referent.referent_id}">
							{$referent.referent_name}
						</option>
						{/foreach}
					</select>
				</div>
				<!-- Ajout d'un nouvel evenement-->
				<div class="event" hidden>
					<div class="form-group">
						<label for="due_date" class="control-label col-md-4">{t}Date d'échéance :{/t}</label>
						<div class="col-md-8">
						<input id="due_date" name="due_date" value="" class="form-control datepicker" >
						</div>
						</div>
					<div class="form-group ">
						<label for="event_date" class="control-label col-md-4">{t}Date{/t} :</label>
						<div class="col-md-8">
							<input id="event_date" name="event_date" value="" class="form-control datepicker">
						</div>
					</div>
					<div class="form-group ">
						<label for="eventsType" class="control-label col-md-4"><span class="red">*</span> {t}Type d'événement :{/t}</label>
						<div class="col-md-8">
							<select id="eventsType" name="event_type_id" class="form-control">
								{section name=lst loop=$eventType}
								<option value="{$eventType[lst].event_type_id}">
									{$eventType[lst].event_type_name}
								</option>
								{/section}
							</select>
						</div>
					</div>
					<div class="form-group ">
						<label for="event_comment" class="control-label col-md-4">{t}Commentaire :{/t}</label>
						<div class="col-md-8">
							<textarea id="event_comment" name="event_comment" class="form-control" rows="3"></textarea>
						</div>
					</div>
				</div>
				<!-- add a borrowing -->
				<div class="borrowing" hidden>
					<div class="form-group ">
						<label for="borrower_id" class="control-label col-md-4">
							<span class="red">*</span>{t}Emprunteur :{/t}
						</label>
						<div class="col-md-8">
							<select id="borrower_id" name="borrower_id" class="form-control">
								{foreach $borrowers as $borrower}
								<option value="{$borrower.borrower_id}">
									{$borrower.borrower_name}
								</option>
								{/foreach}
							</select>
						</div>
					</div>
					<div class="form-group ">
						<label for="borrowing_date" class="control-label col-md-4"><span class="red">*</span>{t}Date d'emprunt :{/t}</label>
						<div class="col-md-8">
							<input id="borrowing_date" name="borrowing_date" value="{$borrowing_date}" class="form-control datepicker">
						</div>
					</div>
					<div class="form-group ">
						<label for="expected_return_date" class="control-label col-md-4">{t}Date de retour escomptée :{/t}</label>
						<div class="col-md-8">
							<input id="expected_return_date" name="expected_return_date" value="{$expected_return_date}"
								class="form-control datepicker">
						</div>
					</div>
				</div>
				<!-- set Trashed-->
				<div class="trashedgroupsample" hidden>
					<div class="form-group ">
						<label for="trashed" class="control-label col-md-4">{t}Traitement de la corbeille{/t}</label>
						<div class="col-md-8">
							<select class="form-control" name="settrashed" id="trashedbin">
								<option value="1">{t}Mettre à la corbeille{/t}</option>
								<option value="0">{t}Sortir de la corbeille{/t}</option>
							</select>
						</div>
					</div>
				</div>
				<!-- create an entry movement -->
				<script>
					$(document).ready(function() {
						$(".slotFull").change (function () { 
							var uid = $("#container_uidChange").val();
							var line = $("#line_number").val();
							var column = $("#column_number").val();
							if (uid > 0 && line > 0 && column > 0) {
								$.getJSON( 
									"containerIsSlotFull", 
									{  "uid": uid,
										"line": line,
										"column": column
									}, 
									function ( data ) {
										if (data != null) {
											var res = data["isFull"];
											if (res == 1) {
												alert("{t}Cet emplacement dans le contenant est plein !{/t}");
											}
										}
									}
								);
							}
						});
					});
				</script>
				<div class="entry" hidden>
					<div class="form-group ">
						<label for="container_uidChange" class="control-label col-md-4"><span class="red">*</span> {t}UID du contenant :{/t}</label>
						<div class="col-md-8">
							<input id="container_uidChange" name="container_uid" value="" type="number" class="form-control slotFull">
						</div>
					</div>
					<div class="form-group ">
						<label for="container_family_id" class="control-label col-md-4">{t}ou recherchez :{/t}</label>
						<div class="col-md-8">
							<select id="container_family_id" name="container_family_id" class="form-control">
								<option value="" selected>{t}Sélectionnez la famille...{/t}</option>
								{section name=lst loop=$containerFamily}
								<option value="{$containerFamily[lst].container_family_id}">
									{$containerFamily[lst].container_family_name}
								</option>
								{/section}
							</select>
							<select id="container_type_id" name="container_type_id" class="form-control">
								<option value=""></option>
							</select>
							<select id="containersSample" name="containers" class="form-control">
								<option value=""></option>
							</select>
						</div>
					</div>
					<div class="form-group ">
						<label for="storage_location" class="control-label col-md-4">
							{t}Emplacement dans le contenant (format libre) :{/t}
						</label>
						<div class="col-md-8">
							<input id="storage_location" name="storage_location" value="{$data.storage_location}" type="text"
								class="form-control">
						</div>
					</div>
					<div class="form-group ">
						<label for="line_number" class="control-label col-sm-4">{t}N° de ligne :{/t}</label>
						<div class="col-sm-8">
							<input id="line_number" name="line_number" value="" class="form-control nombre slotFull"
								title="{t}N° de la ligne de rangement dans le contenant{/t}">
						</div>
					</div>
					<div class="form-group ">
						<label for="column_number" class="control-label col-sm-4">{t}N° de colonne :{/t}</label>
						<div class="col-sm-8">
							<input id="column_number" name="column_number" value="" class="form-control nombre slotFull"
								title="{t}N° de la colonne de rangement dans le contenant{/t}">
						</div>
					</div>
				</div>
				<!-- set country -->
				<div class="country" hidden>
					<div class="form-group ">
						<label for="country_id" class="control-label col-sm-4">{t}Pays :{/t}</label>
						<div class="col-sm-8">
							<select id="country_id" name="country_id" class="form-control">
								<option value="0" {if $country.country_id=="0" }selected{/if}>{t}Choisissez...{/t}</option>
								{section name=lst loop=$countries}
								<option value="{$countries[lst].country_id}">
									{$countries[lst].country_name}
								</option>
								{/section}
							</select>
						</div>
					</div>
				</div>
				<!-- set collection-->
				<div class="collection" hidden>
					<div class="form-group ">
						<label for="collection_id_change" class="control-label col-sm-4">{t}Nouvelle collection :{/t}</label>
						<div class="col-sm-8">
							<select id="collection_id_change" name="collection_id_change" class="form-control">
								<option value="" selected>{t}Choisissez...{/t}</option>
								{foreach $collections as $collection}
								<option value="{$collection.collection_id}">
									{$collection.collection_name}
								</option>
								{/foreach}
							</select>
						</div>
					</div>
				</div>
				<!-- set campaign -->
				<div class="campaign" hidden>
					<div class="form-group ">
						<label for="campaign_id_change" class="control-label col-sm-4">{t}Nouvelle campagne :{/t}</label>
						<div class="col-sm-8">
							<select id="campaign_id_change" name="campaign_id" class="form-control">
								<option value="" selected>{t}Choisissez...{/t}</option>
								{foreach $campaigns as $campaign}
								<option value="{$campaign.campaign_id}">{$campaign.campaign_name}</option>
								{/foreach}
							</select>
						</div>
					</div>
				</div>
				<!-- set status -->
				<div class="status" hidden>
					<div class="form-group ">
						<label for="object_status_id" class="col-sm-4 control-label">{t}Statut :{/t}</label>
						<div class="col-sm-8">
							<select id="object_status_id" name="object_status_id" class="form-control">
								<option value="" selected>{t}Choisissez...{/t}</option>
								{foreach $objectStatus as $status}
								<option value="{$status.object_status_id}">{$status.object_status_name}</option>
								{/foreach}
							</select>
						</div>
					</div>
				</div>
				<!-- set parent -->
				<div class="parentid" hidden>
					<div class="form-group">
						<label for="parent_search" class="control-label col-sm-4"> {t}Recherchez le parent :{/t}</label>
						<div class="col-sm-6">
							<input id="parent_search" class="form-control" placeholder="{t}UID ou identifiant{/t}">
						</div>
						<div class="col-sm-2">
							<img src="display/images/zoom.png" height="25" title="{t}Chercher{/t}">
						</div>
					</div>
					<div class="form-group">
						<label for="parent_sample_id" class="control-label col-sm-4"> {t}Parent à affecter :{/t}</label>
						<div class="col-sm-8">
							<select id="parent_sample_id" name="parent_sample_id" class="form-control">
							</select>
						</div>
					</div>
				</div>
				<div class="document" hidden>
					<input type="hidden" name="parentKeyName" value="uid">
					<div class="form-group">
						<label for="documentName" class="control-label col-md-4">
							{t 1=$maxUploadSize}Fichier(s) à importer (taille maxi : %1 Mb):{/t} <br>({$extensions})
						</label>
						<div class="col-md-8">
							<input id="documentName" type="file" class="form-control"
								name="documentName[]" multiple>
						</div>
					</div>
					<div class="form-group">
						<label for="documentName" class="control-label col-md-4">
							{t}Description :{/t} </label>
						<div class="col-md-8">
							<input id="document_description" name="document_description" class="form-control">
						</div>
					</div>
					<div class="form-group">
						<label for="document_creation_date" class="control-label col-md-4">
							{t}Date de création du document :{/t} </label>
						<div class="col-md-8">
							<input id="document_creation_date" name="document_creation_date"
								class="form-control date">
						</div>
					</div>
				</div>
				<!-- Create a composite sample-->
				<script>
					$(document).ready(function () {

						function getSampletypeComposite() {
							var collection_id = $("#collection_idComposite").val();
							$.ajax({
								url: "sampleTypeGetListAjax",
								data: { "collection_id": collection_id }
							})
								.done(function (value) {
									d = JSON.parse(value);
									var options = '';
									for (var i = 0; i < d.length; i++) {
										options += '<option value="' + d[i].sample_type_id + '"';
										options += '>' + d[i].sample_type_name;
										if (d[i].multiple_type_id > 0) {
											options += ' / ' + d[i].multiple_type_name + ' : ' + d[i].multiple_unit;
										}
										options += '</option>';
									};
									$("#sample_type_idComposite").html(options);
								});
						}
						function searchSampleComposite() {
							var uid = $("#uidsearchComposite").val();
							var name = $("#namesearchComposite").val();
							var createdsample = "{$data.created_sample_id}";
							var mode = "none";
							var val = "";
							if (uid > 0) {
								mode = "uid";
							} else if (name.length > 3) {
								mode = "name";
							}
							var options = '';
							/**
							 * clean select field
							 */
							$("#createdsample_id").html(options);
							if (mode != "none") {
								$.ajax({
									url: "sampleSearchAjax",
									data: {
										uidsearch: uid,
										name: name
									}
								}).done(function (value) {
				
									d = JSON.parse(value);
									if (d.length > 0) {
										for (var i = 0; i < d.length; i++) {
											options += '<option value="' + d[i].uid + '"' + '>';
											options += d[i].uid + " " + d[i].identifier;
											options += '</option>';
										}
										$("#uidComposite").html(options);
										$(".tocreate").prop("disabled", true);
									} else {
										$(".tocreate").prop("disabled", false);
									}
								});
							}
						}
						$("#collection_idComposite").change(function () {
							getSampletypeComposite();
						});
						/**
						 * Search for existent sample
						 */
						$("#uidsearchComposite").change(function () {
							searchSampleComposite();
						});
						$("#namesearchComposite").change(function () {
							searchSampleComposite();
						});
						getSampletypeComposite();
					});
				</script>
				<div class="createComposite" hidden>
					<div class="form-group">
						<label for="subsample_quantity" class="control-label col-md-4"><span class="red">*</span>
							{t}Quantité à retirer de chacun des échantillons sélectionnés :{/t}
						</label>
						<div class="col-md-8">
							<input id="subsample_quantity" name="subsample_quantity" value="{$data.subsample_quantity}"
								class="form-control taux">
						</div>
					</div>
					<div class="form-group">
						<label for="identifierComposite" class="control-label col-md-4">{t}Identifiant ou nom :{/t}</label>
						<div class="col-md-8">
							<input id="identifierComposite" type="text" name="identifierComposite" class="form-control tocreate">
						</div>
					</div>
					<div class="form-group">
						<label for="collection_idComposite" class="control-label col-md-4"><span class="red">*</span>
							{t}Collection :{/t}</label>
						<div class="col-md-8">
							<select id="collection_idComposite" name="collection_idComposite" class="form-control tocreate" autofocus>
								{foreach $collections as $collection}
								<option value="{$collection.collection_id}" {if $sampleSearch.collection_id == $collection.collection_id}selected{/if}>
									{$collection.collection_name}
								</option>
								{/foreach}
							</select>
						</div>
					</div>
					<div class="form-group">
						<label for="sample_type_idComposite" class="control-label col-md-4"><span class="red">*</span>
							{t}Type :{/t}
						</label>
						<div class="col-md-8">
							<select id="sample_type_idComposite" name="sample_type_idComposite" class="form-control tocreate">
							</select>
						</div>
					</div>
					<div class="form-group">
						<label for="uidsearchComposite" class="col-md-4 control-label">
							{t}Échantillon déjà existant - UID :{/t}</label>
						<div class="col-md-2">
							<input id="uidsearchComposite" name="uidsearchComposite" class="form-control nombre" value="{$data.created_uid}">
						</div>
						<label for="namesearchComposite" class="col-md-2 control-label">
							{t}ou identifiant ou UUID :{/t}
						</label>
						<div class="col-md-3">
							<input id="namesearchComposite" type="text" class="form-control" name="nameComposite"
								title="{t}identifiant principal, identifiants secondaires (p. e. : cab:15), UUID (p. e. : e1b1bdd8-d1e7-4f07-8e96-0d71e7aada2b){/t}">
						</div>
						<div class="col-md-1">
							<img src="display/images/zoom.png" height="25">
						</div>
					</div>
					<div class="form-group">
						<label for="uidComposite" class="col-md-4 control-label">
							{t}Échantillon composé correspondant :{/t}
						</label>
						<div class="col-md-8">
							<select id="uidComposite" name="uidComposite" class="form-control">
							</select>
						</div>
					</div>
					<div class="form-group">
						<label for="multiple_valueComposite" class="control-label col-md-4">
							{t 1=$data.multiple_unit}Quantité à affecter à l'échantillon (en création uniquement):{/t}</label>
						<div class="col-md-8">
							<input id="multiple_valueComposite" class="form-control taux tocreate" name="multiple_valueComposite">
						</div>
					</div>
				</div>

				<div class="center">
					<button id="checkedButtonSample" class="btn btn-danger">{t}Exécuter{/t}</button>
				</div>
			</div>
		</div>
		{/if}
	{$csrf}</form>
</div>
