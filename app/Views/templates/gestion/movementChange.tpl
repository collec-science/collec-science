<script>
$(document).ready(function() {
var options;
var type_init = "{if $data.container_type_id > 0}{$data.container_type_id}{else}0{/if}";
var type_movement = "{$data.movement_type_id}";
	/*
	 * Recherche du type a partir de la famille
	 */
	function searchType() {
	var family = $("#container_family_id").val();
	var url = "containerTypeGetFromFamily";
	$.getJSON ( url, { "container_family_id":family } , function( data ) {
		if (data != null) {
			options = '<option value="" selected>{t}Choisissez...{/t}</option>';
			 for (var i = 0; i < data.length; i++) {
			    options += '<option value="' + data[i].container_type_id + '"';
			    if (data[i].container_type_id == type_init) {
			      	options += ' selected ';
			    }
			        options += '>' + data[i].container_type_name + '</option>';
			      };
			$("#container_type_id").html(options);
			}
		} ) ;
	}
	/*
	 * Recherche d'un container a partir du type
	 */
	function searchContainer () {
		var containerType = $("#container_type_id").val();
		var url = "containerGetFromType";
		var uid = 0;
		$.getJSON ( url, { "container_type_id":containerType } , function( data ) {
			if (data != null) {
			options = '';
			for (var i = 0; i < data.length; i++) {
				options += '<option value="' + data[i].container_id + '"';
				if (i == 0) {
					options += ' selected ';
					$("#container_id").val(data[i].container_id);
					$("#container_uid").val(data[i].uid);
					uid = data[i].uid;
				}
			    options += '>' + data[i].uid + " " + data[i].identifier + " ("+data[i].object_status_name + ")</option>";
			}
			$("#containers").html(options);
			if (uid > 0) {
				getOccupation(uid);
			}
			}
			});
	}

	$("#container_family_id").change(function () {
		searchType();
	 });
	$("#container_type_id").change(function () {
		searchContainer();
	});
	$("#containers").change(function() {
		var id = $("#containers").val();
		$("#container_id").val(id);
		var texte = $( "#containers option:selected" ).text();
		var a_texte = texte.split(" ");

		$("#container_uid").val(a_texte[0]);
		getOccupation(a_texte[0]);
	});
	if($("#movement_type_id").val() == 1 )
		$("#container_uid").attr("required");

	$("#movement{$moduleParent}Form").submit(function (event ) {
		var uid = $("#uid").val();
		var container_uid = $("#container_uid").val();
		if (uid == container_uid) {
			event.preventDefault();
			alert("{t}L'UID de l'objet et du contenant sont identiques : vous ne pouvez pas déplacer un objet dans lui même{/t}");
		}
	});
	/*
	 * Recherche du libelle du container en saisie directe
	 */
	 $("#container_uid").change(function () {
			var url = "containerGetFromUid";
			var uid = $(this).val();
			$.getJSON ( url, { "uid":uid } , function( data ) {
				if (data != null) {
				var options = '<option value="' + data.container_id + '" selected>' + data.uid + " " + data.identifier + " ("+data.object_status_name + ")</option>";
				$("#container_id").val(data.container_id);
				$("#containers").html(options);
				}
			/**
			 * Generate the grid of occupation of container
			 */
			 if (uid > 0) {
				getOccupation(uid);
			}
		});
	 });
	 function getOccupation(uid) {
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
					var realln = 1;
					var realcl = 1;
					if (firstLine != "T") {
						ln = lineNumber;
						incr = -1;
						realln = lineNumber;
					}
					if (firstColumn != "L") {
						cl = columnNumber;
						clIncr = -1;
						realcl = columnNumber;
					}
					var content = '<table class="table table-bordered"><tr><th class="center">{t}Ligne/colonne{/t}</th>';
					for (var col = 1 ; col <= columnNumber; col ++) {
						content += '<th class="center"><b>';
						if (column_in_char == 1) {
							content += String.fromCharCode (cl + 64);
						} else {
							content += cl;
						}
						content += '</b></th>';
						cl = cl + clIncr;
					}
					content += '</tr>';
					var nb = 0;
					var currentLine = realln;
					lines.forEach(function(line) {
						content += '<tr><td class="table table-bordered"><b>';
						if (line_in_char == 1) {
							content += String.fromCharCode (ln + 64);
						} else {
							content += ln;
						}
						content += '</b></td>';
						ln = ln + incr;
						var currentCol = realcl;
						line.forEach(function (cell) {
							nb = 0;
							content += '<td class="center cell" ';
							content += 'data-line="'+currentLine+'" data-column="'+ currentCol+'">';
							if (cell.length > 5) {
								content += cell.length + " {t}objets{/t}";
							} else {
								cell.forEach(function (item) {
									if (parseInt(item.uid) > 0) {
									if (nb > 0) {
										content += "<br>";
									}
									content += '<span class="nowrap">' + item.uid + " " + item.identifier+'</span>';
									nb ++;
									}
								});
							}
							content += '</td>';
							currentCol = currentCol + clIncr;
						});
						content += '</tr>';
						currentLine = currentLine + incr;
					});
					content += '</table>';
					/* Display */
					$("#container-content").html(content);
				}
			}
		});
	 }
	 $(document).on("click", ".cell", function(event){ 
		$("#line_number").val( $(this).data("line"));
		$("#column_number").val( $(this).data("column"));
		$(".cell").removeClass("itemSelected");
		$(this).addClass("itemSelected");
	 });
});

