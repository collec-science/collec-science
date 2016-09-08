<h2>Modification d'un projet</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=labelList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="labelForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="label">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="label_id" value="{$data.label_id}">
<div class="form-group">
<label for="labelName"  class="control-label col-md-4">Nom de l'étiquette<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="labelName" type="text" class="form-control" name="label_name" value="{$data.label_name}" autofocus required>
</div>
</div>
<div class="form-group">
<label for="xsl"  class="control-label col-md-4">Transformation XSL<span class="red">*</span> :</label>
<div class="col-md-8">
<textarea id="label_xsl" name="label_xsl" class="form-control" rows="20" required>{$data.label_xsl}</textarea>
</div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.label_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>