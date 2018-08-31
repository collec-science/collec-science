{* Paramètres > Protocoles > Nouveau > *}
<script>
$(document).ready(function () { 
	$("#spinner").hide();
	$("#protocolForm").submit( function (event) {
		$("#spinner").show();
	});
	var maxFileSize = {$maxFileSize} * 1024 * 1024;
      $("#protocolFile").on("change", function(e) { 
            var files = e.currentTarget.files;
            for (var x in files) {
                  var filesize = files[x].size;
                  if (filesize > maxFileSize) {
                        alert( "{t}La taille du fichier est supérieure à celle autorisée : {/t}"+{$maxFileSize}+"Mb");
                  }
            }
      });
});
</script>

<h2>{t}Création - Modification d'un protocole{/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=protocolList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal protoform" id="protocolForm" method="post" action="index.php" enctype="multipart/form-data">
<input type="hidden" name="moduleBase" value="protocol">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="protocol_id" value="{$data.protocol_id}">
<div class="form-group">
<label for="protocolName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom du protocole :{/t}</label>
<div class="col-md-8">
<input id="protocolName" type="text" class="form-control" name="protocol_name" value="{$data.protocol_name}" autofocus required>
</div>
</div>

<div class="form-group">
<label for="protocolVersion"  class="control-label col-md-4"><span class="red">*</span> {t}Version :{/t}</label>
<div class="col-md-8">
<input id="protocolVersion" type="text" class="form-control" name="protocol_version" value="{$data.protocol_version}" required>
</div>
</div>
<div class="form-group">
<label for="protocolYear"  class="control-label col-md-4">{t}Année :{/t}</label>
<div class="col-md-8">
<input id="protocolYear" class="form-control nombre" name="protocol_year" value="{$data.protocol_year}" >
</div>
</div>
<div class="form-group">
<label for="collection_id"  class="control-label col-md-4">{t}Collection de rattachement :{/t}</label>
<div class="col-md-8">
<select name="collection_id" id="collection_id" class="form-control">
{foreach $collections as $value}
<option value="{$value.collection_id}" {if $value.collection_id == $data.collection_id}selected{/if}>
{$value.collection_name}
</option>
{/foreach}
</select>
</div>
</div>

<div class="form-group">
<label for="protocolFile"  class="control-label col-md-4">{t}Fichier PDF de description :{/t}</label>
<div class="col-md-8">
<input id="protocolFile" type="file" class="form-control" name="protocol_file">
</div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.protocol_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
      <img id="spinner" src="{$display}/images/spinner.gif" height="25" >
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>