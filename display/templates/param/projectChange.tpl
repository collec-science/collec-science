<h2>Modification d'un projet</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=projectList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="projectForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="project">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="project_id" value="{$data.project_id}">
<div class="form-group">
<label for="projectName"  class="control-label col-md-4">Nom<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="projectName" type="text" class="form-control" name="project_name" value="{$data.project_name}" autofocus required>
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
      {if $data.project_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>