{* Paramètres > Types d'événement > Nouveau > *}
<h2>{t}Création - Modification d'un type d'événement{/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=eventTypeList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal protoform" id="eventTypeForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="eventType">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="event_type_id" value="{$data.event_type_id}">
<div class="form-group">
<label for="eventTypeName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
<div class="col-md-8">
<input id="eventTypeName" type="text" class="form-control" name="event_type_name" value="{$data.event_type_name}" autofocus required></div>
</div>
<div class="form-group">
<label for="is_sample"  class="control-label col-md-4">{t}Utilisable pour les échantillons :{/t}</label>
<div id="is_sample"class="col-md-8" >
<label class="radio-inline">
  <input type="radio" name="is_sample" id="isSample1" value="t" {if $data.is_sample == 1}checked {/if}> {t}oui{/t}
</label>
<label class="radio-inline">
  <input type="radio" name="is_sample" id="isSample2" value="f" {if $data.is_sample == ""}checked {/if}> {t}non{/t}
</label>
</div>
</div>
<div class="form-group">
<label for="is_container"  class="control-label col-md-4">{t}Utilisable pour les contenants :{/t}</label>
<div id="is_container"class="col-md-8" >
<label class="radio-inline">
  <input type="radio" name="is_container" id="isContainer1" value="t" {if $data.is_container == 1}checked {/if}> {t}oui{/t}
</label>
<label class="radio-inline">
  <input type="radio" name="is_container" id="isContainer2" value="f" {if $data.is_container == ""}checked {/if}> {t}non{/t}
</label>
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.event_type_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>