<script>
$(document).ready(function() {
	function convertGPSSecondeToDD(valeur) {
		var parts = valeur.split(/[^\d]+/);
		var dd = parseFloat(parts[0]) + parseFloat(parseFloat(parts[1]) / 60) + parseFloat(parseFloat(parts[2]) / 3600);
		//dd = parseFloat(dd);
		var lastChar = valeur.substr(-1).toUpperCase();
		dd = Math.round(dd * 1000000) / 1000000;
		if (lastChar == "S" || lastChar == "W" || lastChar == "O") {
			dd *= -1;
		};
		return dd;
	}

	function convertGPSDecimalToDD(valeur) {
		var parts = valeur.split(/[^\d]+/);
		var dd = parseFloat(parts[0])
			+ parseFloat((parts[1] + "." + parts[2]) / 60);
		var lastChar = valeur.substr(-1).toUpperCase();
		dd = Math.round(dd * 1000000) / 1000000;
		if (lastChar == "S" || lastChar == "W" || lastChar == "O") {
			dd *= -1;
		}
		;
		return dd;
	}
	$("#latitude").change( function () {
    		var value = $(this).val();
    		if (value.length > 0) {
				if ($("input[name='degreType']:checked").val() == 1) {
					value = convertGPSDecimalToDD(value);
				} else {
					value = convertGPSSecondeToDD(value);
				}
    			$("#wgs84_y").val(value);
				setLocalisation();
    		}
    	});
		$("#longitude").change( function () {
    		var value = $(this).val();
    		if (value.length > 0) {
				if ($("input[name='degreType']:checked").val() == 1) {
					value = convertGPSDecimalToDD(value);
				} else {
					value = convertGPSSecondeToDD(value);
				}
    			$("#wgs84_x").val(value);
				setLocalisation();
    		}
    	});

var options;
var container_type_id = "{$data.container_type_id}";
var type_init = 0;
if (container_type_id > 0) {
	type_init = container_type_id;
}
	function searchType() {
	var family = $("#container_family_id").val();
	var url = "index.php";
	$.getJSON ( url, { "module":"containerTypeGetFromFamily", "container_family_id":family } , function( data ) {
		if (data != null) {
			options = '';
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
	$("#container_family_id").change(function (){
	searchType();
	 });
	searchType();

	if (container_type_id > 0) {
		var type_libelle = "{$data.container_type_name}";
		//type_libelle = type_libelle.replace(/'/g, "\\'");
		options = '<option value="' + {$data.container_type_id} + '" selected>'+ type_libelle + ' </option>';
		$("#container_type_id").html(options);
	}

	$("#containerForm").submit(function(event) {
		/*
	 	 * Blocage de l'envoi du formulaire
		 */
		 var containerType = $("#container_type_id").val();
		 if (!containerType)
			event.preventDefault();
	 });

	function setLocalisation() {
		var lon = $("#wgs84_x").val();
		var lat = $("#wgs84_y").val();
		if (lon.length > 0 && lat.length > 0) {
			setPosition(lat,lon);
		}
	}
});

</script>

<h2>{t}Création - modification d'un contenant{/t}</h2>
<div class="row">
	<div class="col-md-6">
	<a href="index.php?module={$moduleListe}">
		<img src="display/images/list.png" height="25">
		{t}Retour à la liste des contenants{/t}
	</a>
	{if $data.uid > 0}
		<a href="index.php?module=containerDisplay&uid={$data.uid}">
			<img src="display/images/box.png" height="25">{t}Retour au détail{/t}
		</a>
	{elseif $container_parent_uid > 0}
		<a href="index.php?module=containerDisplay&uid={$container_parent_uid}">
			<img src="display/images/box.png" height="25">{t 1=$container_parent_uid 2=$container_parent_identifier }Retour au parent (%1 %2){/t}
		</a>
	{/if}
	<form class="form-horizontal protoform" id="containerForm" method="post" action="index.php">
		<input type="hidden" name="container_id" value="{$data.container_id}">
		<input type="hidden" name="moduleBase" value="container">
		<input type="hidden" name="action" value="Write">
		<input type="hidden" name="container_parent_uid" value="{$container_parent_uid}">
		<div class="form-group">
			<label for="uid" class="control-label col-md-4">{t}UID :{/t}</label>
			<div class="col-md-8">
				<input id="uid" name="uid" value="{$data.uid}" readonly class="form-control" title="{t}identifiant unique dans la base de données{/t}">
			</div>
		</div>
		<div class="form-group">
			<label for="appli" class="control-label col-md-4">{t}Identifiant ou nom :{/t}</label>
			<div class="col-md-8">
				<input id="identifier" type="text" name="identifier" class="form-control" value="{$data.identifier}" autofocus >
			</div>
		</div>
		<div class="form-group">
			<label for="referentId"  class="control-label col-md-4">{t}Référent du contenant :{/t}</label>
			<div class="col-md-8">
				<select id="referentId" name="referent_id" class="form-control">
					<option value="" {if $data.referent_id == ""}selected{/if}>Choisissez...</option>
					{foreach $referents as $referent}
						<option value="{$referent.referent_id}" {if $data.referent_id == $referent.referent_id}selected{/if}>
							{$referent.referent_name}
						</option>
					{/foreach}
				</select>
			</div>
		</div>
		<div class="form-group">
			<label for="object_status_id" class="control-label col-md-4"><span class="red">*</span>  {t}Statut :{/t}</label>
			<div class="col-md-8">
				<select id="object_status_id" name="object_status_id" class="form-control">
				{section name=lst loop=$objectStatus}
					<option value="{$objectStatus[lst].object_status_id}" {if $objectStatus[lst].object_status_id == $data.object_status_id}selected{/if}>
						{$objectStatus[lst].object_status_name}
					</option>
				{/section}
				</select>
			</div>
		</div>
		<div class="form-group">
			<label for="" class="control-label col-sm-4">
				{t}Mode de calcul des coordonnées GPS :{/t}
			</label>
			<div class="col-sm-8">
				<table>
					<tr>
						<td>
							{t}Données initiales en degrés/minutes décimales{/t}
						</td>
						<td>
							<input name="degreType" type="radio" checked value="1">
						</td>
					</tr>
					<tr>
						<td>
							{t}Données initiales en degrés/minutes/secondes{/t}
						</td>
						<td>
							<input name="degreType" type="radio" value="0">
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="form-group">
			<label for="wy" class="control-label col-md-4">{t}Latitude :{/t}</label>
			<div class="col-md-8" id="wy">
				{t}Format sexagesimal (45°01,234N) :{/t}
				<input id="latitude" placeholder="45°01,234N" autocomplete="off" class="form-control">
				{t}Format décimal (45.081667) :{/t}
				<input id="wgs84_y" name="wgs84_y" placeholder="45.01300" autocomplete="off" class="form-control taux position" value="{$data.wgs84_y}">
			</div>
		</div>
		<div class="form-group">
			<label for="wx" class="control-label col-md-4">{t}Longitude :{/t}</label>
			<div class="col-md-8" id="wx">
				{t}Format sexagesimal (0°01,234W) :{/t}
				<input id="longitude" placeholder="0°01,234W" autocomplete="off" class="form-control">
				{t}Format décimal (-0.081667) :{/t}
				<input id="wgs84_x" name="wgs84_x" placeholder="-0.0156" autocomplete="off" class="form-control taux position" value="{$data.wgs84_x}">
			</div>
		</div>
		<div class="form-group">
			<label for="location_accuracy"  class="control-label col-md-4">{t}Précision de la localisation (en mètres) :{/t}</label>
			<div class="col-md-8">
				<input id="sampling_date" class="form-control taux" name="location_accuracy" value="{$data.location_accuracy}">
			</div>
		</div>
		<div class="form-group">
			<label for="container_family_id" class="control-label col-md-4"><span class="red">*</span> {t}Famille :{/t}</label>
			<div class="col-md-8">
				<select id="container_family_id" name="container_family_id" class="form-control">
					<option value="" {if $data.container_family_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
					{section name=lst loop=$containerFamily}
						<option value="{$containerFamily[lst].container_family_id}" {if $data.container_family_id == $containerFamily[lst].container_family_id}selected{/if}>
						{$containerFamily[lst].container_family_name}
						</option>
					{/section}
				</select>
			</div>
		</div>
		<div class="form-group">
			<label for="container_type_id" class="control-label col-md-4"><span class="red">*</span> {t}Type :{/t}</label>
			<div class="col-md-8">
				<select id="container_type_id" name="container_type_id" class="form-control">
					{section name=lst loop=$container_type}
						<option value="{$container_type[lst].container_type_id}" {if $container_type[lst].container_type_id == $data.container_type_id}selected{/if}>
							{$container_type[lst].container_type_name}
						</option>
					{/section}
				</select>
			</div>
		</div>
		<div class="form-group">
			<label for="object_comment" class="control-label col-md-4">{t}Commentaire :{/t}</label>
			<div class="col-md-8">
				<textarea class="form-control" rows="3" id="object_comment" name="object_comment">{$data.object_comment}</textarea>
			</div>
		</div>
		<div class="form-group">
			<label for="uuid"  class="control-label col-md-4">{t}UID universel (UUID) :{/t}</label>
			<div class="col-md-8">
				<input id="expiration_date" class="form-control uuid" name="uuid"  value="{$data.uuid}">
			</div>
		</div>
		{if $data.container_id > 0}
			<div class="form-group">
				<label for="trashed" class="col-md-4 control-label">{t}Contenant en attente de suppression (mis à la corbeille) :{/t}</label>
				<div class="col-md-8" id="trashed">
					<div class="radio-inline">
					<label>
						<input type="radio" name="trashed" id="trashed1" value="1" {if $data.trashed == 1}checked{/if}>
						{t}oui{/t}
					</label>
					</div>
					<div class="radio-inline">
						<label>
							<input type="radio" name="trashed" id="trashed0" value="0" {if $data.trashed == 0}checked{/if}>
							{t}non{/t}
						</label>
					</div>
				</div>
			</div>
		{/if}
		<div class="form-group center">
			<button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
			{if $data.container_id > 0 }
			<button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
			{/if}
		</div>
	</form>
</div>
<div class="col-md-6">
	{include file="gestion/objectMapDisplay.tpl"}
</div>


<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>