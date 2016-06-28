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
	function searchContainer () {
		var containerType = $("#container_type_id").val();
		console.log ("ContainerType : "+containerType);
		var url = "index.php";
		$.getJSON ( url, { "module":"containerGetFromType", "container_type_id":containerType } , function( data ) {
			if (data != null) {
			console.log ("data is not null");
			options = '';		
			for (var i = 0; i < data.length; i++) {
				options += '<option value="' + data[i].container_id + '"';
				if (i == 0) {
					options += ' selected ';
					$("#container_id").val(data[i].container_id);
					$("#container_uid").val(data[i].uid);
				}
			    options += '>' + data[i].uid + " " + data[i].identifier + "("+data[i].container_status_name + ")" '</option>';
			      };
			$("#containers").html(options);
	}
	
	$("#container_family_id").change(function () {
		searchType();
	 });
	$("#container_type_id").change(function () {
		searchContainer();
	});
	$("#containers").change(function() { 
		$("#container_id").val($("#containers").val());
	});
	
	 
});

</script>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=containerList">
<img src="display/images/list.png" height="25">
Retour à la liste des conteneurs
</a>
{if $data.uid > 0}
<a href="index.php?module=containerDisplay&uid={$data.uid}">
<img src="display/images/box.png" height="25">
Retour au détail
</a>
{/if}
<form class="form-horizontal protoform" id="containerForm" method="post" action="index.php">
<input type="hidden" name="storage_id" value="{$data.storage_id}">
<input type="hidden" name="moduleBase" value="container">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="movement_type_id" value="1">
<input type="hidden" name="container_id" id="container_id" value="{$data.container_id}">


<div class="form-group">
<label for="uid" class="control-label col-md-4">Objet :</label>
<div class="col-md-8">
<input id="uid" name="uid" value="{$data.uid}" readonly >
<input id="identifier" name="identifier" value="{$object.identifier}" readonly>
</div>
</div>

<fieldset>
<legend>Rangé dans :</legend>
<div class="form-group">
<label for="container_id" class="control-label col-md-4">UID du conteneur :<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="container_uid" name="container_uid" value="{$data.container_uid}" type="number" required class="form-control">
</div>
</div>
<div class="form-group">
<label for="container_family_id" class="control-label col-md-4">ou recherchez :</label>
<div class="col-md-8">
<select id="container_family_id" name="container_family_id" class="form-control">
<option value="" {if $data.container_family_id == ""}selected{/if}>Sélectionnez...</option>
{section name=lst loop=$containerFamily}
<option value="{$containerFamily[lst].container_family_id}" {if $data.container_family_id == $containerFamily[lst].container_family_id}selected{/if}>
{$containerFamily[lst].container_family_name}
</option>
{/section}
</select>
<select id="container_type_id" name="container_type_id" class="form-control">
<option value=""></option>
</select>
<select id="containers" name="containers">
<option value=""></option>
</select>
</div>
</div>


</fieldset>

<fieldset>
<legend>Détails du rangement :</legend>
<div class="form-group">
<label for="storage_date" class="control-label col-md-4">Date<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="storage_date" name="storage_date" value="{$data.storage_date}"   required class="datetimepicker form-control">
</div>
</div>
<div class="form-group">
<label for="range" class="control-label col-md-4">Emplacement dans le conteneur :</label>
<div class="col-md-8">
<input id="range" name="range" value="{$data.range}" type="text" class="form-control">
</div>
</div>
<div class="form-group">
<label for="storage_comment" class="control-label col-md-4">Commentaire :</label>
<div class="col-md-8">
<textarea id="storage_comment" name="textarea" class="form-control" rows="3">{$data.storage_comment}</textarea>
</div>
</div>
<div class="form-group">
<label for="login" class="control-label col-md-4">Utilisateur :</label>
<div class="col-md-8">
<input id="login" name="login" value="{$data.login}" type="text" readonly class="form-control">
</div>
</div>

</fieldset>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.storage_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>

</form>
</div>
</div>

<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>