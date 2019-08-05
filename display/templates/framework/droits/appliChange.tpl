{* Administration > ACL droits > Nom de l'appli > Modifier > *}
<h2>{t}Modification d'une application (module de gestion des droits){/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=appliList">{t}Retour à la liste des applications{/t}</a>
<form class="form-horizontal protoform" id="appliForm" method="post" action="index.php">
<input type="hidden" name="aclappli_id" value="{$data.aclappli_id}">
<input type="hidden" name="moduleBase" value="appli">
<input type="hidden" name="action" value="Write">
<div class="form-group">

<label for="appli" class="control-label col-md-4"><span class="red">*</span> {t}Nom de l'application :{/t}</label>
<div class="col-md-8">
<input id="appli" type="text" name="appli" class="form-control" value="{$data.appli}" autofocus required>
</div>
</div>

<div class="form-group">
<label for="applidetail" class="control-label col-md-4">{t}Description :{/t} </label>
<div class="col-md-8">
<input id="applidetail" type="text" class="form-control" name="applidetail" value="{$data.applidetail}">
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.aclappli_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>

</form>
</div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>