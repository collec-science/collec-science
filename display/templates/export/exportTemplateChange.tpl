<h2>{t}Modification d'un modèle d'export{/t}</h2>
<div class="row">
  <div class="col-md-12">
    <a href="index.php?module=exportTemplateList">
      <img src="display/images/list.png" height="25">
      {t}Retour à la liste{/t}
    </a>
  </div>
</div>
<form id="exportTemplateForm" method="post" action="index.php">
  <div class="row">
    <div class="col-md-6 form-horizontal">
      <input type="hidden" name="moduleBase" value="exportTemplate">
      <input type="hidden" name="action" value="Write">
      <input type="hidden" name="export_template_id" value="{$data.export_template_id}">
      <div class="form-group">
        <label for="exportTemplateName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
        <div class="col-md-8">
          <input id="exportTemplateName" type="text" class="form-control" name="export_template_name" value="{$data.export_template_name}" autofocus required>
        </div>
      </div>
      <div class="form-group">
        <label for="exportTemplateDescription"  class="control-label col-md-4">{t}Description :{/t}</label>
        <div class="col-md-8">
          <textarea id="exportTemplateDescription" class="form-control" name="export_template_description" >{$data.export_template_description}</textarea>
        </div>
      </div>
      <div class="form-group">
        <label for="export_template_version"  class="control-label col-md-4">{t}Version :{/t}</label>
        <div class="col-md-8">
          <input id="export_template_version" type="text" class="form-control" name="export_template_version" value="{$data.export_template_version}">
        </div>
      </div>
      <div class="form-group">
          <label for="filename"  class="control-label col-md-4"><span class="red">*</span> {t}Nom du fichier généré :{/t}</label>
          <div class="col-md-8">
            <input id="filename" type="text" class="form-control" name="filename" value="{$data.filename}" required>
          </div>
        </div>
    </div>
    <div class="col-md-6">
      <!-- list of datasets-->
      <legend>{t}Liste des datasets à générer{/t}</legend>
      <div class="row  form-horizontal">
      {foreach $datasets as $dataset}
        <div class="col-md-6">
          <input class="  " type="checkbox" name="dataset[]" value="{$dataset.dataset_template_id}" {if $dataset.export_template_id > 0}checked{/if}>
        {$dataset.dataset_template_name} ({$dataset.dataset_type_name})</div>
      {/foreach}
      </div>
      </fieldset>
    </div>
    </div>
  <div class="form-group center">
    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
    {if $data.export_template_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
    {/if}
  </div>
</form>
  </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>