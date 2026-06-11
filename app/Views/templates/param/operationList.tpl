<div class="container">
	<h2>{t}Opérations rattachées aux protocoles{/t}</h2>
	<div class="row d-flex">

		{if $rights.collection == 1}
		<div class="col-auto">
			<a href="operationChange?operation_id=0">
				<img src="display/images/new.png" height="25">
				{t}Nouveau...{/t}
			</a>
		</div>
		{/if}
		<div class="col-auto">{$help}</div>
	</div>
	<table id="operationList" class="table table-bordered table-hover datatable display" data-order='[[0,"asc"],[3,"asc"],[2,"asc"]]'>
		<thead>
			<tr>
				<th>{t}Protocole{/t}</th>
				<th>{t}Opération{/t}</th>
				<th>{t}Version{/t}</th>
				<th>{t}N° d'ordre{/t}</th>
				<th>{t}Code (pour les importations){/t}</th>
				{if $rights.collection == 1}
				<th>{t}Dupliquer{/t}</th>
				{/if}
			</tr>
		</thead>
		<tbody>
			{section name=lst loop=$data}
			<tr>
				<td>
					{$data[lst].protocol_year} {$data[lst].protocol_name} {$data[lst].protocol_version}
				</td>
				<td>
					{if $rights.collection == 1}
					<a href="operationChange?operation_id={$data[lst].operation_id}">
						{$data[lst].operation_name}
					</a>
					{else}
					{$data[lst].operation_name}
					{/if}
				</td>
				<td class="center">{$data[lst].operation_version}</td>
				<td class="center">{$data[lst].operation_order}</td>
				<td>{$data[lst].operation_code}</td>
				{if $rights.collection == 1}
				<td class="center">
					<a href="operationCopy?operation_id={$data[lst].operation_id}" title="{t}Dupliquer l'opération{/t}">
						<img src="display/images/copy.png" height="25">
					</a>
				</td>
				{/if}
			</tr>
			{/section}
		</tbody>
	</table>
</div>
