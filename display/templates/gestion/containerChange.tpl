<script>
$(document).ready(function() { 
	function convertGPStoDD(valeur) {
		var parts = valeur.trim().split(/[^\d]+/);
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
			$("#wgs84_y").val( convertGPStoDD(value));
		}
	});
	$("#longitude").change( function () {
		var value = $(this).val();
		if (value.length > 0) {
			$("#wgs84_x").val( convertGPStoDD(value));
		}
	});

var options;
var type_init = {if $data.container_type_id > 0}{$data.container_type_id}{else}0{/if};
	function searchType() { 
	var family = $("#container_family_id").val();
	console.log ("famille : "+family);
	var url = "index.php";
	$.getJSON ( url, { "module":"containerTypeGetFromFamily", "container_family_id":family } , function( data ) {
		if (data != null) {
		console.log ("data is not null");
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
	{if $data.container_type_id > 0}
	options = '<option value="' + {$data.container_type_id} + '" selected> {$data.container_type_name} </option>';
	$("#container_type_id").html(options);
	{/if}
	
	$("#containerForm").submit(function(event) {
		/*
	 	 * Blocage de l'envoi du formulaire
		 */
		 var containerType = $("#container_type_id").val();
		 if (!containerType)
			event.preventDefault();
	 });
});

</script>

<h2>Création - modification d'un container</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module={$moduleListe}">
<img src="{$display}/images/list.png" height="25">
Retour à la liste des containers
</a>
{if $data.uid > 0}
<a href="index.php?module=containerDisplay&uid={$data.uid}">
<img src="{$display}/images/box.png" height="25">Retour au détail
</a>
{elseif $container_parent_uid > 0}
<a href="index.php?module=containerDisplay&uid={$container_parent_uid}">
<img src="{$display}/images/box.png" height="25">Retour au parent ({$container_parent_uid} {$container_parent_identifier})
</a>
{/if}

<form class="form-horizontal protoform" id="containerForm" method="post" action="index.php">
<input type="hidden" name="container_id" value="{$data.container_id}">
<input type="hidden" name="moduleBase" value="container">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="container_parent_uid" value="{$container_parent_uid}">

<div class="form-group">
<label for="uid" class="control-label col-md-4">UID :</label>
<div class="col-md-8">
<input id="uid" name="uid" value="{$data.uid}" readonly class="form-control" title="identifiant unique dans la base de données">
</div>
</div>

<div class="form-group">
<label for="appli" class="control-label col-md-4">Identifiant ou nom :</label>
<div class="col-md-8">
<input id="identifier" type="text" name="identifier" class="form-control" value="{$data.identifier}" autofocus >
</div>
</div>

<div class="form-group">
<label for="object_status_id" class="control-label col-md-4">Statut<span class="red">*</span> :</label>
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
<label for="wy" class="control-label col-md-4">Latitude :</label>
<div class="col-md-8" id="wy">
<input id="latitude" placeholder="45°01,234N" autocomplete="off" class="form-control">
<input id="wgs84_y" name="wgs84_y" placeholder="45.01300" autocomplete="off" class="form-control taux position" value="{$data.wgs84_y}">
</div>
</div>

<div class="form-group">
<label for="wx" class="control-label col-md-4">Longitude :</label>
<div class="col-md-8" id="wx">
<input id="longitude" placeholder="0°01,234W" autocomplete="off" class="form-control">
<input id="wgs84_x" name="wgs84_x" placeholder="-0.0156" autocomplete="off" class="form-control taux position" value="{$data.wgs84_x}">
</div>
</div>

<div class="form-group">
<label for="container_family_id" class="control-label col-md-4">Famille<span class="red">*</span> :</label>
<div class="col-md-8">
<select id="container_family_id" name="container_family_id" class="form-control">
<option value="" {if $data.container_family_id == ""}selected{/if}>Sélectionnez...</option>
{section name=lst loop=$containerFamily}
<option value="{$containerFamily[lst].container_family_id}" {if $data.container_family_id == $containerFamily[lst].container_family_id}selected{/if}>
{$containerFamily[lst].container_family_name}
</option>
{/section}
</select>
</div>
</div>
<div class="form-group">
<label for="container_type_id" class="control-label col-md-4">Type<span class="red">*</span> :</label>
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

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.container_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>

</form>
</div>
<div class="col-md-6">
{include file="gestion/objectMapDisplay.tpl"}
</div>
</div>

<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>