<script>
  $(document).ready(function() {
    function filenameCalculate() {
      var filename = $("#filename").val();
      var filearray = filename.split(".");
      var nbpoint = filename.match(/\./g).length;
      var radical = filearray[0];
      if (nbpoint > 0) {
        var extension = filearray[nbpoint + 1];
      } else {
        var extension = "csv";
      }

      /* Get if zipped is selected */
      if ($("#is_zipped1").prop("checked") ) {
        extension = "zip";
      } else {
        /* Count the number of datasets */
        var nbdataset = 0;
        $('.dataset').each(function(i, obj) {
          if ($(obj).prop("checked")) {
            nbdataset ++;
          }
        });
        if (nbdataset > 1) {
          extension = "zip";
        }
      }
      if (extension == "zip") {
        $("#filename").val(radical+"."+extension);
      }
    }
    $(".zipped").change(function() {
      filenameCalculate();
    });
    $(".dataset").change(function() {
      filenameCalculate();
    })
    $("#exportTemplateForm").submit( function() {
      filenameCalculate();
    });
  });
</script>
<h2>{t}Modification d'un modèle d'export{/t}</h2>
<div class="row">
  <div class="col-md-12">
    <a href="exportTemplateList">
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
          <label for="is_zipped"  class="control-label col-md-4">{t}Fichier compressé (si un seul fichier généré) ?{/t}</label>
          <div class="col-md-8" id="is_zipped">
            <div class="radio">
              <label>
                <input type="radio" class="zipped" name="is_zipped" id="is_zipped0" value="0" {if $data.is_zipped != 1}checked{/if}>{t}non{/t}
              </label>
            </div>
            <div class="radio">
              <label>
                  <input type="radio" class="zipped" name="is_zipped" id="is_zipped1" value="1" {if $data.is_zipped == 1}checked{/if}>{t}oui{/t}
              </label>
            </div>
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
          <input class="dataset" type="checkbox" name="dataset[]" value="{$dataset.dataset_template_id}" {if $dataset.export_template_id > 0}checked{/if}>
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
{$csrf}</form>
  </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
