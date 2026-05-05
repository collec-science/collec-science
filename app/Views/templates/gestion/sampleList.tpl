<script>
	$(document).ready(function () {
		/* Management of tabs */
		var activeTabResult = "";
		var myStorage = window.localStorage;
		try {
			activeTabResult = myStorage.getItem("sampleResultTab");
		} catch (Exception) {
		}
		try {
			if (activeTabResult.length > 0) {
				$("#" + activeTabResult).tab('show');
			}
		} catch (Exception) { }
		$('.nav-tabs > li > a').hover(function () {
			//$(this).tab('show');
		});
		$('.tabResult').on('shown.bs.tab', function () {
			myStorage.setItem("sampleResultTab", $(this).attr("id"));
		});
	});
</script>
<div class="container-fluid">
	<h2>{t}Échantillons{/t}</h2>
</div>
{include file='gestion/sampleSearchTab.tpl'}
<div class="container-fluid">
	<div class="row d-flex">
		{if $rights.manage == 1}
		<div class="col-auto">
			<a href="sampleChangeTab?uid=0"><img src="display/images/new.png" height="25">{t}Nouvel échantillon{/t}</a>
		</div>
		{/if}
		{if $isSearch > 0}
		{if $totalNumber > $sampleSearch["limit"] && $sampleSearch["limit"] > 0}
		<div class="col-auto">
			<span class="red">{t 1=$totalNumber 2=$sampleSearch["limit"] 3=$sampleSearch["page"]}Attention : seuls les %2 échantillons les plus récents à partir de la page %3 sont affichés sur un total de %1{/t}</span>
		</div>
		{/if}
	</div>
</div>
<div class="container-fluid">
	<ul class="nav nav-tabs  " id="tabResult" role="tablist">
		<li class="nav-item">
			<a class="nav-link tabResult active" id="tablist" data-bs-toggle="tab" role="tab" aria-controls="navlist" aria-selected="true" href="#navlist">
				{t}Liste{/t}
			</a>
		</li>
		<li class="nav-item">
			<a class="nav-link tabResult" id="tabmap" href="#navmap" data-bs-toggle="tab" role="tab" aria-controls="navmap" aria-selected="false">
				{t}Carte{/t}
			</a>
		</li>
	</ul>
	<div class="tab-content tab-content-white col-12 form-horizontal" id="tabresult-content">
		<div class="tab-pane active in" id="navlist" role="tabpanel" aria-labelledby="tablist">
			{include file='gestion/sampleListDetail.tpl'}
		</div>
		<div class="tab-pane fade" id="navmap" role="tabpanel" aria-labelledby="tabmap">
			{include file="gestion/sampleListMap.tpl"}
		</div>
	</div>
	{/if}
</div>