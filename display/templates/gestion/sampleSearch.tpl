
<form class="form-horizontal protoform col-md-12" id="sample_search" action="index.php" method="GET">
<input id="moduleBase" type="hidden" name="moduleBase" value="{if strlen($moduleBase)>0}{$moduleBase}{else}sample{/if}">
<input id="action" type="hidden" name="action" value="{if strlen($action)>0}{$action}{else}List{/if}">
<input id="isSearch" type="hidden" name="isSearch" value="1">
<div class="row">
<div class="form-group">
<label for="name" class="col-md-2 control-label">uid ou identifiant :</label>
<div class="col-md-4">
<input id="name" type="text" class="form-control" name="name" value="{$sampleSearch.name}" title="uid, identifiant principal, identifiants secondaires (p. e. : cab:15 possible)">
</div>
<label for="project_id" class="col-md-2 control-label">Projet :</label>
<div class="col-md-4">
<select id="project_id" name="project_id" class="form-control">
<option value="" {if $sampleSearch.project_id == ""}selected{/if}>{$LANG.appli.2}</option>
{section name=lst loop=$projects}
<option value="{$projects[lst].project_id}" {if $projects[lst].project_id == $sampleSearch.project_id}selected{/if}>
{$projects[lst].project_name}
</option>
{/section}
</select>
</div>
</div>
</div>

<div class="row">
<div class="form-group">
<label for="container_family_id" class="col-md-2 control-label">UID entre :</label>
<div class="col-md-2">
<input id="uid_min" name="uid_min" class="nombre form-control" value="{$sampleSearch.uid_min}">
</div>
<div class="col-md-2">
<input id="uid_max" name="uid_max" class="nombre form-control" value="{$sampleSearch.uid_max}">
</div>

<label for="sample_type_id" class="col-md-2 control-label">Type :</label>
<div class="col-md-4">
<select id="sample_type_id" name="sample_type_id" class="form-control">
<option value="" {if $sampleSearch.sample_type_id == ""}selected{/if}>Sélectionnez...</option>
{section name=lst loop=$sample_type}
<option value="{$sample_type[lst].sample_type_id}" {if $sample_type[lst].sample_type_id == $sampleSearch.sample_type_id}selected{/if} title="{$sample_type[lst].sample_type_description}">
{$sample_type[lst].sample_type_name}
</option>
{/section}
</select>
</div>
</div>
</div>

<div class="row">
<label for="sampling_place_id" class="col-md-2 control-label">Lieu de prélèvement :</label>
<div class="col-md-4">
<select id="sampling_place_id" name="sampling_place_id" class="form-control">
<option value="" {if $sampleSearch.sampling_place_id == ""}selected{/if}>Sélectionnez...</option>
{section name=lst loop=$samplingPlace}
<option value="{$samplingPlace[lst].sampling_place_id}" {if $samplingPlace[lst].sampling_place_id == $sampleSearch.sampling_place_id}selected{/if}>
{$samplingPlace[lst].sampling_place_name}
</option>
{/section}
</select>
</div>

<label for="object_status_id" class="col-md-2 control-label">Statut :</label>
<div class="col-md-4">
<select id="object_status_id" name="object_status_id" class="form-control">
<option value="" {if $sampleSearch.object_status_id == ""}selected{/if}>Sélectionnez...</option>
{section name=lst loop=$objectStatus}
<option value="{$objectStatus[lst].object_status_id}" {if $objectStatus[lst].object_status_id == $sampleSearch.object_status_id}selected{/if}>
{$objectStatus[lst].object_status_name}
</option>
{/section}
</select>
</div>
</div>

<div class="row">
<div class="form-group">
<label for="limit" class="col-md-2 control-label">Nbre limite à afficher :</label>
<div class="col-md-2">
<input type="number" id="limit" name="limit" value="{$sampleSearch.limit}" class="form-control">
</div>
<div class="col-md-2">
<input type="submit" class="btn btn-success" value="{$LANG['message'][21]}">
</div>
</div>
</div>
</form>
</div>