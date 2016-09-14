<script>
$(document).ready(function () { 
	$("#spinner").hide();
	$("#protocolForm").submit( function (event) {
		$("#spinner").show();
	});
	
});
</script>

<h2>Modification d'un protocole</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=protocolList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="protocolForm" method="post" action="index.php" enctype="multipart/form-data">
<input type="hidden" name="moduleBase" value="protocol">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="protocol_id" value="{$data.protocol_id}">
<div class="form-group">
<label for="protocolName"  class="control-protocol col-md-4">Nom du protocole<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="protocolName" type="text" class="form-control" name="protocol_name" value="{$data.protocol_name}" autofocus required>
</div>
</div>

<div class="form-group">
<label for="protocolVersion"  class="control-protocol col-md-4">Version<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="protocolVersion" type="text" class="form-control" name="protocol_version" value="{$data.protocol_version}" required>
</div>
</div>
<div class="form-group">
<label for="protocolYear"  class="control-protocol col-md-4">Année :</label>
<div class="col-md-8">
<input id="protocolYear" class="form-control nombre" name="protocol_year" value="{$data.protocol_year}" >
</div>
</div>
<div class="form-group">
<label for="protocolFile"  class="control-protocol col-md-4">Fichier PDF de description :</label>
<div class="col-md-8">
<input id="protocolFile" type="file" class="form-control" name="protocol_file">
</div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.protocol_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
      <img id="spinner" src="display/images/spinner.gif" height="25" >
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>