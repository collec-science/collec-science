<h2>Familles de containers</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=containerFamilyChange&container_family_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="containerFamilyList" class="table table-bordered table-hover datatable " >
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
<a href="index.php?module=containerFamilyChange&container_family_id={$data[lst].container_family_id}">
{$data[lst].container_family_name}
{else}
{$data[lst].container_family_name}
{/if}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>