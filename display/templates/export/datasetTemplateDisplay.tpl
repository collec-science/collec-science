<h2>{t}Affichage du modèle de dataset{/t} <i>{$data.dataset_template_name}</i></h2>
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
    <div class="row">
      <fieldset >
        <legend>{t}Détails{/t}</legend>
        <div class="form-display">
          <dl class="dl-horizontal">
            <dt>{t}Format du fichier généré :{/t}</dt>
            <dd>{$data.export_format_name}</dd>
          </dl>
          <dl class="dl-horizontal">
            <dt>{t}Type de dataset :{/t}</dt>
            <dd>{$data.dataset_type_name}</dd>
          </dl>
          <dl class="dl-horizontal">
            <dt>{t}Séparateur (fichiers csv) :{/t}</dt>
            <dd>{$data.separator}</dd>
          </dl>
          <dl class="dl-horizontal">
            <dt>{t}Récupération du document le plus récent ?{/t}</dt>
            <dd>{if $data.only_last_document == 1}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
          </dl>
      </div>
      </fieldset>
    </div>
    <fieldset>
      <legend>{t}Liste des informations exportées{/t}</legend>
      <a href="index.php?module=datasetColumnChange&dataset_column_id=0&dataset_template_id={$data.dataset_template_id}">
        <img src="display/images/new.png" height="25">
        {t}Nouvelle colonne{/t}
      </a>
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
    </fieldset>
  </div>
</div>