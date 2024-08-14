{* Objets > Contenants > *}
<h3>{t}Contenants{/t}</h3>

<div class="row">
	<div class="col-lg-10 col-md-10 col-sm-12">
	{include file='gestion/containerSearchTab.tpl'}
	</div>
</div>
<div class="row">
<div class="col-md-12">
{if $rights.manage == 1}
<a href="containerChange?uid=0"><img src="display/images/new.png" height="25">{t}Nouveau contenant{/t}</a>
{/if}
{if $isSearch > 0}

{include file='gestion/containerListDetail.tpl'}

{/if}
</div>
</div>
