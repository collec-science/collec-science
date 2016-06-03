<h2>Modification d'un type d'événement</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=eventTypeList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="eventTypeForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="eventType">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="event_type_id" value="{$data.event_type_id}">
<div class="form-group">
<label for="eventTypeName"  class="control-label col-md-4">Nom<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="eventTypeName" type="text" class="form-control" name="event_type_name" value="{$data.event_type_name}" autofocus required></div>
</div>
<div class="form-group">
<label for="is_sample"  class="control-label col-md-4">Utilisable pour les échantillons : </label>
<div id="is_sample"class="col-md-8" >
<label class="radio-inline">
  <input type="radio" name="is_sample" id="isSample1" value="t" {if $data.is_sample == 1}checked {/if}> oui
</label>
<label class="radio-inline">
  <input type="radio" name="is_sample" id="isSample2" value="f" {if $data.is_sample == ""}checked {/if}> non
</label>
</div>
</div>
<div class="form-group">
<label for="is_container"  class="control-label col-md-4">Utilisable pour les conteneurs : </label>
<div id="is_container"class="col-md-8" >
<label class="radio-inline">
  <input type="radio" name="is_container" id="isContainer1" value="t" {if $data.is_container == 1}checked {/if}> oui
</label>
<label class="radio-inline">
  <input type="radio" name="is_container" id="isContainer2" value="f" {if $data.is_container == ""}checked {/if}> non
</label>
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.event_type_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>