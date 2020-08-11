<script>
  $( document ).ready( function () {
    function isMetadata() {
      var columnName = $( "#column_name" ).val();
      var disabled = true;
      var required = false;
      if ( columnName == "metadata" || columnName == "identifiers" || columnName == "parent_identifiers" ) {
        disabled = false;
        required = true;
      }
      $( "#subfield_name" ).prop( "disabled", disabled );
      $("#subfield_name").prop("required", required);
    }
    $( "#column_name" ).change( function () {
      isMetadata();
      /**
       * set the value into export_name
       */
       var exportName = $("#export_name").val();
       if (exportName.length == 0) {
         $("#export_name").val($("#column_name").val());
       }
    } );
    $("#subfield_name").change(function() {
      var exportName = $("#export_name").val();
      if (exportName.length == 0 || exportName == "metadata" || exportName == "identifiers" || exportName == "parent_identifiers") {
        $("#export_name").val($("#subfield_name").val());
      }
    })
    /**
     * Activation at form load
     */
    isMetadata();
  } );
</script>
<h2>{t}Modification des colonnes du modèle{/t} {$template.dataset_template_name}</h2>
<div class="row">
  <div class="col-md-6">
      <a href="index.php?module=datasetTemplateList">
          <img src="display/images/list.png" height="25">
          {t}Retour à la liste{/t}
        </a>&nbsp;
    <a href="index.php?module=datasetTemplateDisplay&dataset_template_id={$data.dataset_template_id}">
      <img src="display/images/display.png" height="25">
      {t}Retour au modèle{/t}
    </a>
    &nbsp;
    <a href="index.php?module=datasetColumnChange&dataset_column_id=0&dataset_template_id={$data.dataset_template_id}">
        <img src="display/images/new.png" height="25">
        {t}Nouvelle colonne{/t}
      </a>
    <form class="form-horizontal protoform" id="datasetColumnForm" method="post" action="index.php">
      <input type="hidden" name="moduleBase" value="datasetColumn">
      <input type="hidden" name="action" value="Write">
      <input type="hidden" name="dataset_template_id" value="{$data.dataset_template_id}">
      <input type="hidden" name="dataset_column_id" value="{$data.dataset_column_id}">
      <div class="form-group">
        <label for="column_name" class="control-label col-md-4"><span class="red">*</span> {t}Nom de la colonne à
          exporter :{/t}</label>
        <div class="col-md-8">
          <select id="column_name" name="column_name" class="form-control">
            {foreach $fields as $field}
              <option value="{$field}" {if $field==$data.column_name} selected{/if}>{$field} </option>
            {/foreach}
          </select>
        </div>
      </div>
      <div class="form-group">
        <label for="subfield_name" class="control-label col-md-4"><span class="red">*</span>
          {t}Nom du champ dans les métadonnées ou nom de l'identifiant secondaire :{/t}
        </label>
        <div class="col-md-8">
          <input id="subfield_name" type="text" class="form-control" name="subfield_name" value="{$data.subfield_name}" >
        </div>
      </div>
      <div class="form-group">
        <label for="export_name" class="control-label col-md-4"><span class="red">*</span>
          {t}Nom dans l'export :{/t}
        </label>
        <div class="col-md-8">
          <input id="export_name" type="text" class="form-control" name="export_name" value="{$data.export_name}" required>
        </div>
      </div>
      <div class="form-group">
        <label for="translator_id" class="control-label col-md-4 lexical" data-lexical="translationTable"> {t}Nom de la table de correspondance :{/t}</label>
        <div class="col-md-8">
          <select id="translator_id" name="translator_id" class="form-control">
            <option value="" {if $data.translator_id == ""} selected{/if}>{t}Choisissez...{/t}</option>
            {foreach $translators as $translator}
              <option value="{$translator.translator_id}" {if $translator.translator_id==$data.translator_id} selected{/if}>{$translator.translator_name} </option>
            {/foreach}
          </select>
        </div>
      </div>
      <div class="form-group">
        <label for="mandatory"  class="control-label col-md-4">{t}Contenu obligatoire pour l'export ?{/t}</label>
        <div class="col-md-8" id="mandatory">
          <div class="radio">
            <label>
              <input type="radio" name="mandatory" id="mandatory0" value="0" {if $data.mandatory != 1}checked{/if}>{t}non{/t}
            </label>
          </div>
          <div class="radio">
            <label>
                <input type="radio" name="mandatory" id="mandatory1" value="1" {if $data.mandatory == 1}checked{/if}>{t}oui{/t}
            </label>
          </div>
        </div>
      </div>
      <div class="form-group">
        <label for="default_value" class="control-label col-md-4">
          {t}Valeur par défaut, si aucune n'est renseignée, ou contenu du fichier pour le type arbitrary_content :{/t}
        </label>
        <div class="col-md-8">
          <textarea id="default_value" type="text" class="form-control" name="default_value" rows="5">{$data.default_value}</textarea>
        </div>
      </div>
      <div class="form-group">
        <label for="date_format" class="control-label col-md-4">
          {t}Formatage de la date (format PHP). Exemple : d/m/Y H:i:s{/t}
        </label>
        <div class="col-md-8">
          <input id="date_format" type="text" class="form-control" name="date_format" value="{$data.date_format}" >
        </div>
      </div>
      <div class="form-group">
        <label for="column_order" class="control-label col-md-4"><span class="red">*</span>
          {t}Numéro d'ordre dans l'export :{/t}
        </label>
        <div class="col-md-8">
          <input id="column_order" type="number" class="form-control number" name="column_order" value="{$data.column_order}" required>
        </div>
      </div>
      <div class="form-group center">
        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
        {if $data.dataset_column_id > 0 }
          <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
        {/if}
      </div>
    </form>
  </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
<div class="row">
  <div class="col-lg-8 col-md-12">
    {include file="export/datasetColumnTable.tpl"}
  </div>
</div>
