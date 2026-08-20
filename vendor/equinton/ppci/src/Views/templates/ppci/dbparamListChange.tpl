<div class="container">
	<h2>{t}Paramètres pérennes de l'application{/t}</h2>
	<div class="row">
		<form id="dbparam" class="form-horizontal" method="post" action="dbparamWriteGlobal">
			<input type="hidden" name="moduleBase" value="dbparam">
			<input type="hidden" name="action" value="WriteGlobal">
			<table class="table table-bordered table-hover datatable-nopaging-nosort bg-form">
				<thead>
					<tr>
						<th>{t}Paramètre{/t}</th>
						<th>{t}Valeur{/t}</th>
						<th>{t}Description{/t}</th>
					</tr>
				</thead>
				<tbody>
					{section name=lst loop=$data}
					<tr>
						<td>{$data[lst].dbparam_name}</td>
						<td>
							<input class="form-control" name="id:{$data[lst].dbparam_id}"
								value="{$data[lst].dbparam_value}">
						</td>
						<td>
							{if $locale == 'fr'}
							{$data[lst].dbparam_description}
							{else}
							{$data[lst].dbparam_description_en}
							{/if}
						</td>
						{/section}
				</tbody>
			</table>
			<div class="row d-flex justify-content-center">
				<div class="col-auto">
					<button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
				</div>
			</div>
	</div>
	{$csrf}
	</form>
</div>