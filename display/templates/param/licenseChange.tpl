<h2>{t}Création - Modification d'une licence de publication d'une collection{/t}</h2>
<div class="row">
  <div class="col-md-6">
    <a href="index.php?module=licenseList">{t}Retour à la liste{/t}</a>

    <form class="form-horizontal protoform" id="licenseForm" method="post" action="index.php">
      <input type="hidden" name="moduleBase" value="license">
      <input type="hidden" name="action" value="Write">
      <input type="hidden" name="license_id" value="{$data.license_id}">
      <div class="form-group">
        <label for="" class="control-label col-md-4"><span class="red">*</span> {t}Code de la licence :{/t}</label>
        <div class="col-md-8">
          <input id="license_name" type="text" class="form-control" name="license_name" value="{$data.license_name}"
            autofocus required></div>
      </div>
      <div class="form-group">
        <label for="license_url" class="control-label col-md-4"><span class="red">*</span> {t}URL :{/t}</label>
        <div class="col-md-8">
          <input id="license_url" type="text" class="form-control" name="license_url" value="{$data.license_url}"></div>
      </div>

      <div class="form-group center">
        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
        {if $data.license_id > 0 }
        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
        {/if}
      </div>
    </form>
  </div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>