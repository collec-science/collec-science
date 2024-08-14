{* Paramètres > Conditions de stockage > Nouveau > *}
<h2>{t}Création - Modification d'une condition de stockage{/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="storageConditionList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal protoform" id="loginForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="storageCondition">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="storage_condition_id" value="{$data.storage_condition_id}">
<div class="form-group">
<label for="storageConditionName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
<div class="col-md-8">
<input id="storageConditionName" type="text" class="form-control" name="storage_condition_name" value="{$data.storage_condition_name}" autofocus required></div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.storage_condition_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
{$csrf}</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>