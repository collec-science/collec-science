{* Objets > échantillons > Rechercher > UID d'un échantillon > section Sous-échantillons si disponible > Nouveau... > *}
<h2>{t}Création - modification d'un prélèvement ou d'une restitution de sous-échantillon{/t}</h2>

<div class="row">
<div class="col-md-6">
<a href="index.php?module={$moduleListe}">
<img src="display/images/list.png" height="25">
{t}Retour à la liste{/t}
</a>
<a href="index.php?module={$moduleParent}Display&uid={$object.uid}">
<img src="display/images/edit.gif" height="25">
{t}Retour au détail{/t} ({$object.uid} {$object.identifier})
</a>
<form class="form-horizontal protoform" id="subsampleForm" method="post" action="index.php">
<input type="hidden" name="subsample_id" value="{$data.subsample_id}">
<input type="hidden" name="sample_id" value="{$data.sample_id}">
<input type="hidden" name="moduleBase" value="subsample">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="uid" value="{$object.uid}">
<input type="hidden" name="subsample_login" value="{$data.subsample_login}">

<div class="form-group">
<label for="subsampling_date" class="control-label col-md-4"><span class="red">*</span> {t}Date :{/t}</label>
<div class="col-md-8">
<input id="subsample_date" name="subsample_date" required value="{$data.subsample_date}" class="form-control datetimepicker" >
</div>
</div>

<div class="form-group">
<label for="movement_type_id" class="control-label col-md-4"><span class="red">*</span> {t}Mouvement :{/t}</label>
<div class="col-md-8">
<label class="radio-inline">
  <input type="radio" name="movement_type_id" id="movement_type_id1" value="1" {if $data.movement_type_id ==1}checked{/if}> {t}Entrée dans le stock{/t}
</label>
<label class="radio-inline">
  <input type="radio" name="movement_type_id" id="movement_type_id2" value="2" {if $data.movement_type_id ==2}checked{/if}> {t}Sortie du stock{/t}
</label>
</div>
</div>

<div class="form-group">
<label for="subsample_quantity" class="control-label col-md-4"><span class="red">*</span> {t 1=$data.multiple_unit}Quantité (%1) :{/t}</label>
<div class="col-md-8">
<input id="subsample_quantity" name="subsample_quantity" value="{$data.subsample_quantity}" class="form-control taux" >
</div>
</div>

<div class="form-group">
  <label for="borrower_id" class="control-label col-md-4">{t}Emprunteur :{/t}</label>
  <div class="col-md-8">
    <select id="borrower_id" name="borrower_id" class="form-control">
      <option value="" {if $data.borrower_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
      {foreach $borrowers as $borrower}
        <option value="{$borrower.borrower_id}" {if $borrower.borrower_id == $data.borrower_id}selected{/if}>
          {$borrower.borrower_name}
        </option>
      {/foreach}
    </select>
  </div>
</div>

<div class="form-group">
<label for="subsample_comment" class="control-label col-md-4">{t}Commentaire :{/t}</label>
<div class="col-md-8">
<textarea id="subsample_comment" name="subsample_comment"  class="form-control" rows="3">{$data.subsample_comment}</textarea>
</div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.subsample_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
</form>
</div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
