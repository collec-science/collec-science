{* Objets > échantillons > *}
<h2>{t}Rechercher des échantillons{/t}</h2>

	<div class="row">
	<div class="col-lg-12">
{include file='gestion/sampleSearch.tpl'}
</div>
</div>
<div class="row">
<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
{if $droits.gestion == 1}
<a href="index.php?module=sampleChange&uid=0"><img src="display/images/new.png" height="25">{t}Nouvel échantillon{/t}</a>
{/if}
{if $isSearch > 0}

{include file='gestion/sampleListDetail.tpl'}

{/if}
</div>
</div>