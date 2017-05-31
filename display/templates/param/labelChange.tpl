<h2>Modification d'une étiquette</h2>
<div class="row">
<div class="col-md-12">
<a href="index.php?module=labelList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="labelForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="label">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="label_id" value="{$data.label_id}">
<input type="hidden" name="operation_id" value="{$operation_id}">
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
<li>x : coordonnée wgs84_x de l'objet (lieu de prélèvement ou de stockage suivant le cas)</li>
<li>y : coordonnée wgs84_y de l'objet</li>
<li>prod : produit utilisé pour la conservation</li>
<li>cd : date de création de l'échantillon (date de collecte ou d'extration d'un échantillon pré-existant)</li>
<li>et tous les codes d'identifiants secondaires - cf. paramètres > Types d'identifiants</li>
</ul>
</div>

{if $operation_id > 0 || $data.operation_id>0}
<div class="bg-info">
Métadonnées utilisables dans le QRcode et dans le texte de l'étiquette :
<ul id="list_metadata">
</ul>
</div>
<script>
$(function() {
    var ul=document.getElementById("list_metadata");
    var schema;
    if("{$operation_id}".length > 0){
      schema = "{$operation_schema}";
    }else{
      schema = "{$data.schema}";
    }
    schema = schema.replace(/&quot;/g,'"');

     $.each(JSON.parse(schema), function(i, obj) {
        var li=document.createElement("li");
        li.appendChild(document.createTextNode(obj.nom.replace(/ /g,"_")));
        ul.appendChild(li);
    });
});
</script>
{/if}

<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>