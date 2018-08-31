{* Paramètres > Collections > Nouveau *}
<h2>{t}Création - Modification d'une collection{/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=collectionList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal protoform" id="collectionForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="collection">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="collection_id" value="{$data.collection_id}">
<div class="form-group">
<label for="collectionName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
<div class="col-md-8">
<input id="collectionName" type="text" class="form-control" name="collection_name" value="{$data.collection_name}" autofocus required>
</div>
</div>
<div class="form-group">
<label for="referentId"  class="control-label col-md-4">{t}Référent de la collection :{/t}</label>
<div class="col-md-8">
<select id="referentId" name="referent_id" class="form-control">
      <option value="" {if $data.referent_id == ""}selected{/if}>Choisissez...</option>
      {foreach $referents as $referent}
            <option value="{$referent.referent_id}" {if $data.referent_id == $referent.referent_id}selected{/if}>
            {$referent.referent_name}
            </option>
      {/foreach}
</select>
</div>
</div>

<div class="form-group">
<label for="groupes"  class="control-label col-md-4">{t}Groupes :{/t}</label>
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
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.collection_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>