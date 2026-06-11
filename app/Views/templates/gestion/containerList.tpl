<div class="container-fluid">
	<h2>{t}Contenants{/t}</h2>
</div>
{include file='gestion/containerSearchTab.tpl'}

{if $rights.manage == 1}
<div class="container-fluid">
	<div class="row">
		<div class="col-auto">
			<a href="containerChange?uid=0"><img src="display/images/new.png" height="25">
				{t}Nouveau contenant{/t}
			</a>
		</div>
	</div>
</div>
{/if}
{if $isSearch > 0}
{include file='gestion/containerListDetail.tpl'}
{/if}