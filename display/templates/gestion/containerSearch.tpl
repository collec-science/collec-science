<div class="row">
<form class="form-horizontal protoform" id="container_search" action="index.php" method="GET">
<input id="moduleBase" type="hidden" name="moduleBase" value="{if strlen($moduleBase)>0}{$moduleBase}{else}container{/if}">
<input id="action" type="hidden" name="action" value="{if strlen($action)>0}{$action}{else}List{/if}">
<div class="form-group">
<label for="name" class="col-md-2 control-label">uid :</label>
<div class="col-md-4">
<input id="name" type="text" class="form-control" name="name" value="{$search.name}">
</div>
<label for="container_status_id" class="col-md-2 control-label">Statut :</label>
<div class="col-md-4">
<select id="container_status_id" name="container_status_id" class="form-control">
<option value="" {if $search.container_status_id == ""}selected{/if}>Sélectionnez...</option>
{section name=lst loop=$container_status}
<option value="{$container_status[lst].container_status_id}" {if $container_status[lst].container_status_id == $search.container_status_id}selected{/if}>
{$container_status[lst].container_status_name}
</option>
{/section}
</select>
</div>
</div>
<div class="form-group">
<label for="container_family_id" class="col-md-2 control-label">Famille :</label>
<div class="col-md-4">
<select id="container_family_id" name="container_family_id" class="form-control">
<option value="" {if $search.container_family_id == ""}selected{/if}>Sélectionnez...</option>
{section name=lst loop=$container_family}
<option value="{$container_family[lst].container_family_id}" {if $container_family[lst].container_family_id == $search.container_family_id}selected{/if}>
{$container_family[lst].container_family_name}
</option>
{/section}
</select>
</div>
<label for="container_type_id" class="col-md-2 control-label">Type :</label>
<div class="col-md-4">
<select id="container_type_id" name="container_type_id" class="form-control">
<option value="" {if $search.container_type_id == ""}selected{/if}>Sélectionnez...</option>
{section name=lst loop=$container_type}
<option value="{$container_type[lst].container_type_id}" {if $container_type[lst].container_type_id == $search.container_type_id}selected{/if} title="{$container_type[lst].container_type_description}">
{$container_type[lst].container_type_name}
</option>
{/section}
</select>
</div>
</div>
<div class="form-group">
<label for="limit" class="col-md-2 control-label">Nbre limite à afficher :</label>
<div class="col-md-4">
<input type="number" id="limit" name="limit" value="{$search.limit}" class="form-control">
</div>
<div class="col-md-6">
<input type="submit" class="btn btn-success" value="{$LANG['message'][21]}">
</div>
</div>
</form>
</div>