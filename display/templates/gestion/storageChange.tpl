<script>
$(document).ready(function() { 
var options;
var type_init = {if $data.container_type_id > 0}{$data.container_type_id}{else}0{/if};
	/*
	 * Recherche du type a partir de la famille
	 */
	function searchType() { 
	var family = $("#container_family_id").val();
	console.log ("famille : "+family);
	var url = "index.php";
	$.getJSON ( url, { "module":"containerTypeGetFromFamily", "container_family_id":family } , function( data ) {
		console.log ("data.length : "+data.length);
		if (data != null) {
			options = '<option value="" selected>{$LANG["appli"].2}</option>';			
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
			    options += '>' + data[i].uid + " " + data[i].identifier + " ("+data[i].object_status_name + ")</option>";
			}
			$("#containers").html(options);
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
		console.log("container_id : "+id);
		console.log("container_uid : " + a_texte[0] );
	});
	if($("#movement_type_id").val() == 1 )
		$("#container_uid").attr("required");
	
	$("#movement{$moduleParent}Form").submit(function (event ) { 
		var uid = $("#uid").val();
		var container_uid = $("#container_uid").val();
		console.log("uid : "+uid);
		console.log("container_uid : " + uid);
		if (uid == container_uid) {
			event.preventDefault();
		}
	});
	
	/*
	 * Recherche du libelle du container en saisie directe
	 */
	 $("#container_uid").change(function () { 
			var url = "index.php";
			var uid = $(this).val();
			console.log ("Recherche container - uid : "+uid);
			$.getJSON ( url, { "module":"containerGetFromUid", "uid":uid } , function( data ) {
				if (data != null) {
				console.log ("data is not null");
				var options = '<option value="' + data.container_id + '" selected>' + data.uid + " " + data.identifier + " ("+data.object_status_name + ")</option>";
				$("#container_id").val(data.container_id);
				$("#containers").html(options);
				}
				});

	 });
	 
});

</script>
<div class="row">
<div class="col-md-6">
<a href="index.php?module={$moduleParent}List">
<img src="{$display}/images/list.png" height="25">
Retour à la liste des {if $moduleParent == "container"}containers{else}échantillons{/if}
</a>
{if $data.uid > 0}
<a href="index.php?module={$moduleParent}Display&uid={$data.uid}">
<img src="{$display}/images/box.png" height="25">
Retour au détail
</a>
{/if}
<form class="form-horizontal protoform" id="movement{$moduleParent}Form" method="post" action="index.php">
<input type="hidden" name="movement_id" value="{$data.movement_id}">
<input type="hidden" name="moduleBase" value="movement{$moduleParent}">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="movement_type_id" id="movement_type_id" value="{$data.movement_type_id}">
<input type="hidden" name="container_id" id="container_id" value="{$data.container_id}">


<div class="form-group">
<label for="uid" class="control-label col-md-4">Objet :</label>
<div class="col-md-8">
<input id="uid" name="uid" value="{$data.uid}" readonly >
<input id="identifier" name="identifier" value="{$object.identifier}" readonly>
</div>
</div>
{if $data.movement_type_id == 1}
<fieldset>
<legend>Rangé dans :</legend>
<div class="form-group">
<label for="container_uid" class="control-label col-md-4">UID du container :<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="container_uid" name="container_uid" value="{$data.container_uid}" type="number" class="form-control">
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
{/if}

<fieldset>
<legend>Détails :</legend>
<div class="form-group">
<label for="movement_date" class="control-label col-md-4">Date<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="movement_date" name="movement_date" value="{$data.movement_date}" required class="datetimepicker form-control">
</div>
</div>
{if $data.movement_type_id == 1}
<div class="form-group">
<label for="movement_location" class="control-label col-md-4">Emplacement dans le container (format libre) :</label>
<div class="col-md-8">
<input id="movement_location" name="movement_location" value="{$data.movement_location}" type="text" class="form-control">
</div>
</div>
			<div class="form-group">
				<label for="line_number" class="control-label col-sm-4">N° de ligne :</label>
				<div class="col-sm-8">
					<input id="line_number" name="line_number"
						value="{$data.line_number}" class="form-control nombre" title="N° de la ligne de rangement dans le container">
				</div>
			</div>
			<div class="form-group">
				<label for="column_number" class="control-label col-sm-4">N° de colonne :</label>
				<div class="col-sm-8">
					<input id="column_number" name="column_number"
						value="{$data.column_number}" class="form-control nombre" title="N° de la colonne de rangement dans le container">
				</div>
			</div>

{/if}
{if $data.movement_type_id == 2}
			<div class="form-group">
				<label for="movement_reason_id" class="control-label col-sm-4">Motif du déstockage :</label>
				<div class="col-sm-8">
					<select id="movement_reason_id" name="movement_reason_id">
					<option value="" {if $data.movement_reason_id == ""}selected{/if}>Sélectionnez...</option>
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
<label for="movement_comment" class="control-label col-md-4">Commentaire :</label>
<div class="col-md-8">
<textarea id="movement_comment" name="movement_comment" class="form-control" rows="3">{$data.movement_comment}</textarea>
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
      {if $data.movement_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>

</form>
</div>
</div>

<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>