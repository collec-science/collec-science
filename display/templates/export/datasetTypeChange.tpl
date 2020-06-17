<h2>{t}Modification d'un type de dataset{/t}</h2>
<p class="legend">{t}La modification d'un type de dataset est déconseillé, en raison des impacts sur le fonctionnement du module d'exportation{/t}</p>
<div class="row">
  <div class="col-md-12">
    <a href="index.php?module=datasetTypeList">
      <img src="display/images/list.png" height="25">
      {t}Retour à la liste{/t}
    </a>
    <form class="form-horizontal protoform" id="datasetTypeForm" method="post" action="index.php">
      <input type="hidden" name="moduleBase" value="datasetType">
      <input type="hidden" name="action" value="Write">
      <input type="hidden" name="dataset_type_id" value="{$data.dataset_type_id}">
      <div class="form-group">
        <label for="datasetTypeName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
        <div class="col-md-8">
          <input id="datasetTypeName" type="text" class="form-control" name="dataset_type_name" value="{$data.dataset_type_name}" autofocus required>
        </div>
      </div>
      <div class="form-group">
        <label for="fields"  class="control-label col-md-4">{t}Liste des champs utilisables dans le dataset, au format JSON :{/t}</label>
        <div class="col-md-8">
          <input id="fields" type="text" class="form-control" name="fields" value="{$data.fields}" >
        </div>
      </div>
      <div class="form-group center">
        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
        {if $data.dataset_type_id > 0 }
          <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
        {/if}
      </div>
    </form>
  </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>