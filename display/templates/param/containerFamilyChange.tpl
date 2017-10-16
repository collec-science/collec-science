<h2>Modification d'une famille de containers</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=containerFamilyList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="containerFamilyForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="containerFamily">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="container_family_id" value="{$data.container_family_id}">
<div class="form-group">
<label for="containerFamilyName"  class="control-label col-md-4">Nom<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="containerFamilyName" type="text" class="form-control" name="container_family_name" value="{$data.container_family_name}" autofocus required></div>
</div>
<div class="form-group">
<label for="is_movable"  class="control-label col-md-4">containers facilement déplaçables (éprouvettes, p. e.) : </label>
<div id="is_movable"class="col-md-8" >
<label class="radio-inline">
  <input type="radio" name="is_movable" id="isMovable1" value="t" {if $data.is_movable == 1}checked {/if}> oui
</label>
<label class="radio-inline">
  <input type="radio" name="is_movable" id="isMovable2" value="f" {if $data.is_movable == ""}checked {/if}> non
</label>
</div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.container_family_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>