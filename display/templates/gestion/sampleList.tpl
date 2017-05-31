<h2>Rechercher des échantillons</h2>

	<div class="row">
	<div class="col-md-6">
{include file='gestion/sampleSearch.tpl'}
</div>
</div>
<div class="row">
<div class="col-md-12">
{if $droits.gestion == 1}
<a href="index.php?module=sampleChange&uid=0"><img src="display/images/new.png" height="25">Nouvel échantillon</a>
{/if}
{if $isSearch > 0}

{include file='gestion/sampleListDetail.tpl'}

{/if}
</div>
</div>