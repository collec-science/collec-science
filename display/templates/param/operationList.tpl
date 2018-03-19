<h2>Opérations rattachées aux protocoles</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.collection == 1}
<a href="index.php?module=operationChange&operation_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="operationList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>protocole</th>
<th>Opération</th>
<th>Version</th>
<th>N° d'ordre</th>
{if $droits.collection == 1}
<th>Dupliquer</th>
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
{if $droits.collection == 1}
<a href="index.php?module=operationChange&operation_id={$data[lst].operation_id}">
{$data[lst].operation_name}
</a>
{else}
{$data[lst].operation_name}
{/if}
</td>
<td class="center">{$data[lst].operation_version}</td>
<td class="center">{$data[lst].operation_order}</td>
{if $droits.collection == 1}
<td class="center">
<a href="index.php?module=operationCopy&operation_id={$data[lst].operation_id}" title="Dupliquer l'opération">
<img src="display/images/copy.png" height="25">
</a>
</td>
{/if}
</tr>
{/section}
</tbody>
</table>
</div>
</div>
<script>
$(document).ready(function () { 
	var operationList = $("#operationList").DataTable() ;
	operationList.order([0,'desc'],[2,'asc']).draw();
});
</script>