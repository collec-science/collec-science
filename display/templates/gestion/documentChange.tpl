<div class="row">
<form id="documentForm" class="form-horizontal protoform" method="post" action="index.php"  enctype="multipart/form-data">
<input type="hidden" name="document_id" value="0">
<input type="hidden" name="uid" value="{$data.uid}">
<input type="hidden" name="module" value="{$moduleParent}documentWrite">
<div class="form-group">
<label for="documentName" class="control-label col-md-4">
Fichier(s) à importer :
<br>(doc, jpg, png, pdf, xls, xlsx, docx, odt, ods, csv)
</label>
<div class="col-md-8">
<input id="documentName" type="file" class="form-control" name="documentName[]" size="40" multiple>
</div>
</div>
<div class="form-group">
<label for="documentName" class="control-label col-md-4">
Description :
</label>
<div class="col-md-8">
<input id="description" name="description" class="form-control">
</div>
</div>
<div class="form-group">
<label for="document_creation_date" class="control-label col-md-4">
Date de création du document :
</label>
<div class="col-md-8">
<input id="document_creation_date" name="document_creation_date" class="form-control date">
</div>
</div>
<div class="form-group center">
 <button type="submit" class="btn btn-primary">{$LANG["message"].19}</button>
</div>
</form>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>
</div>
