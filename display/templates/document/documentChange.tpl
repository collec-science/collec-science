<div class="formSaisie">
<form id="documentForm" method="post" action="index.php"  enctype="multipart/form-data">
<input type="hidden" name="module" value="documentWrite">
<input type="hidden" name="document_id" value="0">
<input type="hidden" name="parent_id" value="{$parent_id}">
<input type="hidden" name="parentIdName" value="{$parentIdName}">
<input type="hidden" name="moduleParent" value="{$moduleParent}">
<input type="hidden" name="parentType" value="{$parentType}">
<dl>
<dt>Fichier(s) à importer :
<br>(doc, jpg, png, pdf, xls, xlsx, docx, odt, ods, csv)
</dt>
<dt><input type="file" name="documentName[]" size="40" multiple></dt>
</dl>
<dl>
<dt>Description :</dt>
<dd>
<input type="text" name="document_description" value="" size="40">
</dd>
</dl>
<div class="formBouton">
<input class="submit" type="submit" value="Enregistrer">
</div>
</form>
</div>