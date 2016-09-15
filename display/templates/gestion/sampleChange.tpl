<h2>Création - modification d'un échantillon</h2>
<div class="row col-md-12">
<a href="index.php?module=sampleList">
<img src="display/images/list.png" height="25">
Retour à la liste des échantillons
</a>
{if $data.uid > 0}
<a href="index.php?module=sampleDisplay&uid={$data.uid}">
<img src="display/images/box.png" height="25">Retour au détail
</a>
{elseif $sample_parent_uid > 0}
<a href="index.php?module=sampleDisplay&uid={$sample_parent_uid}">
<img src="display/images/box.png" height="25">Retour au détail
</a>
{/if}
</div>
<div class="row">
{if $data.parent_sample_id > 0}
<fieldset class="col-md-6">
<legend>Échantillon parent</legend>
<div class="form-display">
<dl class="dl-horizontal">
<dt>UID et référence :</dt>
<dd>
<a href="index.php?module=sampleDisplay&uid={$parent_sample.uid}">
{$parent_sample.uid} {$parent_sample.identifier}
</a>
</dd>
</dl>
<dl class="dl-horizontal">
<dt>Projet :</dt>
<dd>{$parent_sample.project_name}</dd>
</dl>
<dl class="dl-horizontal">
<dt>Type :</dt>
<dd>{$parent_sample.sample_type_name}</dd>
</dl>
</div>
</fieldset>
{/if}
</div>
<div class="row">
<fieldset class="col-md-6">
<legend>Échantillon</legend>
<form class="form-horizontal protoform" id="sampleForm" method="post" action="index.php">
<input type="hidden" name="sample_id" value="{$data.sample_id}">
<input type="hidden" name="moduleBase" value="sample">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="parent_sample_id" value="{$data.parent_sample_id}">

{include file="gestion/uidChange.tpl"}

<div class="form-group">
<label for="project_id" class="control-label col-md-4">Projet<span class="red">*</span> :</label>
<div class="col-md-8">
<select id="project_id" name="project_id" class="form-control" autofocus>
{section name=lst loop=$projects}
<option value="{$projects[lst].project_id}" {if $data.project_id == $projects[lst].project_id}selected{/if}>
{$projects[lst].project_name}
</option>
{/section}
</select>
</div>
</div>


<div class="form-group">
<label for="sample_type_id" class="control-label col-md-4">Type<span class="red">*</span> :</label>
<div class="col-md-8">
<select id="sample_type_id" name="sample_type_id" class="form-control">
{section name=lst loop=$sample_type}
<option value="{$sample_type[lst].sample_type_id}" {if $sample_type[lst].sample_type_id == $data.sample_type_id}selected{/if}>
{$sample_type[lst].sample_type_name} 
{if $sample_type[lst].multiple_type_id > 0}
/{$sample_type[lst].multiple_type_name} : {$sample_type[lst].multiple_unit}
{/if}
</option>
{/section}
</select>
</div>
</div>

<div class="form-group">
<label for="sample_date"  class="control-label col-md-4">Date de création de l'échantillon :</label>
<div class="col-md-8">
<input id="sample_date" class="form-control date" name="sample_date" value="{$data.sample_date}"></div>
</div>

<div class="form-group">
<label for="sample_creation_date"  class="control-label col-md-4">Date d'import dans la base de données :</label>
<div class="col-md-8">
<input id="sample_creation_date" class="form-control" name="sample_creation_date" readonly value="{$data.sample_date}"></div>
</div>
<fieldset>
<legend>Sous-échantillonnage (si le type le permet)</legend>
<div class="form-group">
<label for="multiple_value"  class="control-label col-md-4">
Quantité initiale de sous-échantillons ({$data.multiple_type_name}:{$data.multiple_unit}) :</label>
<div class="col-md-8">
<input id="multiple_value" class="form-control taux" name="multiple_value" value="{$data.multiple_value}"></div>
</div>
</fieldset>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.sample_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>

</form>
</fieldset>
</div>

<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>