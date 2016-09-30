<h2>Modification d'un projet</h2>
<div class="row">
<div class="col-md-12">
<a href="index.php?module=labelList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="labelForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="label">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="label_id" value="{$data.label_id}">
<div class="form-group">
<label for="labelName"  class="control-label col-md-4">Nom de l'étiquette<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="labelName" type="text" class="form-control" name="label_name" value="{$data.label_name}" autofocus required>
</div>
</div>
<div class="form-group">
<label for="xsl"  class="control-label col-md-4">Transformation XSL<span class="red">*</span> :</label>
<div class="col-md-8">
<textarea id="label_xsl" name="label_xsl" class="form-control" rows="20" required>{$data.label_xsl}</textarea>
</div>
</div>
<div class="form-group">
<label for="label_fields"  class="control-label col-md-4">Champs à insérer dans le QRCode (séparés par une virgule, sans espace)<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="label_fields" type="text" class="form-control" name="label_fields" value="{$data.label_fields}" required>
</div>
</div>


<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.label_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<div class="bg-info">
Champs utilisables dans le QRcode et dans le texte de l'étiquette :
<ul>
<li>uid (obligatoire) : identifiant unique</li>
<li>db (obligatoire) : code de la base de données (utilisé pour éviter de mélanger les échantillons entre plusieurs bases)</li>
<li>id : identifiant général</li>
<li>prj : code du projet</li>
<li>clp : code de risque</li>
<li>pn : nom du protocole</li>
<li>et tous les codes d'identifiants secondaires - cf. paramètres > Types d'identifiants</li>
</ul>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>