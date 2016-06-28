<script>
$(document).ready(function() { 
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
	options = '<option value="' + {$data.container_type_id} + '" selected> ' + {$data.container_type_name} + '</option>';
	$("#container_type_id").html(options);
	{/if}
});

</script>

<h2>Création - modification d'un conteneur</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=containerList">
<img src="display/images/list.png" height="25">
Retour à la liste des conteneurs
</a>
{if $data.uid > 0}
<a href="index.php?module=containerDisplay&uid={$data.uid}">
<img src="display/images/box.png" height="25">Retour au détail
</a>
{/if}

<form class="form-horizontal protoform" id="containerForm" method="post" action="index.php">
<input type="hidden" name="container_id" value="{$data.container_id}">
<input type="hidden" name="moduleBase" value="container">
<input type="hidden" name="action" value="Write">
{include file="gestion/uidChange.tpl"}

<div class="form-group">
<label for="container_family_id" class="control-label col-md-4">Famille :</label>
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

<div class="form-group">
<label for="container_status_id" class="control-label col-md-4">Statut<span class="red">*</span> :</label>
<div class="col-md-8">
<select id="container_status_id" name="container_status_id" class="form-control">
{section name=lst loop=$containerStatus}
<option value="{$containerStatus[lst].container_status_id}" {if $containerStatus[lst].container_status_id == $data.container_status_id}selected{/if}>
{$containerStatus[lst].container_status_name}
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
</div>

<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>