<h2>{t}Modification d'un modèle de dataset{/t}</h2>
<div class="row">
  <div class="col-md-6">
    <a href="datasetTemplateList">
      <img src="display/images/list.png" height="25">
      {t}Retour à la liste{/t}
    </a>
    {if $data.dataset_template_id > 0}
      &nbsp;
      <a href="datasetTemplateDisplay?dataset_template_id={$data.dataset_template_id}">
        <img src="display/images/display.png" height="25" title="{t}Afficher le détail...{/t}">{t}Détail du modèle{/t}
      </a>
    {/if}
    <form class="form-horizontal protoform" id="datasetTemplateForm" method="post" action="index.php">
      <input type="hidden" name="moduleBase" value="datasetTemplate">
      <input type="hidden" name="action" value="Write">
      <input type="hidden" name="dataset_template_id" value="{$data.dataset_template_id}">
      <div class="form-group">
        <label for="datasetTemplateName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
        <div class="col-md-8">
          <input id="datasetTemplateName" type="text" class="form-control" name="dataset_template_name" value="{$data.dataset_template_name}" autofocus required>
        </div>
      </div>
      <div class="form-group">
        <label for="dataset_type_id" class="control-label col-md-4"><span class="red">*</span> {t}Type :{/t}</label>
        <div class="col-md-8">
          <select id="dataset_type_id" name="dataset_type_id" class="form-control">
            {foreach $datasetTypes as $dt}
              <option value="{$dt.dataset_type_id}" {if $dt.dataset_type_id == $data.dataset_type_id}selected{/if}>
                {$dt.dataset_type_name}
              </option>
            {/foreach}
          </select>
        </div>
      </div>
      <div class="form-group">
        <label for="export_format_id" class="control-label col-md-4"><span class="red">*</span> {t}Format d'export :{/t}</label>
        <div class="col-md-8">
          <select id="export_format_id" name="export_format_id" class="form-control">
            {foreach $exportFormats as $ef}
              <option value="{$ef.export_format_id}" {if $ef.export_format_id == $data.export_format_id}selected{/if}>
                {$ef.export_format_name}
              </option>
            {/foreach}
          </select>
        </div>
      </div>
      <div class="form-group">
        <label for="filename"  class="control-label col-md-4"><span class="red">*</span> {t}Nom du fichier généré :{/t}</label>
        <div class="col-md-8">
          <input id="filename" type="text" class="form-control" name="filename" value="{$data.filename}" required>
        </div>
      </div>
      <div class="form-group">
        <label for="only_last_document"  class="control-label col-md-4">{t}Uniquement le document le plus récent (type document) :{/t}</label>
        <div class="col-md-8" id="only_last_document">
          <div class="radio">
            <label>
              <input type="radio" name="only_last_document" id="old1" value="0" {if $data.only_last_document != 1}checked{/if}>{t}non{/t}
            </label>
          </div>
          <div class="radio">
            <label>
                <input type="radio" name="only_last_document" id="old2" value="1" {if $data.only_last_document == 1}checked{/if}>{t}oui{/t}
            </label>
          </div>
       </div>
      </div>
      <div class="form-group">
        <label for="separator" class="control-label col-md-4">{t}Séparateur (fichiers CSV) :{/t}</label>
        <div class="col-md-8">
          <select id="separator" name="separator" class="form-control">
              <option value="" {if $data.separator == ''}selected{/if}>{t}Sélectionnez...{/t}</option>
              <option value="," {if $data.separator == ','}selected{/if}>{t}virgule{/t}</option>
              <option value=";" {if $data.separator == ';'}selected{/if}>{t}point-virgule{/t}</option>
              <option value="tab" {if $data.separator == 'tab'}selected{/if}>{t}tabulation{/t}</option>
          </select>
        </div>
      </div>
      <div class="form-group">
        <label for="xmlroot"  class="control-label col-md-4"> {t}Entête du fichier XML :{/t}</label>
        <div class="col-md-8">
          <input id="xmlroot" type="text" class="form-control" name="xmlroot" value="{$data.xmlroot}">
        </div>
      </div>
      <div class="form-group">
        <label for="xmlnodename"  class="control-label col-md-4"> {t}Nom du nœud XML pour les lignes traitées (non utilisé pour la description de la collection) :{/t}</label>
        <div class="col-md-8">
          <input id="xmlnodename" type="text" class="form-control" name="xmlnodename" value="{$data.xmlnodename}">
        </div>
      </div>
      <div class="form-group">
        <label for="xslcontent" class="control-label col-md-4">{t}Transformation XSL appliquée sur le fichier XML généré :{/t}</label>
        <div class="col-md-8">
          <textarea class="form-control textarea-edit" id="xslcontent" name="xslcontent" rows="10" placeholder='<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:template match="/">
  <echantillons>
    <xsl:for-each select="samples/sample">
      <sample>
      <type><xsl:value-of select="sample_type_name" /></type>
    <identifiant><xsl:value-of select="uid" /></identifiant>
      </sample>
    </xsl:for-each>
  </echantillons>
</xsl:template>
</xsl:stylesheet>'>{$data.xslcontent}</textarea>
        </div>
      </div>
      <div class="form-group center">
        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
        {if $data.dataset_template_id > 0 }
          <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
        {/if}
      </div>
    {$csrf}</form>
  </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>