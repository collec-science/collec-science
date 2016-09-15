<h2>Modification d'un type de sous-échantillonnage</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=multipleTypeList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="multipleTypeForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="multipleType">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="multiple_type_id" value="{$data.multiple_type_id}">
<div class="form-group">
<label for="multipleTypeName"  class="control-label col-md-4">Nom<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="multipleTypeName" type="text" class="form-control" name="multiple_type_name" value="{$data.multiple_type_name}" autofocus required></div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.multiple_type_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>