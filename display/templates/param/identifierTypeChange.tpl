<h2>Modification d'un type d'identifiant</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=identifierTypeList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="identifierTypeForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="identifierType">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="identifier_type_id" value="{$data.identifier_type_id}">
<div class="form-group">
<label for="identifierTypeName"  class="control-label col-md-4">Nom<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="identifierTypeName" type="text" class="form-control" name="identifier_type_name" value="{$data.identifier_type_name}" autofocus required></div>
</div>
<div class="form-group">
<label for="identifierTypeCode"  class="control-label col-md-4">Code utilisé dans les étiquettes<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="identifierTypeCode" type="text" class="form-control" name="identifier_type_code" value="{$data.identifier_type_code}" required></div>
</div>
<div class="form-group">
<label for="search"  class="control-label col-md-4">Identifiant utilisé dans les recherches 
(uniquement des valeurs non numériques) ?<span class="red">*</span> :</label>
<div class="col-md-8" id="search">
<div class="radio">
 <label>
    <input type="radio" name="used_for_search" id="ufs1" value="1" {if $data.used_for_search == 1}checked{/if}>
    oui
  </label>
</div>
<div class="radio">
 <label>
    <input type="radio" name="used_for_search" id="ufs2" value="0" {if $data.used_for_search == 0}checked{/if}>
    non
  </label>
 </div>
 </div>
 </div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.identifier_type_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>

</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>