{* Paramètres > Statuts des objets > *}
<h2>{t}Liste des statuts utilisables pour les objets{/t}</h2>
<div class="row">
	<div class="col-md-6">
		<table id="objectStatusList" class="table table-bordered table-hover datatable ">
			<thead>
				<tr>
					<th>{t}Id{/t}</th>
					<th>{t}Nom{/t}</th>
				</tr>
			</thead>
			<tbody>
				{section name=lst loop=$data}
				<tr>
					<td class="center">{$data[lst].object_status_id}</td>
					<td>
						{$data[lst].object_status_name}
					</td>
				</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>
