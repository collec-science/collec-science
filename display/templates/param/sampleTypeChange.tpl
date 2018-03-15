<script>
$(document).ready(function () {
	$("#container_type_id").combobox();
	$("#metadata_id").combobox();
});
</script>

<h2>Modification d'un type d'échantillon</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=sampleTypeList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="sampleTypeForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="sampleType">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="sample_type_id" value="{$data.sample_type_id}">
<div class="form-group">
<label for="sampleTypeName"  class="control-label col-md-4">Nom<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="sampleTypeName" type="text" class="form-control" name="sample_type_name" value="{$data.sample_type_name}" autofocus required></div>
</div>

<div class="form-group">
<label for="container_type_id" class="control-label col-md-4">Type de container :</label>
<div class="col-md-8">
<select id="container_type_id" name="container_type_id" class="form-control">
<option value="" {if $data.container_type_id == ""}selected{/if}>{$LANG.appli.2}</option>
{section name=lst loop=$container_type}
<option value="{$container_type[lst].container_type_id}" {if $container_type[lst].container_type_id == $data.container_type_id}selected{/if}>
{$container_type[lst].container_type_name}
</option>
{/section}
</select>
</div>
</div>

<div class="form-group">
<label for="operation_id" class="control-label col-md-4">Protocole / opération :</label>
<div class="col-md-8">
<select id="operation_id" name="operation_id" class="form-control">
<option value="" {if $data.operation_id == ""}selected{/if}>{$LANG.appli.2}</option>
{section name=lst loop=$operation}
<option value="{$operation[lst].operation_id}" {if $operation[lst].operation_id == $data.operation_id}selected{/if}>
{$operation[lst].protocol_year} {$operation[lst].protocol_name} {$operation[lst].protocol_version} {$operation[lst].operation_name} {$operation[lst].operation_version}
</option>
{/section}
</select>
</div>
</div>

<div class="form-group">
<label for="metadata_id" class="control-label col-md-4">Modèle de métadonnées :</label>
<div class="col-md-8">
<select id="metadata_id" name="metadata_id" class="form-control">
<option value="" {if $data.metadata_id == ""}selected{/if}>{$LANG.appli.2}</option>
{section name=lst loop=$metadata}
<option value="{$metadata[lst].metadata_id}" {if $metadata[lst].metadata_id == $data.metadata_id}selected{/if}>
{$metadata[lst].metadata_name}
</option>
{/section}
</select>
</div>
</div>

<fieldset>
<legend>Sous-échantillonnage</legend>

<div class="form-group">
<label for="multiple_type_id" class="control-label col-md-4">Nature :</label>
<div class="col-md-8">
<select id="multiple_type_id" name="multiple_type_id" class="form-control">
<option value="" {if $data.multiple_type_id == ""}selected{/if}>{$LANG.appli.2}</option>
{section name=lst loop=$multiple_type}
<option value="{$multiple_type[lst].multiple_type_id}" {if $multiple_type[lst].multiple_type_id == $data.multiple_type_id}selected{/if}>
{$multiple_type[lst].multiple_type_name}
</option>
{/section}
</select>
</div>
</div>
<div class="form-group">
<label for="multiple_unit"  class="control-label col-md-4">Unité de base :</label>
<div class="col-md-8">
<input id="multiple_unit" type="text" class="form-control" name="multiple_unit" value="{$data.multiple_unit}" placeholder="écaille, mètre, cm3..."></div>
</div>

<div class="form-group">
<label for="identifier_generator_js"  class="control-label col-md-4">Code javascript de génération de l'identifiant :</label>
<div class="col-md-8">
<input id="identifier_generator_js" type="text" class="form-control" name="identifier_generator_js" value="{$data.identifier_generator_js}" placeholder='$("#collection_id option:selected").text()+"-"+$("#uid").val()'></div>
</div>

</fieldset>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.sample_type_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>

<div class="row">
<div class="col-md-12">
<div class="bg-info">
Consignes pour créer le code de génération de l'identifiant :
<ul>
<li>il s'agit de code javascript/JQuery, qui doit tenir en une seule instruction</li>
<li>l'opérateur de concaténation est le signe +
<li>la syntaxe de JQuery est basée sur $("#id"), où #id correspond à l'objet recherché
<li>la syntaxe varie en fonction du type de champ dont vous voulez récupérer la valeur :
<ul>
<li>pour les champs simples : $("#uid").val()</li>
<li>pour récupérer le contenu d'une boite de sélection : $("#collection_id option:selected").text()</li>
<li>pour récupérer le contenu d'une variable simple issue des métadonnées : $("input[name=nom_de_la_metadonnee]").val()</li>
<li>pour récupérer le contenu d'une métadonnée sélectionnée par bouton-radio : $("input[name=nom_de_la_metadonnee]:checked").val()</li>
</ul>
</li>
<li>Exemple : pour générer cet identifiant : nom_collection-uid-valeur_metadonnee :
<ul>
<li>$("#collection_id option:selected").text()+"-"+$("#uid").val()+"-"+$("input[name=espece]").val()</li>
(espece est le champ de métadonnées recherché)
</ul>
</li>
<li>Liste des champs utilisables :
<ul>
<li>uid : identifiant interne</li>
<li>object_status_id : statut de l'échantillon</li>
<li>collection_id : nom de la collection</li>
<li>sample_type_id : type d'échantillon</li>
<li>sample_creation_date : date de création de l'échantillon</li>
<li>sampling_date : date d'échantillonnage</li>
<li>expiration_date : date d'expiration de l'échantillon</li>
<li>wgs84_x : longitude</li>
<li>wgs84_y : latitude</li>
<li>et les variables disponibles dans les champs de métadonnées</li>
</ul>
</li>

</ul>
</div>
</div>
</div>