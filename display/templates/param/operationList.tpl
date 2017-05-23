<h2>Opérations rattachées aux protocoles</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=operationChange&operation_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="operationList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>protocole</th>
<th>Opération</th>
<th>N° d'ordre</th>
<th>Étiquette</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{$data[lst].protocol_year} {$data[lst].protocol_name} {$data[lst].protocol_version}
</td>
<td>
{if $droits.projet == 1}
<a href="index.php?module=operationChange&operation_id={$data[lst].operation_id}">
{$data[lst].operation_name}
</a>
{else}
{$data[lst].operation_name}
{/if}
</td>
<td class="center">{$data[lst].operation_order}</td>
<td>
<a href="index.php?module=labelChange&uid=0&operation_id={$data[lst].operation_id}">Créer une étiquette pour cette opération</a>
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>
<script>
$(document).ready(function () { 
	var operationList = $("#operationList").DataTable() ;
	operationList.order([[0,'desc'],[2,'asc']).draw();
});
</script>