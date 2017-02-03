<h2>Modification d'un lieu de prélèvement</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=samplingPlaceList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="samplingPlaceForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="samplingPlace">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="sampling_place_id" value="{$data.sampling_place_id}">
<div class="form-group">
<label for="samplingPlaceName"  class="control-label col-md-4">Nom<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="samplingPlaceName" type="text" class="form-control" name="sampling_place_name" value="{$data.sampling_place_name}" autofocus required></div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.sampling_place_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>