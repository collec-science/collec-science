{* Paramètres > Motifs de déstockage > *}
<h2>{t}Motifs de déstockage{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=movementReasonChange&movement_reason_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="movementReasonList" class="table table-bordered table-hover datatable " data-order='[[1,"asc"]]' >
<thead>
<tr>
<th>{t}Clé{/t}</th>
<th>{t}Nom{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td class="center">{$data[lst].movement_reason_id}</td>
<td>
{if $droits.param == 1}
<a href="index.php?module=movementReasonChange&movement_reason_id={$data[lst].movement_reason_id}">
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
