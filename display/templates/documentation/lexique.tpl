<h2>Lexique</h2>
<div class="col-xl-8">
<div class="row">
<dl class="dl-horizontal lexique"> 
{section name=lst loop=$lexique}
<dt>{$lexique[lst].item}</dt>
<dd>{$lexique[lst].content}</dd>
{/section}
	</dl>
</div>
</div>
