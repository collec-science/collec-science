{* Objets > échantillons > Rechercher > *}
<!--  Liste des échantillons pour affichage-->
<script>
	$(document).ready(function() {
		var displayModeFull = Cookies.get("samplelistDisplayMode");
		if (typeof (displayModeFull) == "undefined") {
			$(window).width() < 1200 ? displayModeFull = false : displayModeFull = true;
		} else {
			displayModeFull == "true" ? displayModeFull = true : displayModeFull = false;
		}

		
		$("#checkSample").change(function() {
			$('.checkSample').prop('checked', this.checked);
			var libelle = "{t}Tout cocher{/t}";
			if (this.checked) {
				libelle = "{t}Tout décocher{/t}";
			}
			$("#lsamplechek").text(libelle);
		});
		
		$("#sampleSpinner").hide();

		$('#samplecsvfile').on('keypress click', function() {
			$(this.form).find("input[name='module']").val("sampleExportCSV");
			$(this.form).submit();
		});
		$("#samplelabels").on ("keypress click",function() {
			$(this.form).find("input[name='module']").val("samplePrintLabel");
			/*$("#sampleSpinner").show();*/
			$(this.form).prop('target', '_blank').submit();
		});
		$("#sampledirect").on ("keypress click", function() {
			$(this.form).find("input[name='module']").val("samplePrintDirect");
			$("#sampleSpinner").show();
			$(this.form).submit();
		});
		$("#sampleExport").on ("keypress click", function() { 
			$(this.form).find("input[name='module']").val("sampleExport");
			$(this.form).submit();
		});
		/*
		 * Gestion de l'affichage des colonnes en fonction de la taille de l'ecran
		 */
		function displayMode(mode) {
			displayModeFull = mode;
			$("#sampleList").DataTable().columns([3,5,6,7,10,11,12,13]).visible(displayModeFull);
			if (displayModeFull) {
				$("#displayModeButton").text("{t}Affichage réduit{/t}");
			} else {
				$("#displayModeButton").text("{t}Affichage complet{/t}");
			}
			Cookies.set("samplelistDisplayMode",displayModeFull);
		}
		
		/*
		 * Masquage des colonnes pour les petits ecrans
		 */
		$(window).resize(function() {
			  if ($(this).width() < 1200) {
				 displayMode(false);
			    
			  } else {
				  displayMode(true);
			  }
			});
		$("#displayModeButton").on ("keypress click", function() {
			displayModeFull == true ? displayModeFull = false : displayModeFull = true;
			displayMode(displayModeFull);
		});
		/*
		 * initialisation a l'ouverture de la fenetre
		 */
		displayMode(displayModeFull);

		$("#checkedButton").on ("keypress click", function(event) {
			
			var action = $("#checkedAction").val();
			if (action.length > 0) {
				var conf = confirm("{t}Attention : l'opération est définitive. Est-ce bien ce que vous voulez faire ?{/t}");
				if ( conf  == true) {
					$(this.form).find("input[name='module']").val(action);
					$(this.form).submit();
				} else {
					event.preventDefault();
				}
			} else {
				event.preventDefault();
			}
		});

		$("#checkedAction").change(function () { 
			var action = $(this).val();
			if (action == "samplesAssignReferent") {
				$("#referentid").show();
			} else {
				$("#referentid").hide();
			}
		});
		
	});
