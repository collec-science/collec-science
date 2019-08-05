{* Paramètres > Types d'identifiants > Nouveau > *}
<h2>{t}Création - Modification d'un type d'identifiant{/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=identifierTypeList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal protoform" id="identifierTypeForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="identifierType">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="identifier_type_id" value="{$data.identifier_type_id}">
<div class="form-group">
<label for="identifierTypeName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
<div class="col-md-8">
<input id="identifierTypeName" type="text" class="form-control" name="identifier_type_name" value="{$data.identifier_type_name}" autofocus required></div>
</div>
<div class="form-group">
<label for="identifierTypeCode"  class="control-label col-md-4"><span class="red">*</span> {t}Code utilisé dans les étiquettes :{/t}</label>
<div class="col-md-8">
<input id="identifierTypeCode" type="text" class="form-control" name="identifier_type_code" value="{$data.identifier_type_code}" required></div>
</div>
<div class="form-group">
<label for="search"  class="control-label col-md-4"><span class="red">*</span> {t}Identifiant utilisé dans les recherches ?{/t}</label>
<div class="col-md-8" id="search">
<div class="radio">
 <label>
    <input type="radio" name="used_for_search" id="ufs1" value="1" {if $data.used_for_search == 1}checked{/if}>
    {t}oui{/t}
  </label>
</div>
<div class="radio">
 <label>
    <input type="radio" name="used_for_search" id="ufs2" value="0" {if $data.used_for_search == 0}checked{/if}>
    {t}non{/t}
  </label>
 </div>
 </div>
 </div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.identifier_type_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>

</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>