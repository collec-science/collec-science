<h2>Rechercher des conteneurs</h2>

	<div class="row">
	<div class="col-md-6">
{include file='gestion/containerSearch.tpl'}
</div>
</div>
<div class="row">
<div class="col-md-12">
{if $droits.gestion == 1}
<a href="index.php?module=containerChange&uid=0"><img src="display/images/new.png" height="25">Nouveau conteneur</a>
{/if}
{if $isSearch > 0}

{include file='gestion/containerListDetail.tpl'}

{/if}
</div>
</div>