<h2>Motifs de déstockage</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=storageReasonChange&movement_reason_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="storageReasonList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>Nom</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=storageReasonChange&movement_reason_id={$data[lst].movement_reason_id}">
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