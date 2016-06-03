<h2>Modification d'une condition de stockage</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=storageConditionList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="loginForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="storageCondition">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="storage_condition_id" value="{$data.storage_condition_id}">
<div class="form-group">
<label for="storageConditionName"  class="control-label col-md-4">Nom<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="storageConditionName" type="text" class="form-control" name="storage_condition_name" value="{$data.storage_condition_name}" autofocus required></div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.storage_condition_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>