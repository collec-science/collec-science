<!-- Liste des containers pour affichage -->
<script>
$(document).ready(function () {
	var gestion = "{$rights.manage}";
	var dataOrder = [0, 'asc'];
	if (gestion == 1) {
		dataOrder = [1, 'asc'];
	}
	var myStorageContainer = window.localStorage;
	var maxcol = 15;
	try {
		var hb = JSON.parse(myStorageContainer.getItem("sampleSearchColumns"));
		if (hb.length == 0) {
			if (gestion == 1) {
				hb = [16];
			} else {
				hb = [15];
			}
		}
	} catch {
		if (gestion == 1) {
				var hb = [16];
			} else {
				var hb = [15];
			}
	}
	if (gestion == 1) {
		maxcol = 16;
	}
	/*var lengthMenu = [10, 25, 50, 100, 500, { label:'all',value: -1}];
	var pageLength = 10;
		try {
			pageLength = myStorageSample.getItem("containerPageLength");
			if (pageLength == -1) {
				pageLength = 10;
			} 
		} catch (Exception) {
		}*/
	var table = $("#containerList").DataTable( {
			//dom: 'Bfrtip',
			"language": dataTableLanguage,
			"paging": false,
			"searching": true,
			"stateSave": true,
			//"scrollY":"50vh",
			"scrollX":true,
			fixedHeader: {
            header: true,
            footer: true
        	},
			layout: {
                topStart: {
                    buttons: [
						//'pageLength',
						{
							extend: 'colvis',
							text: '{t}Colonnes affichées{/t}'
						},
						'copyHtml5',
						'excelHtml5',
						'csvHtml5',
						'pdfHtml5',
						'print'
					]
                }
            },
			//"lengthMenu": lengthMenu,
			//pageLength: pageLength
		} );
	/*table.on('length.dt', function (e, settings, len) {
		if (len > -1) {
			myStorage.setItem('containerPageLength', len);
		}
	});*/
	table.order(dataOrder).draw();
	table.on( 'buttons-action', function ( e, buttonApi, dataTable, node, config ) {
			var hb = [];
			containerList.columns().every(function () {
				if (!this.visible()) {
					hb.push(this.index());
				}
				myStorageContainer.setItem("containerSearchColumns", JSON.stringify(hb));
			});
		} );

	$(".checkContainerSelect").change( function() {
		$('.checkContainer').prop('checked', this.checked);
		var libelle="{t}Tout cocher{/t}";
		if (this.checked) {
			libelle = "{t}Tout décocher{/t}";
		}
		$("#lcheckContainer").text(libelle);
		nbCheckedCount();
	});
	$(".checkContainer").on ("click keypress", function () {
		nbCheckedCount();
	});
	function nbCheckedCount() {
		var nbchecked = $ (".checkContainerList:checked").length;
		var nbCheckedContent = nbchecked + " {t}contenants(s) sélectionné(s){/t}";
		$("#nbContainerChecked").html(nbCheckedContent);
	}
	$('#containercsvfile').on('keypress click',function() {
		//$(this.form).find("input[name='module']").val("containerExportCSV");
		$(this.form).attr("action", "containerExportCSV");
		$(this.form).prop('target', '_self').submit();
	});
	$("#containerlabels").on('click keypress', function() {
		//$(this.form).find("input[name='module']").val("containerPrintLabel");
		$(this.form).attr("action", "containerPrintLabel");
		$(this.form).prop('target', '_self').submit();
	});
	$("#containerdirect").on('keypress click', function() {
		//$(this.form).find("input[name='module']").val("containerPrintDirect");
		$(this.form).attr("action", "containerPrintDirect");
		$(this.form).prop('target', '_self').submit();
	});
	$("#containerExport").on("keypress click", function () {
		//$(this.form).find("input[name='module']").val("containerExportGlobal");
		$(this.form).attr("action", "containerExportGlobal");
		$(this.form).prop('target', '_self').submit();
	});
	$("#checkedButtonContainer").on ("keypress click", function(event) {
		var action = $("#checkedActionContainer").val();
		if (action.length > 0) {
			var conf = confirm("{t}Attention : cette opération est définitive. Est-ce bien ce que vous voulez faire ?{/t}");
			if ( conf  == true) {
				$(this.form).find("input[name='module']").val(action);
				$(this.form).prop('target', '_self').submit();
			} else {
				event.preventDefault();
			}
		} else {
			event.preventDefault();
		}
	});
	/**
		 * Actions for the list of containers
		 */
		 var actions = {
			"containersLending":"borrowing",
			"containersSetTrashed":"trashedgroup",
			"containersEntry":"entry",
			"containersSetStatus":"status",
			"containersSetReferent":"referent",
			"containersSetCollection":"collection",
			"containersExit":"containersExit",
			"containersDelete":"containersDelete"
			};
		$("#checkedActionContainer").change(function () {
			var action = $(this).val();
			var actionClass = actions[action];
			var value;
				for (const key in actions) {
    			if (actions.hasOwnProperty(key)) {
						value = actions[key];
						if ( value == actionClass) {
							$("."+value).show();
							$("#containerFormListPrint").attr("action", action);
						} else {
							$("."+value).hide();
						}
					}
				};
		});
	var tooltipContent ;
	/**
	 * Display the grid of a container
	 */
	var delay=1000, timer;
	$(".container").mouseenter( function () {
		var objet = $(this);
		timer = setTimeout(function () {
			var uid = objet.data("uid");
			if (! objet.is(':ui-tooltip') ) {
				if (uid > 0) {
					var url = "containerGetOccupation";
					var data = { "uid": uid };
					$.ajax ( { url:url, data: data})
					.done (function( d ) {
						if (d ) {
							d = JSON.parse(d);
							if (!d.error_code) {
								/* Create the grid */
								var lineNumber = parseInt(d.lineNumber);
								var columnNumber = parseInt(d.columnNumber);
								var lines = d.lines;
								var firstLine = d.firstLine;
								var firstColumn = d.firstColumn;
								var line_in_char = d.line_in_char;
								var column_in_char = d.column_in_char;
								var ln = 1;
								var incr = 1;
								var cl = 1;
								var clIncr = 1;
								if (firstLine != "T") {
									ln = lineNumber;
									incr = -1;
								}
								if (firstColumn != "L") {
									cl = columnNumber;
									clIncr = -1;
								}
								var content = '<table class="table table-bordered"><tr><th class="center">{t}Ligne/colonne{/t}</th>';
								for (var col = 1 ; col <= columnNumber; col ++) {
									content += '<th class="center">';
									if (column_in_char == 1) {
										content += String.fromCharCode (cl + 64);
									} else {
										content += cl;
									}
									content += '</th>';
									cl = cl + clIncr;
								}
								content += '</tr>';
								var nb = 0;
								lines.forEach(function(line) {
									content += '<tr><td class="center"><b>';
									if (line_in_char == 1) {
										content += String.fromCharCode (ln + 64);
									} else {
										content += ln;
									}
									content += '</b></td>';
                	ln = ln + incr;
									line.forEach(function (cell) {
										nb = 0;
										content += '<td class="center">';
										if (cell.length > 5) {
											content += cell.length + " {t}objets{/t}";
										} else {
											cell.forEach(function (item) {
												if (parseInt(item.uid) > 0) {
												if (nb > 0) {
													content += "<br>";
												}
												content += item.uid + " " + item.identifier;
												nb ++;
												}
											});
										}
										content += '</td>';
									 });
									 content += '</tr>';
								});
								content += '</table>';
								/* Display */
								tooltipContent = content;
								tooltipDisplay(objet);
							}
						}
					});
				}
			}
		}, delay);

	}).mouseleave(function() {
		clearTimeout (timer);
	});
	function tooltipDisplay(object) {
		object.tooltip ({
			content: tooltipContent
		});
		object.attr("title", tooltipContent);
			object.tooltip("open");
	}
/**
	 * Search container for movement creation
	 */
	 function searchTypes() {
		var family = $("#containers_family_id").val();
		var url = "containerTypeGetFromFamily";
		$.getJSON ( url, {  "container_family_id":family } , function( data ) {
			if (data != null) {
				options = '<option value="" selected>{t}Choisissez...{/t}</option>';
				for (var i = 0; i < data.length; i++) {
					if (data[i].container_type_id ){
						options += '<option value="' + data[i].container_type_id + '"';
						options += '>' + data[i].container_type_name + '</option>';
					};
				}
				$("#containers_type_id").html(options);
				}
			} ) ;
		}
		function searchContainer () {
			var containerType = $("#containers_type_id").val();
			var url = "containerGetFromType";
			$.getJSON ( url, { "container_type_id":containerType } , function( data ) {
				if (data != null) {
				options = '';
				for (var i = 0; i < data.length; i++) {
					options += '<option value="' + data[i].container_id + '"';
					if (i == 0) {
						options += ' selected ';
						$("#container_id").val(data[i].container_id);
						$("#container_uid").val(data[i].uid);
					}
						options += '>' + data[i].uid + " " + data[i].identifier + " ("+data[i].object_status_name + ")</option>";
				}
				$("#containers").html(options);
				}
			});
		}
		$("#containers").change(function() {
			var id = $("#containers").val();
			$("#container_id").val(id);
			var texte = $( "#containers option:selected" ).text();
			var a_texte = texte.split(" ");
			$("#container_uid").val(a_texte[0]);
		});
		$("#container_uid").change(function () {
			var url = "containerGetFromUid";
			var uid = $(this).val();
			if (Number.isInteger(uid)) {
				$.getJSON ( url, { "uid":uid } , function( data ) {
					if (data.container_id ) {
					var options = '<option value="' + data.container_id + '" selected>' + data.uid + " " + data.identifier + " ("+data.object_status_name + ")</option>";
					$("#container_id").val(data.container_id);
					$("#containers").html(options);
					}
				});
			}
	 	});
		$("#containers_family_id").change(function () {
			searchTypes();
	 });
		$("#containers_type_id").change(function () {
			searchContainer();
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
			var url = "containerGetChildren";
			var data = { "uid": uid };
			objet.hide();
			var id = objet.attr('id');
			$.ajax( { url: url, data: data } )
				.done( function ( d ) {
					if ( d ) {
						containers = JSON.parse( d );
						for (var lst = 0; lst < containers.length; lst++) {
							var row = "";
							if (gestion == 1) {
								row += '<td class="center"><input type="checkbox" class="checkContainer" name="uids[]" value="'+containers[lst].uid+'" ></td>';
							}
							row += '<td class="center">';
							row += '<a href="containerDisplay?uid='+containers[lst].uid+'" title="{t}Consultez le détail{/t}">'+ containers[lst].uid + '</a>';
							var localId = parseFloat(9000000) + parseFloat( containers[lst].uid);
								row += '<img class="plus hover" id="' + id + '-' + localId.toString() +'" data-uid="'+containers[lst].uid+'" src="display/images/plus.png" height="15">';
							row += '</td>';
							row += '<td class="container" data-uid="'+containers[lst].uid+'" title="">';
							row += '<a class="tooltiplink"  href="containerDisplay?uid='+containers[lst].uid+'" title="">';
							row += containers[lst].identifier;
							row += '</a></td>';
							row += '<td>'+containers[lst].identifiers+'</td>';	
							row += '<td';
							if (containers[lst].trashed == 't') {
								row += ' class="trashed" title="{t}Contenant mis à la corbeille{/t}"';
							}
							row += '>'+containers[lst].object_status_name+'</td>';
							row += '<td>' +containers[lst].container_family_name + '/'+ containers[lst].container_type_name +'</td>';
							row += '<td class="nowrap">';
							if (containers[lst].movement_date) {
								if (containers[lst].movement_type_id == 1) {
									row += '<span class="green">';
								} else {
									row += '<span class="red">';
								}
								row += containers[lst].movement_date;
								row += '</span>';
							}
							row += '</td>';
							row += '<td>';
							if (containers[lst].container_uid > 0) {
								row += '<a href="containerDisplay?uid='+containers[lst].container_uid+'">'+containers[lst].container_identifier+'</a>';
								row += '<br>{t}col:{/t}'+containers[lst].column_number+' {t}ligne:{/t}'+containers[lst].line_number;
							}
							row += '</td>';
							row += '<td class="center ';
							if (containers[lst].nb_slots_used < containers[lst].nb_slots_max || containers[lst].nb_slots_max == 0) {
								row += 'green';
							} else {
								row += 'red';
							}
							row += '">'+containers[lst].nb_slots_used + '&nbsp;/&nbsp;'+containers[lst].nb_slots_max + '</td>';
							row += '<td>'+containers[lst].storage_condition_name+'</td>';
							row += '<td>'+containers[lst].storage_product+'</td>';
							row += '<td>'+containers[lst].clp_classification+'</td>';
							row += '<td class="center">';
							if (containers[lst].document_id > 0) {
								row += '<a class="image-popup-no-margins" href="documentGet?document_id='+containers[lst].document_id+'&attached=0&phototype=1" title="{t}aperçu de la photo{/t}">';
								row += '<img src="documentGet?document_id='+containers[lst].document_id+'&attached=0&phototype=2" height="30"></a>';
							}
							row += '</td>';
							row += '<td>'+containers[lst].collection_name + '</td>';
							row +='<td>'+containers[lst].referent_name+' ' +containers[lst].referent_firstname + '</td>' ;
							row += '<td class="textareaDisplay">'+containers[lst].object_comment+'</td>';
							row += '<td>'+ id + '-' + (9000000 + parseFloat(containers[lst].uid))+'</td>';
							var jRow = $('<tr>').append(row);
							table.row.add(jRow);
							$(document).on ("click", "#"+ id + '-' + localId.toString(),function() {
								addChildren($(this));
							})
						}
						table.order([[maxcol, 'asc']]).draw();
					}
				});
		}
});
</script>
{include file="gestion/displayPhotoScript.tpl"}
{if $rights.manage == 1}
	<form method="POST" id="containerFormListPrint" action="containerPrintLabel">
		<input type="hidden" name="lastModule" value="{$lastModule}">
		<div class="row">
			<div class="center">
				<label id="lcheckContainer" for="check">{t}Tout cocher{/t}</label>
				<input type="checkbox" id="checkContainer1" class="checkContainerSelect checkContainer" >
				<select id="labels" name="label_id">
					<option value="" {if $label_id == ""}selected{/if}>{t}Étiquette par défaut{/t}</option>
					{section name=lst loop=$labels}
						<option value="{$labels[lst].label_id}" {if $labels[lst].label_id == $label_id}selected{/if}>
							{$labels[lst].label_name}
						</option>
					{/section}
				</select>
				<button id="containerlabels" class="btn btn-primary">{t}Étiquettes{/t}</button>
				<button id="containercsvfile" class="btn btn-primary">{t}Fichier CSV{/t}</button>
				{if count($printers) > 0}
					<select id="printers" name="printer_id">
						{section name=lst loop=$printers}
							<option value="{$printers[lst].printer_id}">
								{$printers[lst].printer_name}
							</option>
						{/section}
					</select>
					<button id="containerdirect" class="btn btn-primary">{t}Impression directe{/t}</button>
				{/if}
				<button id="containerExport" class="btn btn-primary">{t}Export avec objets inclus{/t}</button>
			</div>
		</div>
{/if}
		<table id="containerList" class="table table-bordered table-hover display" >
			<thead class="nowrap">
				<tr>
					{if $rights.manage == 1}
						<th class="center">
							<input type="checkbox" id="checkContainer2" class="checkContainerSelect checkContainer" >
						</th>
					{/if}
					<th>{t}UID{/t}</th>
					<th>{t}Identifiant ou nom{/t}</th>
					<th>{t}Autres identifiants{/t}</th>
					<th>{t}Statut{/t}</th>
					<th>{t}Type{/t}</th>
					<th>{t}Dernier mouvement{/t}</th>
					<th>{t}Emplacement{/t}</th>
					<th>{t}Nbre d'emplacements utilisés/Nbre total{/t}</th>
					<th>{t}Condition de stockage{/t}</th>
					<th>{t}Produit utilisé{/t}</th>
					<th>{t}Code CLP{/t}</th>
					<th>{t}Photo{/t}</th>
					<th>{t}Collection{/t}</th>
					<th>{t}Référent{/t}</th>
					<th>{t}Commentaires{/t}</th>
					<th>{t}Tri technique{/t}</th>
				</tr>
			</thead>
			<tbody class="nowrap">
				{section name=lst loop=$containers}
					<tr>
						{if $rights.manage == 1}
							<td class="center">
								<input type="checkbox" class="checkContainer checkContainerList" name="uids[]" value="{$containers[lst].uid}" >
							</td>
						{/if}
						<td class="center">
							<a href="containerDisplay?uid={$containers[lst].uid}" title="{t}Consultez le détail{/t}">
								{$containers[lst].uid}
							</a>
						<img class="plus hover" id="{$containers[lst].uid + 9000000}" data-uid="{$containers[lst].uid}" src="display/images/plus.png" height="15">
						</td>
						<td class="container" data-uid="{$containers[lst].uid}" title="">
							<a class="tooltiplink"  href="containerDisplay?uid={$containers[lst].uid}" title="">
								{$containers[lst].identifier}
							</a>
						</td>
						<td>{$containers[lst].identifiers}</td>
						<td {if $containers[lst].trashed == 't'}class="trashed" title="{t}Contenant mis à la corbeille{/t}"{/if}>{$containers[lst].object_status_name}</td>
						<td>
							{$containers[lst].container_family_name}/
							{$containers[lst].container_type_name}
						</td>
						<td class="nowrap">
							{if strlen($containers[lst].movement_date) > 0 }
								{if $containers[lst].movement_type_id == 1}
									<span class="green">
								{else}
									<span class="red">
								{/if}
								{$containers[lst].movement_date}
								</span>
							{/if}
						</td>
						<td>
							{if $containers[lst].container_uid > 0}
								<a href="containerDisplay?uid={$containers[lst].container_uid}">
									{$containers[lst].container_identifier}
								</a>
								<br>{t}col:{/t}{$containers[lst].column_number} {t}ligne:{/t}{$containers[lst].line_number}
							{/if}
						</td>
						<td class="center {if $containers[lst].nb_slots_used < $containers[lst].nb_slots_max || $containers[lst].nb_slots_max == 0}green{else}red{/if}">{$containers[lst].nb_slots_used}&nbsp;/&nbsp;{$containers[lst].nb_slots_max}</td>
						<td>{$containers[lst].storage_condition_name}</td>
						<td>{$containers[lst].storage_product}</td>
						<td>{$containers[lst].clp_classification}</td>
						<td class="center">
							{if $containers[lst].document_id > 0}
								<a class="image-popup-no-margins" href="documentGet?document_id={$containers[lst].document_id}&attached=0&phototype=1" title="{t}aperçu de la photo{/t}">
									<img src="documentGet?document_id={$containers[lst].document_id}&attached=0&phototype=2" height="30">
								</a>
							{/if}
						</td>
						<td>{$containers[lst].collection_name}</td>
						<td>{$containers[lst].referent_name} {$containers[lst].referent_firstname}</td>
						<td class="textareaDisplay">{$containers[lst].object_comment}</td>
						<td>{$containers[lst].uid + 9000000}</td>
					</tr>
				{/section}
			</tbody>
		</table>
		{if $rights.collection == 1}
			<div class="row">
				<div id="nbContainerChecked"></div>
			</div>
			<div class="row">
				<div class="col-md-6  form-horizontal">
					{t}Pour les éléments cochés :{/t}
					<input type="hidden" name="lastModule" value="{$lastModule}">
					<input type="hidden" name="uid" value="{$data.uid}">
					<input type="hidden" name="is_action" value="1">
					<select id="checkedActionContainer" class="form-control">
						<option value="" selected>{t}Choisissez{/t}</option>
						<option value="containersLending">{t}Prêter les contenants et leurs contenus{/t}</option>
						<option value="containersSetReferent">{t}Assigner un référent aux contenants{/t}</option>
						<option value="containersSetStatus">{t}Modifier le statut{/t}</option>
						<option value="containersSetCollection">{t}Assigner une collection aux contenants{/t}</option>
						<option value="containersExit">{t}Sortir les contenants{/t}</option>
						<option value="containersEntry">{t}Entrer ou déplacer les contenants au même emplacement{/t}</option>
						<option value="containersSetTrashed">{t}Mettre ou sortir de la corbeille{/t}</option>
						<option value="containersDelete">{t}Supprimer les contenants{/t}</option>
					</select>
					<!-- add a borrowing -->
					<div class="borrowing" hidden>
						<div class="form-group " >
							<label for="borrower_id"class="control-label col-md-4">
								<span class="red">*</span> {t}Emprunteur :{/t}
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
						<div class="form-group " >
							<label for="borrowing_date" class="control-label col-md-4"><span class="red">*</span>{t}Date d'emprunt :{/t}</label>
							<div class="col-md-8">
								<input id="borrowing_date" name="borrowing_date" value="{$borrowing_date}" class="form-control datepicker" >
							</div>
						</div>
						<div class="form-group " >
							<label for="expected_return_date" class="control-label col-md-4">{t}Date de retour escomptée :{/t}</label>
							<div class="col-md-8">
								<input id="expected_return_date" name="expected_return_date" value="{$expected_return_date}" class="form-control datepicker" >
							</div>
						</div>
					</div>
					<!-- add a referent to the list -->
					<div class="referent" hidden>
						<select id="referentid" name="referent_id" class="form-control">
							<option value="">{t}Choisissez le référent...{/t}</option>
							{foreach $referents as $referent}
							<option value="{$referent.referent_id}">
								{$referent.referent_name}
							</option>
							{/foreach}
						</select>
					</div>
					<div class="trashedgroup" hidden>
							<div class="form-group " >
							<label for="trashedbin" class="control-label col-md-4">{t}Traitement de la corbeille{/t}</label>
							<div class="col-md-8">
								<select class="form-control" name="settrashed" id="trashedbin">
									<option value="1">{t}Mettre à la corbeille{/t}</option>
									<option value="0">{t}Sortir de la corbeille{/t}</option>
								</select>
							</div>
						</div>
					</div>
					<!-- Entry in a container-->
					<script>
						$(document).ready(function() {
							$(".slotFull").change (function () { 
								var uid = $("#container_uid").val();
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
						<div class="form-group " >
							<label for="container_uid" class="control-label col-md-4"><span class="red">*</span> {t}UID du contenant :{/t}</label>
							<div class="col-md-8">
								<input id="container_uid" name="container_uid" value="" type="number" class="form-control slotFull">
							</div>
						</div>
						<div class="form-group " >
							<label for="containers_family_id" class="control-label col-md-4">{t}ou recherchez :{/t}</label>
								<div class="col-md-8">
									<select id="containers_family_id" class="form-control">
										<option value="" selected>{t}Sélectionnez la famille...{/t}</option>
										{section name=lst loop=$containerFamily}
											<option value="{$containerFamily[lst].container_family_id}">
												{$containerFamily[lst].container_family_name}
											</option>
										{/section}
									</select>
									<select id="containers_type_id" class="form-control">
										<option value=""></option>
									</select>
									<select id="containers" >
										<option value=""></option>
									</select>
								</div>
						</div>
						<div class="form-group " >
							<label for="storage_location" class="control-label col-md-4">
								{t}Emplacement dans le contenant (format libre) :{/t}
							</label>
							<div class="col-md-8">
								<input id="storage_location" name="storage_location" value="{$data.storage_location}" type="text" class="form-control">
							</div>
						</div>
						<div class="form-group " >
							<label for="line_number" class="control-label col-sm-4">{t}N° de ligne :{/t}</label>
							<div class="col-sm-8">
								<input id="line_number" name="line_number"
									value="" class="form-control nombre slotFull" title="{t}N° de la ligne de rangement dans le contenant{/t}">
							</div>
						</div>
						<div class="form-group " >
							<label for="column_number" class="control-label col-sm-4">{t}N° de colonne :{/t}</label>
							<div class="col-sm-8">
								<input id="column_number" name="column_number"
									value="" class="form-control nombre slotFull" title="{t}N° de la colonne de rangement dans le contenant{/t}">
							</div>
						</div>
					</div>
					<!-- set status -->
			<div class="form-group status" hidden>
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
					<div class="center">
						<button id="checkedButtonContainer" class="btn btn-danger" >{t}Exécuter{/t}</button>
					</div>
				</div>
			</div>
		{/if}
{if $rights.manage == 1}
	{$csrf}</form>
{/if}
