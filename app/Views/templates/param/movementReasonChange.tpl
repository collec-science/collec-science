{* Paramètres > Motifs de déstockage > Nouveau > *}
<h2>{t}Création - Modification des motifs de déstockage{/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="movementReasonList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal protoform" id="movementReasonForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="movementReason">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="movement_reason_id" value="{$data.movement_reason_id}">
<div class="form-group">
<label for="movementReasonName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
<div class="col-md-8">
<input id="movementReasonName" type="text" class="form-control" name="movement_reason_name" value="{$data.movement_reason_name}" autofocus required></div>
</div>


<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.movement_reason_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
{$csrf}</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>