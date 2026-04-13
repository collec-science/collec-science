<div class="container">
<h2>{t}Motifs de déstockage{/t}</h2>
<div class="row">
	<div class="col-6">
		{if $rights.param == 1}
		<a href="movementReasonChange?movement_reason_id=0">
			{t}Nouveau...{/t}
		</a>
		{/if}
		<table id="movementReasonList" class="table table-bordered table-hover datatable display">
			<thead>
				<tr>
					<th>{t}Nom{/t}</th>
				</tr>
			</thead>
			<tbody>
				{section name=lst loop=$data}
				<tr>
					<td>
					{if $rights.param == 1}
					<a href="movementReasonChange?movement_reason_id={$data[lst].movement_reason_id}">
						{$data[lst].movement_reason_name}
						{else}
						{$data[lst].movement_reason_name}
						{/if}
						</td>
				</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>