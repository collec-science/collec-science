<div class="container-fluid">
	<h2>{t}Contenants{/t}</h2>
</div>
{include file='gestion/containerSearchTab.tpl'}
{if $totalNumber > $containerSearch["limit"] && $containerSearch["limit"] > 0}
<div class="col-auto">
	<span class="red">{t 1=$totalNumber 2=$containerSearch["limit"] 3=$containerSearch["page"]}Attention : seuls les %2 contenants les plus récents à partir de la page %3 sont affichés sur un total de %1{/t}</span>
</div>
{/if}
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
{include file='gestion/containerListDetail.tpl'}