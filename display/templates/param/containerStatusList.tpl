<h2>Liste des statuts utilisables pour les conteneurs</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=containerStatusChange&container_status_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="containerStatusList" class="table table-bordered table-hover datatable " >
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
<a href="index.php?module=containerStatusChange&container_status_id={$data[lst].container_status_id}">
{$data[lst].container_status_name}
{else}
{$data[lst].container_status_name}
{/if}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>