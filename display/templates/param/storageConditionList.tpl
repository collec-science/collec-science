{* Paramètres > Conditions de stockage > *}
<h2>{t}Conditions de stockage{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=storageConditionChange&storage_condition_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="storageConditionList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>{t}Nom{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=storageConditionChange&storage_condition_id={$data[lst].storage_condition_id}">
{$data[lst].storage_condition_name}
</a>
{else}
{$data[lst].storage_condition_name}
{/if}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>