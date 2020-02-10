{* Objets > Contenants > Rechercher > *}
<!-- Liste des containers pour affichage -->
<script>
$(document).ready(function () {
	var gestion = "{$droits.gestion}";
	var dataOrder = [0, 'asc'];
	if (gestion == 1) {
		dataOrder = [1, 'asc'];
	}
	var table = $("#containerList").DataTable();
	table.order(dataOrder).draw();

	$(".checkContainerSelect").change( function() {
		$('.checkContainer').prop('checked', this.checked);
		var libelle="{t}Tout cocher{/t}";
		if (this.checked) {
			libelle = "{t}Tout décocher{/t}";
		}
		$("#lcheckContainer").text(libelle);
	});

	$("#containerSpinner").hide();
	$('#containercsvfile').on('keypress click',function() {
		$(this.form).find("input[name='module']").val("containerExportCSV");
		$(this.form).prop('target', '_self').submit();
	});
	$("#containerlabels").on('click keypress', function() {
		$(this.form).find("input[name='module']").val("containerPrintLabel");
		/*$("#containerSpinner").show();*/
		$(this.form).prop('target', '_blank').submit();
	});
	$("#containerdirect").on('keypress click', function() {
		$(this.form).find("input[name='module']").val("containerPrintDirect");
		$("#containerSpinner").show();
		$(this.form).prop('target', '_self').submit();
	});
	$("#containerExport").on("keypress click", function () { 
		$(this.form).find("input[name='module']").val("containerExportGlobal");
	});
	$("#checkedButtonContainer").on ("keypress click", function(event) {
		var action = $("#checkedActionContainer").val();
		if (action.length > 0) {
			var conf = confirm("{t}Attention : l'opération est définitive. Est-ce bien ce que vous voulez faire ?{/t}");
			if ( conf  == true) {
				console.log (action);
				$(this.form).find("input[name='module']").val(action);
				$(this.form).prop('target', '_self').submit();
			} else {
				event.preventDefault();
			}
		} else {
			event.preventDefault();
		}
	});
	$("#checkedActionContainer").change(function () { 
		var action = $(this).val();
		if (action == "containersLending") {
			$(".borrowing").show();
			$(".trashedgroup").hide();
		} else if (action == "containersSetTrashed") {
			$(".borrowing").hide();
			$(".trashedgroup").show();
		} else {
			$(".borrowing").hide();
			$(".trashedgroup").hide();
		}
	});
	var tooltipContent ;
	/**
	 * Display the grid of a container
	 */
	var delay=500, timer;
	$(".container").mouseenter( function () {
		var objet = $(this);
		timer = setTimeout(function () {
			var uid = objet.data("uid");
			if (! objet.is(':ui-tooltip') ) {
				if (uid > 0) {
					var url = "index.php";
					var data = { "module":"containerGetOccupation", "uid": uid };
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
									content += '<th class="center">'+ cl + '</th>';
									cl = cl + clIncr;
								}
								content += '</tr>';
								var nb = 0;
								lines.forEach(function(line) {
									content += '<tr><td class="center"><b>'+ ln + '</b></td>';
                					ln = ln + incr;
									nb = 0;
									line.forEach(function (cell) {
										content += '<td class="center">';
										cell.forEach(function (item) {
											if (parseInt(item.uid) > 0) {
											if (nb > 0) {
												content += "<br>";
											}
											content += item.uid + " " + item.identifier;
											nb ++;
										}
										});
										content += '</td>';
									 });
									 content += '</tr>';
								});
								content += '</table>';
								//console.log(content);
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

});
</script>
{include file="gestion/displayPhotoScript.tpl"}
{if $droits.gestion == 1}
	<form method="POST" id="containerFormListPrint" action="index.php">
		<input type="hidden" id="module" name="module" value="containerPrintLabel">
		<input type="hidden" name="lastModule" value="{$lastModule}">
		<div class="row">
			<div class="center">
				<label id="lcheckContainer" for="check">{t}Tout décocher{/t}</label>
				<input type="checkbox" id="checkContainer1" class="checkContainerSelect checkContainer" checked>
				<select id="labels" name="label_id">
					<option value="" {if $label_id == ""}selected{/if}>{t}Étiquette par défaut{/t}</option>
					{section name=lst loop=$labels}
						<option value="{$labels[lst].label_id}" {if $labels[lst].label_id == $label_id}selected{/if}>
							{$labels[lst].label_name}
						</option>
					{/section}
				</select>
				<button id="containerlabels" class="btn btn-primary">{t}Étiquettes{/t}</button>
				<img id="containerSpinner" src="display/images/spinner.gif" height="25">
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
		<table id="containerList" class="table table-bordered table-hover datatable-export " >
			<thead>
				<tr>
					{if $droits.gestion == 1}
						<th class="center">
							<input type="checkbox" id="checkContainer2" class="checkContainerSelect checkContainer" checked>
						</th>
					{/if}
					<th>{t}UID{/t}</th>
					<th>{t}Identifiant ou nom{/t}</th>
					<th>{t}Autres identifiants{/t}</th>
					<th>{t}Statut{/t}</th>
					<th>{t}Type{/t}</th>
					<th>{t}Dernier mouvement{/t}</th>
					<th>{t}Emplacement{/t}</th>
					<th>{t}Nbre de slots utilisés/Nbre total{/t}</th>
					<th>{t}Condition de stockage{/t}</th>
					<th>{t}Produit utilisé{/t}</th>
					<th>{t}Code CLP{/t}</th>
					<th>{t}Photo{/t}</th>
				</tr>
			</thead>
			<tbody>
				{section name=lst loop=$containers}
					<tr>
						{if $droits.gestion == 1}
							<td class="center">
								<input type="checkbox" class="checkContainer" name="uids[]" value="{$containers[lst].uid}" checked>
							</td>
						{/if}
						<td class="text-center">
							<a href="index.php?module=containerDisplay&uid={$containers[lst].uid}" title="{t}Consultez le détail{/t}">
								{$containers[lst].uid}
							</a>
						</td>
						<td>
							<a href="index.php?module=containerDisplay&uid={$containers[lst].uid}">
								<span class="tooltiplink container"  data-uid="{$containers[lst].uid}" title="">{$containers[lst].identifier}</span>
							</a>
						</td>
						<td>{$containers[lst].identifiers}</td>
						<td {if $containers[lst].trashed == 1}class="trashed" title="{t}Contenant mis à la corbeille{/t}"{/if}>{$containers[lst].object_status_name}</td>
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
								<a href="index.php?module=containerDisplay&uid={$containers[lst].container_uid}">
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
								<a class="image-popup-no-margins" href="index.php?module=documentGet&document_id={$containers[lst].document_id}&attached=0&phototype=1" title="{t}aperçu de la photo{/t}">
									<img src="index.php?module=documentGet&document_id={$containers[lst].document_id}&attached=0&phototype=2" height="30">
								</a>
							{/if}
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
					<select id="checkedActionContainer" class="form-control">
						<option value="" selected>{t}Choisissez{/t}</option>
						<option value="containersLending">{t}Prêter les contenants et leurs contenus{/t}</option>
						<option value="containersSetTrashed">{t}Mettre ou sortir de la corbeille{/t}</option>
						<option value="containersDelete">{t}Supprimer les contenants{/t}</option>
					</select>
					<!-- add a borrowing -->
					<div class="form-group borrowing" hidden>
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
					<div class="form-group borrowing" hidden>
						<label for="borrowing_date" class="control-label col-md-4"><span class="red">*</span>{t}Date d'emprunt :{/t}</label>
						<div class="col-md-8">
							<input id="borrowing_date" name="borrowing_date" value="{$borrowing_date}" class="form-control datepicker" >
						</div>
					</div>
					<div class="form-group borrowing" hidden>
						<label for="expected_return_date" class="control-label col-md-4">{t}Date de retour escomptée :{/t}</label>
						<div class="col-md-8">
							<input id="expected_return_date" name="expected_return_date" value="{$expected_return_date}" class="form-control datepicker" >
						</div>
					</div>
					<div class="form-group trashedgroup" hidden>
						<label for="trashedbin" class="control-label col-md-4">{t}Traitement de la corbeille{/t}</label>
						<div class="col-md-8">
							<select class="form-control" name="settrashed" id="trashedbin">
								<option value="1">{t}Mettre à la corbeille{/t}</option>
								<option value="0">{t}Sortir de la corbeille{/t}</option>
							</select>
						</div>
					</div>
					<div class="center">
						<button id="checkedButtonContainer" class="btn btn-danger" >{t}Exécuter{/t}</button>
					</div>
				</div>
			</div>
		{/if}
{if $droits.gestion == 1}
	</form>
{/if}