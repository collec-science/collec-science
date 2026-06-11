<div class="container">
<h2>{t}Lexique{/t}</h2>
<div class="col-8">
	<div class="row">
		<dl class="dl-horizontal lexique">
			{foreach $lexique as $k=>$v}
			<dt>{$k}</dt>
			<dd>{$v.0}</dd>
			{/foreach}
		</dl>
	</div>
</div>