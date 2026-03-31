<h2>{t}Produits utilisés dans les contenants ou les échantillons{/t}</h2>
<div class="row">
	<div class="col-md-6">
		{if $rights.param == 1}
		<a href="productChange?product_id=0">
			{t}Nouveau...{/t}
		</a>
		{/if}
		<table id="productList" class="table table-bordered table-hover datatable display">
			<thead>
				<tr>
					<th>{t}Produit{/t}</th>
				</tr>
			</thead>
			<tbody>
				{section name=lst loop=$data}
				<tr>
					<td>
					{if $rights.param == 1}
					<a href="productChange?product_id={$data[lst].product_id}">
						{$data[lst].product_name}
						{else}
						{$data[lst].product_name}
						{/if}
						</td>
				</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>