</script>
<button id="displayModeButton" class="btn btn-info pull-right">{t}Affichage réduit{/t}</button>
{include file="gestion/displayPhotoScript.tpl"} {if $droits.gestion == 1}
<form method="POST" id="formListPrint" action="index.php">
	<input type="hidden" id="module" name="module" value="samplePrintLabel">
	<div class="row">
		<div class="center">
			<label id="lsamplecheck" for="checkSample">{t}Tout décocher{/t}</label> <input
				type="checkbox" id="checkSample" checked>
			<select id="labels" name="label_id">
			<option value="" {if $label_id == ""}selected{/if}>{t}Étiquette par défaut{/t}</option>
			{section name=lst loop=$labels}
			<option value="{$labels[lst].label_id}" {if $labels[lst].label_id == $label_id}selected{/if}>
			{$labels[lst].label_name}
			</option>
			{/section}
			</select>
			<button id="samplelabels" class="btn btn-primary">{t}Étiquettes{/t}</button>
			<img id="sampleSpinner" src="{$display}/images/spinner.gif" height="25">

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
			<button id="samplecsvfile" class="btn btn-primary">{t}Fichier CSV{/t}</button>
			{if $droits["gestion"] == 1}
			<button id="sampleExport" class="btn btn-primary" title="{t}Export pour import dans une autre base Collec-Science{/t}">
			{t}Export vers autre base{/t}</button>
			{/if}
		</div>
	</div>
	{/if}
	<table id="sampleList"
		class="table table-bordered table-hover datatable-export">
		<thead>
			<tr>
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
				<th>{t}Lieu de prélèvement{/t}</th>
				<th>{t}Date d'échantillonnage{/t}</th>
				<th>{t}Date de création dans la base{/t}</th>
				<th>{t}Date d'expiration{/t}</th>
				{if $droits.gestion == 1}
				<th></th> {/if}
			</tr>
		</thead>
		<tbody>
			{section name=lst loop=$samples}
			<tr>
				<td class="text-center"><a
					href="index.php?module=sampleDisplay&uid={$samples[lst].uid}"
					title="{t}Consultez le détail{/t}"> {$samples[lst].uid} </a>
					</td>
				<td><a
					href="index.php?module=sampleDisplay&uid={$samples[lst].uid}"
					title="{t}Consultez le détail{/t}"> {$samples[lst].identifier} </a></td>
				<td>{$samples[lst].identifiers}
				{if strlen($samples[lst].dbuid_origin) > 0}
				{if strlen($samples[lst].identifiers) > 0}<br>{/if}
				<span title="{t}UID de la base de données d'origine{/t}">{$samples[lst].dbuid_origin}</span>
				{/if}
				</td>
				<td>{$samples[lst].collection_name}</td>
				<td>{$samples[lst].sample_type_name}</td>
				<td>{$samples[lst].object_status_name}</td>
				<td>{if strlen($samples[lst].parent_uid) > 0}
				<a href="index.php?module=sampleDisplay&uid={$samples[lst].parent_uid}">
				{$samples[lst].parent_uid}&nbsp;{$samples[lst].parent_identifier}
				</a>
				{/if}
				</td>
				<td class="center">{if $samples[lst].document_id > 0} <a
					class="image-popup-no-margins"
					href="index.php?module=documentGet&document_id={$samples[lst].document_id}&attached=0&phototype=1"
					title="{t}aperçu de la photo{/t}"> <img
						src="index.php?module=documentGet&document_id={$samples[lst].document_id}&attached=0&phototype=2"
						height="30">
				</a> {/if}
				</td>
				<td>
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
				<td>{$samples[lst].sampling_place_name}</td>
				<td>{$samples[lst].sampling_date}</td>
				<td>{$samples[lst].sample_creation_date}</td> 
				<td>{$samples[lst].expiration_date}</td>
				{if $droits.gestion == 1}
				<td class="center"><input type="checkbox" class="checkSample"
					name="uid[]" value="{$samples[lst].uid}" checked></td> {/if}
			</tr>
			{/section}
		</tbody>
	</table>
	{if $droits.collection == 1}
	<div class="row">
		{t}Pour les éléments cochés :{/t}
		<input type="hidden" name="lastModule" value="{$lastModule}">
		<input type="hidden" name="uid" value="{$data.uid}">
		<select id="checkedAction">
		<option value="" selected>{t}Sélectionnez{/t}</option>
		<option value="samplesAssignReferent">{t}Assigner un référent aux échantillons{/t}</option>
		<option value="samplesDelete">{t}Supprimer les échantillons{/t}</option>
		</select>
		<select id="referentid" name="referent_id" hidden>
				<option value="">{t}Choisissez...{/t}</option>
				{foreach $referents as $referent}
				<option value="{$referent.referent_id}">
				{$referent.referent_name}
				</option>
				{/foreach}
		</select>
		<button id="checkedButton" class="btn btn-danger" >{t}Exécuter{/t}</button>
	</div>
</form>
{/if}
