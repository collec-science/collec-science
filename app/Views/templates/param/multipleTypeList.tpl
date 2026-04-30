<div class="container">
	<h2>{t}Types de sous-échantillonnage{/t}</h2>
	<div class="row">
		{if $rights.param == 1}
		<a href="multipleTypeChange?multiple_type_id=0">
			<img src="display/images/new.png" height="25">
			{t}Nouveau...{/t}
		</a>
		{/if}
		<table id="multipleTypeList" class="table table-bordered table-hover datatable display">
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
						<a href="multipleTypeChange?multiple_type_id={$data[lst].multiple_type_id}">
							{$data[lst].multiple_type_name}
						</a>
						{else}
						{$data[lst].multiple_type_name}
						{/if}
					</td>
				</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>