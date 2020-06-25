<script>
  $( document ).ready( function () {
    function isMetadata() {
      var columnName = $( "#column_name" ).val();
      var disabled = true;
      var required = false;
      if ( columnName == "metadata" ) {
        disabled = false;
        required = true;
      }
      $( "#metadata_name" ).prop( "disabled", disabled );
      $("#metadata_name").prop("required", required);
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
    $("#metadata_name").change(function() {
      var exportName = $("#export_name").val();
      if (exportName.length == 0 || exportName == "metadata") {
        $("#export_name").val($("#metadata_name").val());
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
        <label for="metadata_name" class="control-label col-md-4"><span class="red">*</span>
          {t}Nom du champ dans les métadonnées :{/t}
        </label>
        <div class="col-md-8">
          <input id="metadata_name" type="text" class="form-control" name="metadata_name" value="{$data.metadata_name}" >
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
              <option value="{$translator.translator_id}" {if $translator.translator_id==$data.translator_id} selected{/if}>{$tranlator.translator_name} </option>
            {/foreach}
          </select>
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
    <table id="datasetColumnList" class="table table-bordered table-hover datatable-nopaging " data-order='[[4,"asc"]]'>
      <thead>
        <tr>
          <th>{t}Nom de la colonne{/t}</th>
          <th class="lexical" data-lexical="metadata">{t}Nom de la variable si metadata{/t}</th>
          <th>{t}Nom dans le fichier d'export{/t}</th>
          <th class="lexical" data-lexical="translationTable">{t}Nom de la table de correspondance{/t}</th>
          <th>{t}Ordre de tri dans le fichier d'export{/t}</th>
        </tr>
      </thead>
      <tbody>
        {foreach $columns as $c}
          <tr>
            <td>
              <a href="index.php?module=datasetColumnChange&dataset_column_id={$c.dataset_column_id}&dataset_template_id={$data.dataset_template_id}">
                {$c.column_name}
              </a>
            </td>
            <td>{$c.metadata_name}</td>
            <td>{$c.export_name}</td>
            <td>{$c.translator_name}</td>
            <td>{$c.column_order}</td>
          </tr>
        {/foreach}
      </tbody>
    </table>
  </div>
</div>
