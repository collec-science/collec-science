<h2>Modification des motifs de déstockage</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=movementReasonList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="movementReasonForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="movementReason">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="movement_reason_id" value="{$data.movement_reason_id}">
<div class="form-group">
<label for="movementReasonName"  class="control-label col-md-4">Nom<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="movementReasonName" type="text" class="form-control" name="movement_reason_name" value="{$data.movement_reason_name}" autofocus required></div>
</div>


<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.movement_reason_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>