<h2>{t}Risques liés à la manipulation des contenants ou des échantillons{/t}</h2>
<div class="row">
	<div class="col-md-6">
		{if $rights.param == 1}
		<a href="riskChange?risk_id=0">
			{t}Nouveau...{/t}
		</a>
		{/if}
		<table id="riskList" class="table table-bordered table-hover datatable display">
			<thead>
				<tr>
					<th>{t}Description du risque, selon la nomenclature CLP{/t}</th>
				</tr>
			</thead>
			<tbody>
				{section name=lst loop=$data}
				<tr>
					<td>
					{if $rights.param == 1}
					<a href="riskChange?risk_id={$data[lst].risk_id}">
						{$data[lst].risk_name}
						{else}
						{$data[lst].risk_name}
						{/if}
						</td>
				</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>