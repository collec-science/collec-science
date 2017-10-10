<h2>Modification des motifs de déstockage</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=storageReasonList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="storageReasonForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="storageReason">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="storage_reason_id" value="{$data.storage_reason_id}">
<div class="form-group">
<label for="storageReasonName"  class="control-label col-md-4">Nom<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="storageReasonName" type="text" class="form-control" name="storage_reason_name" value="{$data.storage_reason_name}" autofocus required></div>
</div>


<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.storage_reason_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>