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
<label for="container_type_id" class="control-label col-md-4">Type :</label>
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
{$operation[lst].protocol_year} {$operation[lst].protocol_name} {$operation[lst].protocol_version} {$operation[lst].operation_name}
</option>
{/section}
</select>
</div>
</div>

<div class="form-group">
<label for="metadata_set_id"  class="control-label col-md-4">Jeu de métadonnées : </label>
<div id="is_container"class="col-md-8" >
<select name="metadata_set_id" id="metadata_set_id" class="form-control" >
<option value="" {if $data.metadata_set_id == ""} selected{/if}>
{$LANG.appli.2}
</option>
{section name=lst loop=$metadataSet}
<option value="{$metadataSet[lst].metadata_set_id}" {if $metadataSet[lst].metadata_set_id == $data.metadata_set_id}selected{/if}>
{$metadataSet[lst].metadata_set_name}
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