</script>
<div class="row">
	<div class="col-md-6">
		<a href="{$moduleListe}">
			<img src="display/images/list.png" height="25">
			{if $moduleParent == "container"}{t}Retour à la liste des contenants{/t}{else}{t}Retour à la liste des échantillons{/t}{/if}
		</a>
	{if $data.uid > 0}
		<a href="{$moduleParent}Display?uid={$data.uid}&activeTab={$activeTab}">
			<img src="display/images/box.png" height="25">
			{t}Retour au détail{/t}
		</a>
	{/if}
	<form class="form-horizontal " id="movement{$moduleParent}Form" method="post" action="movement{$moduleParent}Write">
		<input type="hidden" name="movement_id" value="{$data.movement_id}">
		<input type="hidden" name="moduleBase" value="movement{$moduleParent}">
		<input type="hidden" name="movement_type_id" id="movement_type_id" value="{$data.movement_type_id}">
		<input type="hidden" name="container_id" id="container_id" value="{$data.container_id}">
		<input type="hidden" name="activeTab" value="{$activeTab}">

		<div class="form-group">
			<label for="uid" class="control-label col-md-4">{t}Objet :{/t}</label>
			<div class="col-md-8">
				<input id="uid" name="uid" value="{$data.uid}" readonly >
				<input id="identifier" name="identifier" value="{$object.identifier}" readonly>
			</div>
		</div>
		{if $data.movement_type_id == 1}
			<fieldset>
				<legend>{t}Entrer ou déplacer dans :{/t}</legend>
				<div class="form-group">
					<label for="container_uid" class="control-label col-md-4"><span class="red">*</span> {t}UID du contenant :{/t}</label>
					<div class="col-md-8">
						<input id="container_uid" name="container_uid" value="{$data.container_uid}" type="number" class="form-control">
					</div>
				</div>
				<div class="form-group">
					<label for="container_family_id" class="control-label col-md-4">{t}ou recherchez :{/t}</label>
					<div class="col-md-8">
						<select id="container_family_id" name="container_family_id" class="form-control">
							<option value="" {if $data.container_family_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
							{section name=lst loop=$containerFamily}
								<option value="{$containerFamily[lst].container_family_id}" {if $data.container_family_id == $containerFamily[lst].container_family_id}selected{/if}>
									{$containerFamily[lst].container_family_name}
								</option>
							{/section}
						</select>
						<select id="container_type_id" name="container_type_id" class="form-control">
							<option value=""></option>
						</select>
						<select id="containers" name="containers" class="form-control">
							<option value=""></option>
						</select>
					</div>
				</div>
			</fieldset>
		{/if}
		<fieldset>
			<legend>{t}Détails :{/t}</legend>
			<div class="form-group">
				<label for="movement_date" class="control-label col-md-4"><span class="red">*</span> {t}Date :{/t}</label>
				<div class="col-md-8">
					<input id="movement_date" name="movement_date" value="{$data.movement_date}" required class="datetimepicker form-control">
				</div>
			</div>
			{if $data.movement_type_id == 1}
				<div class="form-group">
					<label for="storage_location" class="control-label col-md-4">{t}Emplacement dans le contenant
					(format libre) :{/t}</label>
					<div class="col-md-8">
						<input id="storage_location" name="storage_location" value="{$data.storage_location}" type="text" class="form-control">
					</div>
				</div>
				<div class="form-group">
					<label for="line_number" class="control-label col-sm-4">{t}N° de ligne :{/t}</label>
					<div class="col-sm-8">
						<input id="line_number" name="line_number"
							value="{$data.line_number}" class="form-control nombre" title="{t}N° de la ligne de rangement dans le contenant{/t}">
					</div>
				</div>
				<div class="form-group">
					<label for="column_number" class="control-label col-sm-4">{t}N° de colonne :{/t}</label>
					<div class="col-sm-8">
						<input id="column_number" name="column_number"
							value="{$data.column_number}" class="form-control nombre" title="{t}N° de la colonne de rangement dans le contenant{/t}">
					</div>
				</div>
			{/if}
			{if $data.movement_type_id == 2}
				<input type="hidden" name="line_number" id="line_number" value="1">
				<input type="hidden" name="column_number" id="column_number" value="1">
				<div class="form-group">
					<label for="movement_reason_id" class="control-label col-sm-4">{t}Motif du déstockage :{/t}</label>
					<div class="col-sm-8">
						<select id="movement_reason_id" name="movement_reason_id" class="form-control">
							<option value="" {if $data.movement_reason_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
							{section name=lst loop=$movementReason}
								<option value="{$movementReason[lst].movement_reason_id}" {if $data.movement_reason_id == $movementReason[lst].movement_reason_id}selected{/if}>
									{$movementReason[lst].movement_reason_name}
								</option>
							{/section}
						</select>
					</div>
				</div>
			{/if}
			<div class="form-group">
				<label for="movement_comment" class="control-label col-md-4">{t}Commentaire :{/t}</label>
				<div class="col-md-8">
					<textarea id="movement_comment" name="movement_comment" class="form-control" rows="3">{$data.movement_comment}</textarea>
				</div>
			</div>
			<div class="form-group">
				<label for="login" class="control-label col-md-4">{t}Utilisateur :{/t}</label>
				<div class="col-md-8">
					<input id="login" name="login" value="{$data.login}" type="text" readonly class="form-control">
				</div>
			</div>
		</fieldset>
		<div class="form-group center">
			<button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
		</div>
	{$csrf}</form>
	</div>
	<div class="col-md-6">
		<div id="container-content"></div>	
	</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
