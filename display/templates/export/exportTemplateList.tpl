<h2>{t}Modèles d'exports{/t}</h2>
<div class="row">
  <div class="col-md-6">
  <a href="index.php?module=exportTemplateChange&export_template_id=0">
    <img src="display/images/new.png" height="25">
  {t}Nouveau...{/t}
  </a>
  <table id="exportTemplateList" class="table table-bordered table-hover datatable " >
    <thead>
      <tr>
        <th>{t}Nom{/t}</th>
        <th>{t}Description{/t}</th>
        <th>{t}Version du modèle{/t}</th>
        <th>{t}Fichier compressé ?{/t}</th>
        <th>{t}Nom du fichier généré{/t}</th>
        <th>{t}Liste des datasets{/t}</th>
      </tr>
    </thead>
    <tbody>
      {foreach $data as $row}
      <tr>
        <td>
          <a href="index.php?module=exportTemplateChange&export_template_id={$row.export_template_id}">
          {$row.export_template_name}
          </a>
        </td>
        <td class="textareaDisplay">{$row.export_template_description}</td>
        <td>{$row.export_template_version}</td>
        <td class="center">{if $row.is_zipped == 1}{t}oui{/t}{/if}</td>
        <td>{$row.filename}</td>
        <td class="textareaDisplay">{$row.datasets}</td>
      </tr>
      {/foreach}
    </tbody>
  </table>
  </div>
</div>