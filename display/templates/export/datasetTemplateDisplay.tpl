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
            <dt>{t}Nom du fichier généré :{/t}</dt>
            <dd>{$data.filename}</dd>
          </dl>
          <dl class="dl-horizontal">
            <dt>{t}Séparateur (fichiers csv) :{/t}</dt>
            <dd>{$data.separator}</dd>
          </dl>
          <dl class="dl-horizontal">
            <dt>{t}Récupération du document le plus récent ?{/t}</dt>
            <dd>{if $data.only_last_document == 1}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
          </dl>
          <fieldset>
            <legend>{t}Fichiers XML{/t}</legend>
            <dl class="dl-horizontal">
              <dt>{t}Entête du fichier{/t}</dt>
              <dd>{$data.xmlroot}</dd>
            </dl>
            <dl class="dl-horizontal">
              <dt>{t}Nom des nœuds de chaque item{/t}</dt>
              <dd>{$data.xmlnodename}</dd>
            </dl>
          </fieldset>
      </div>
      </fieldset>
    </div>
  </div>
</div>
<div class="row">
  <div class="col-md-8">
    <fieldset>
      <legend>{t}Liste des informations exportées{/t}</legend>
      <a href="index.php?module=datasetColumnChange&dataset_column_id=0&dataset_template_id={$data.dataset_template_id}">
        <img src="display/images/new.png" height="25">
        {t}Nouvelle colonne{/t}
      </a>
      {include file="export/datasetColumnTable.tpl"}
    </fieldset>
  </div>
</div>