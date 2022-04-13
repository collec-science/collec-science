<!--  Liste des échantillons pour affichage-->
<script>
	$( document ).ready( function () {
		var table = $( '#sampleList' ).DataTable( {
			dom: 'Birtp',
			"language": dataTableLanguage,
			"paging": false,
			"searching": true,
			"stateSave": true,
			"stateDuration": 60 * 60 * 24 * 30,
			"columnDefs" : [
				{
				"targets": [11,12,13,14,15,16,17,18],
				"visible": false
				}
			],
			"buttons": [
				{
					extend: 'colvis',
					text: '{t}Colonnes affichées{/t}'
				},
				{
					extend: 'csv',
					text: 'csv',
					filename: 'samples',
					exportOptions: {
						columns: [1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17]
					},
					customize: function (csv) {
						var split_csv = csv.split("\n");
						//set headers
						split_csv[0] = '"uid","identifier","other_identifiers","collection","type","status","sample_parent","last_movement","place","referent","campaign","sampling_place","sampling_date","creation_date","expiration_date","available_quantity"';
						csv = split_csv.join("\n");
            return csv;
					}
				},
				{
					extend: 'copy',
					text: '{t}Copier{/t}',
					exportOptions: {
						columns: [1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17]
					},
					customize: function (csv) {
						var split_csv = csv.split("\n");
						//set headers
						split_csv[3] = 'uid\tidentifier\tother_identifiers\tcollection\ttype\tstatus\tsample_parent\tlast_movement\tplace\treferent\tcampaign\tsampling_place\tsampling_date\tcreation_date\texpiration_date\tavailable_quantity';
						split_csv.shift();
						split_csv.shift();
						split_csv.shift();
						csv = split_csv.join("\n");
            return csv;
					}
				}
			]
		} );
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
			$( this.form ).find( "input[name='module']" ).val( "samplePrintLabel" );
			/*$("#sampleSpinner").show();*/
			$( this.form ).prop( 'target', '_blank' ).submit();
		} );
		$( "#sampledirect" ).on( "keypress click", function () {
			$( this.form ).find( "input[name='module']" ).val( "samplePrintDirect" );
			$( "#sampleSpinner" ).show();
			$( this.form ).prop( 'target', '_self' ).submit();
		} );
		$( "#sampleExport" ).on( "keypress click", function () {
			$( this.form ).find( "input[name='module']" ).val( "sampleExport" );
			$( this.form ).prop( 'target', '_self' ).submit();
		} );

		$( "#checkedButtonSample" ).on( "keypress click", function ( event ) {
			var action = $( "#checkedActionSample" ).val();
			if ( action.length > 0 ) {
				var conf = confirm( "{t}Attention : l'opération est définitive. Est-ce bien ce que vous voulez faire ?{/t}" );
				if ( conf == true ) {
					$( this.form ).find( "input[name='module']" ).val( action );
					$( this.form ).prop( 'target', '_self' ).submit();
				} else {
					event.preventDefault();
				}
			} else {
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
			"samplesSetStatus": "status"
		};
		$( "#checkedActionSample" ).change( function () {
			var action = $( this ).val();
			var actionClass = actions[ action ];
			var value;
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
						var url = "index.php";
						var data = { "module": "sampleDetail", "uid": uid };
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
										if ( d.metadata ) {
											content += "<br><u>{t}Métadonnées :{/t}</u>";
											dm = d.metadata;
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
														content += encodeHtml( md ) + " ";
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
		$( '#sampleList thead th' ).each( function () {
			var title = $( this ).text();
			var size = title.trim().length;
			if ( size > 0 ) {
				$( this ).html( '<input type="text" placeholder="' + title + '" size="' + size + '" class="searchInput" title="'+title+'">' );
			}
		} );
		table.columns().every( function () {
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
		/**
		 * Search container for movement creation
		 */
		function searchType() {
			var family = $( "#container_family_id" ).val();
			var url = "index.php";
			$.getJSON( url, { "module": "containerTypeGetFromFamily", "container_family_id": family }, function ( data ) {
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
			var url = "index.php";
			$.getJSON( url, { "module": "containerGetFromType", "container_type_id": containerType }, function ( data ) {
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
		$( "#containersSample" ).change( function () {
			var id = $( "#containersSample" ).val();
			$( "#container_id" ).val( id );
			var texte = $( "#containersSample option:selected" ).text();
			var a_texte = texte.split( " " );
			$( "#container_uidChange" ).val( a_texte[ 0 ] );
		} );
		$( "#container_uidChange" ).change( function () {
			var url = "index.php";
			var uid = $( this ).val();
			$.getJSON( url, { "module": "containerGetFromUid", "uid": uid }, function ( data ) {
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
	} );
</script>
{include file="gestion/displayPhotoScript.tpl"}
{if $droits.gestion == 1}
<form method="POST" id="sampleFormListPrint" action="index.php">
	<input type="hidden" id="module" name="module" value="samplePrintLabel">
	<input type="hidden" id="moduleFrom" name="moduleFrom" value="{$moduleFrom}">
	<input type="hidden" id="containerUid" name="containerUid" value="{$containerUid}">
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

			{if count($printers) > 0}
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
			{if $droits["gestion"] == 1}
			<button id="sampleExport" class="btn btn-primary"
				title="{t}Export pour import dans une autre base Collec-Science{/t}">
				{t}Export vers autre base{/t}</button>
			{/if}
		</div>
	</div>
	{/if}
	<table id="sampleList" class="table table-bordered table-hover " title="{t}Liste des échantillons{/t}">
		<thead>
			<tr>{if $droits.gestion == 1}
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
				<th>{t}Référent{/t}</th>
				<th>{t}Campagne{/t}</th>
				<th>{t}Lieu de prélèvement{/t}</th>
				<th>{t}Date d'échantillonnage{/t}</th>
				<th>{t}Date de création dans la base{/t}</th>
				<th>{t}Date d'expiration{/t}</th>
				<th>{t}Quantité restante{/t}</th>
				<th>{t}Métadonnées{/t}</th>
			</tr>
		</thead>
		<tbody>
			{section name=lst loop=$samples}
			<tr>
				{if $droits.gestion == 1}
				<td class="center">
					<input type="checkbox" class="checkSample" name="uids[]" value="{$samples[lst].uid}">
				</td>
				{/if}
				<td class="text-center">
					<a href="index.php?module=sampleDisplay&uid={$samples[lst].uid}" title="{t}Consultez le détail{/t}">
						{$samples[lst].uid}
					</a>
				</td>
				<td class="sample" data-uid="{$samples[lst].uid}" title="">
					<a class="tooltiplink" href="index.php?module=sampleDisplay&uid={$samples[lst].uid}" title="">
						{$samples[lst].identifier}
					</a>
				</td>
				<td>{$samples[lst].identifiers}
					{if strlen($samples[lst].dbuid_origin) > 0}
					{if strlen($samples[lst].identifiers) > 0}<br>{/if}
					<span title="{t}UID de la base de données d'origine{/t}">{$samples[lst].dbuid_origin}</span>
					{/if}
				</td>
				<td>{$samples[lst].collection_name}</td>
				<td>{$samples[lst].sample_type_name}</td>
				<td {if $samples[lst].trashed==1}class="trashed" title="{t}Échantillon mis à la corbeille{/t}" {/if}>
					{$samples[lst].object_status_name}</td>
				<td>{if strlen($samples[lst].parent_uid) > 0}
					<a class="sample" data-uid="{$samples[lst].parent_uid}"
						href="index.php?module=sampleDisplay&uid={$samples[lst].parent_uid}">
						<span class="tooltiplink">{$samples[lst].parent_uid}&nbsp;{$samples[lst].parent_identifier}</span>
					</a>
					{/if}
				</td>
				<td class="center">{if $samples[lst].document_id > 0} <a class="image-popup-no-margins"
						href="index.php?module=documentGet&document_id={$samples[lst].document_id}&attached=0&phototype=1"
						title="{t}aperçu de la photo{/t}"> <img
							src="index.php?module=documentGet&document_id={$samples[lst].document_id}&attached=0&phototype=2"
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
				<td>
					{if $samples[lst].container_uid > 0}
					<a href="index.php?module=containerDisplay&uid={$samples[lst].container_uid}">
						{$samples[lst].container_identifier}
					</a>
					<br>{t}col:{/t}{$samples[lst].column_number} {t}ligne:{/t}{$samples[lst].line_number}
					{/if}
				</td>
				<td>{$samples[lst].referent_name} {$samples[lst].referent_firstname}</td>
				<td>{$samples[lst].campaign_name}</td>
				<td>{$samples[lst].sampling_place_name}</td>
				<td class="nowrap">{$samples[lst].sampling_date}</td>
				<td class="nowrap">{$samples[lst].sample_creation_date}</td>
				<td class="nowrap">{$samples[lst].expiration_date}</td>
				<td>{$samples[lst].subsample_quantity}</td>
				<td>
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
				</td>
			</tr>
			{/section}
		</tbody>
	</table>
	{if $droits.collection == 1}
	<div class="row">
		<div class="col-md-6 protoform form-horizontal">
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
				<option value="samplesSetTrashed">{t}Mettre ou sortir de la corbeille{/t}</option>
				<option value="samplesDelete">{t}Supprimer les échantillons{/t}</option>
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
				<div class="form-group ">
					<label for="event_date" class="control-label col-md-4"><span class="red">*</span>{t}Date{/t} :</label>
					<div class="col-md-8">
						<input id="event_date" name="event_date" value="" class="form-control datepicker">
					</div>
				</div>
				<div class="form-group ">
					<label for="container_status_id" class="control-label col-md-4"><span class="red">*</span> {t}Type d'événement :{/t}</label>
					<div class="col-md-8">
						<select id="event_type_id" name="event_type_id" class="form-control">
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
			<div class="entry" hidden>
				<div class="form-group ">
					<label for="container_uidChange" class="control-label col-md-4"><span class="red">*</span> {t}UID du contenant :{/t}</label>
					<div class="col-md-8">
						<input id="container_uidChange" name="container_uid" value="" type="number" class="form-control">
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
						<input id="line_number" name="line_number" value="" class="form-control nombre"
							title="{t}N° de la ligne de rangement dans le contenant{/t}">
					</div>
				</div>
				<div class="form-group ">
					<label for="column_number" class="control-label col-sm-4">{t}N° de colonne :{/t}</label>
					<div class="col-sm-8">
						<input id="column_number" name="column_number" value="" class="form-control nombre"
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
			<div class="center">
				<button id="checkedButtonSample" class="btn btn-danger">{t}Exécuter{/t}</button>
			</div>
		</div>
	</div>
</form>
{/if}
