<h2>Modification d'une collection</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=collectionList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="collectionForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="collection">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="collection_id" value="{$data.collection_id}">
<div class="form-group">
<label for="collectionName"  class="control-label col-md-4">Nom<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="collectionName" type="text" class="form-control" name="collection_name" value="{$data.collection_name}" autofocus required>
</div>
</div>
<div class="form-group">
<label for="groupes"  class="control-label col-md-4">Groupes :</label>
<div class="col-md-7">
{section name=lst loop=$groupes}
<div class="col-md-2 col-sm-offset-3">
      <div class="checkbox">
        <label>
<input type="checkbox" name="groupes[]" value="{$groupes[lst].aclgroup_id}" {if $groupes[lst].checked == 1}checked{/if}>
{$groupes[lst].groupe}
</label>
</div>
</div>
{/section}

</div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.collection_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>