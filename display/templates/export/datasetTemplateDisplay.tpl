<h2>{t}Modification d'un modèle de dataset{/t}</h2>
<div class="row">
  <div class="col-md-6">
    <a href="index.php?module=datasetTemplateList">
      <img src="display/images/list.png" height="25">
      {t}Retour à la liste{/t}
    </a>
    <a href="index.php?module=datasetTemplateChange&dataset_template_id={$data.dataset_template_id}">
      <img src="display/images/edit.gif" height="25">
      {t}Modifier...{/t}
    </a>
    <fieldset>
      <legend>{t}Liste des informations exportées{/t}</legend>
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
              <td>{$c.translator_name}</td>
              <td>{$c.order}</td>
            </tr>
          {/foreach}
        </tbody>
      </table>

    </fieldset>