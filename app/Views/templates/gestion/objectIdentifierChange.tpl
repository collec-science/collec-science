{* Objets > échantillons > Rechercher > UID d'un échantillon > section des identifiants > Nouvel identifiant... > *}
<h2>{t}Création - modification d'un identifiant{/t}</h2>

<div class="row">
<div class="col-md-6">
<a href="{$moduleListe}">
<img src="display/images/list.png" height="25">
{t}Retour à la liste{/t}
</a>
<a href="{$moduleParent}Display?uid={$object.uid}&activeTab={$activeTab}">
<img src="display/images/edit.gif" height="25">
{t}Retour au détail{/t} ({$object.uid} {$object.identifier})
</a>
<form class="form-horizontal protoform" id="{$moduleParent}Form" method="post" action="index.php">
<input type="hidden" name="object_identifier_id" value="{$data.object_identifier_id}">
<input type="hidden" name="moduleBase" value="{$moduleParent}objectIdentifier">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="uid" value="{$object.uid}">
<input type="hidden" name="activeTab" value="{$activeTab}">

<div class="form-group">
<label for="identifier_type_id" class="control-label col-md-4"><span class="red">*</span> {t}Type d'identifiant :{/t}</label>
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
<label for="object_identifier_value" class="control-label col-md-4"><span class="red">*</span> {t}Valeur :{/t}</label>
<div class="col-md-8">
<input id="object_identifier_value" name="object_identifier_value" required value="{$data.object_identifier_value}" class="form-control" >
</div>
</div>


<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.object_identifier_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
{$csrf}</form>
</div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>