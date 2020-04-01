<h2>{t}Création - Modification d'une extension de fichier téléchargeable{/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=mimeTypeList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal protoform" id="mimeTypeForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="mimeType">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="mime_type_id" value="{$data.mime_type_id}">
<div class="form-group">
<label for="extension"  class="control-label col-md-4"><span class="red">*</span> {t}Extension :{/t}</label>
<div class="col-md-8">
<input id="extension" type="text" class="form-control" name="extension" value="{$data.extension}" autofocus required></div>
</div>
<div class="form-group">
    <label for="contentType"  class="control-label col-md-4"><span class="red">*</span> {t}Type mime normalisé :{/t}</label>
    <div class="col-md-8">
    <input id="contentType" type="text" class="form-control" name="content_type" value="{$data.content_type}" required></div>
    </div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.mime_type_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
</form>
</div>
</div>

<div class="bg-info">
    {t}La liste officielle des types de média utilisables peut être consultée ici : {/t}
    <a href="https://www.iana.org/assignments/media-types/media-types.xhtml" target="_blank">https://www.iana.org/assignments/media-types/media-types.xhtml</a>

</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>