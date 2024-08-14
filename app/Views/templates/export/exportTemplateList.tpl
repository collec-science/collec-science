<h2>{t}Modèles d'exports{/t}</h2>
<div class="row">
  <div class="col-md-6">
  <a href="exportTemplateChange?export_template_id=0">
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
        <th>{t}Exporter le modèle vers d'autres instances Collec-Science{/t}</th>
      </tr>
    </thead>
    <tbody>
      {foreach $data as $row}
      <tr>
        <td>
          <a href="exportTemplateChange?export_template_id={$row.export_template_id}">
          {$row.export_template_name}
          </a>
        </td>
        <td class="textareaDisplay">{$row.export_template_description}</td>
        <td>{$row.export_template_version}</td>
        <td class="center">{if $row.is_zipped == 1}{t}oui{/t}{/if}</td>
        <td>{$row.filename}</td>
        <td class="textareaDisplay">{$row.datasets}</td>
        <td class="center">
          <a href="exportModelExec?export_model_name=export_template&keys[]={$row.export_template_id}">
            <img src="display/images/output.png" height="25">
          </a>
        </td>
      </tr>
      {/foreach}
    </tbody>
  </table>
  </div>
</div>

{if $rights["param"] == 1}
	<div class="row col-md-6">
		<fieldset>
			<legend>{t}Importer d'un modèle d'export provenant d'une autre base de données Collec-Science{/t}</legend>
			<form class="form-horizontal" id="exportTemplateImport" method="post" action="exportTemplateImport" enctype="multipart/form-data">
				<div class="form-group">
					<label for="upfile" class="control-label col-md-4"><span class="red">*</span> {t}Nom du fichier à importer (JSON) :{/t}</label>
					<div class="col-md-8">
						<input class="form-control" type="file" name="upfile" required>
					</div>
				</div>
				<div class="form-group center">
					<button type="submit" class="btn btn-primary">{t}Importer le modèle{/t}</button>
				</div>
				<div class="bg-info">
					{t}L'importation est basée sur un fichier exporté depuis une autre instance de Collec-Science.{/t}
					<br>
          {t}Les données sont fournies au format JSON, et permettent d'alimenter les tables :{/t}
          <ul>
            <li>export_template</li>
            <li>export_dataset</li>
            <li>dataset_template</li>
            <li>dataset_column</li>
            <li>translator</li>
          </ul>
				</div>
			{$csrf}</form>
		</fieldset>
	</div>
{/if}