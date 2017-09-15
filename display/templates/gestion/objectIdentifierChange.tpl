<h2>Création - modification d'un identifiant</h2>

<div class="row">
<div class="col-md-6">
<a href="index.php?module={$moduleParent}List">
<img src="{$display}/images/list.png" height="25">
Retour à la liste
</a>
<a href="index.php?module={$moduleParent}Display&uid={$object.uid}">
<img src="{$display}/images/edit.gif" height="25">
Retour au détail ({$object.uid} {$object.identifier})
</a>
<form class="form-horizontal protoform" id="{$moduleParent}Form" method="post" action="index.php">
<input type="hidden" name="object_identifier_id" value="{$data.object_identifier_id}">
<input type="hidden" name="moduleBase" value="{$moduleParent}objectIdentifier">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="uid" value="{$object.uid}">




<div class="form-group">
<label for="identifier_type_id" class="control-label col-md-4">Type d'identifiant<span class="red">*</span> :</label>
<div class="col-md-8">
<select id="identifier_type_id" name="identifier_type_id" class="form-control">
{section name=lst loop=$identifierType}
<option value="{$identifierType[lst].identifier_type_id}" {if $identifierType[lst].identifier_type_id == $data.identifier_type_id}selected{/if}>
{$identifierType[lst].identifier_type_name} ({$identifierType[lst].identifier_type_code})
</option>
{/section}
</select>
</div>
</div>

<div class="form-group">
<label for="object_identifier_value" class="control-label col-md-4">Valeur<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="object_identifier_value" name="object_identifier_value" required value="{$data.object_identifier_value}" class="form-control" >
</div>
</div>


<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.object_identifier_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>

<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>