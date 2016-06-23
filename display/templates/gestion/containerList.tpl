<h2>Rechercher des conteneurs</h2>

	<div class="row">
	<div class="col-md-6">
{include file='gestion/containerSearch.tpl'}
</div>
</div>
<div class="row">
<div class="col-md-12">
{if $isSearch > 0}
{if $droits.gestion == 1}
<a href="index.php?module=containerChange&container_id=0"><img src="display/images/new.png" height="25">Nouveau conteneur</a>
{/if}
<table id="containerList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>UID</th>
<th>Identifiant ou nom</th>
<th>Statut</th>
<th>Type</th>
<th>Condition de stockage</th>
<th>Produit de stockage</th>
<th>Code CLP</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td class="text-center">
<a href="index.php?module=containerDisplay&container_id={$data[lst].container_id}" title="Consultez le détail">
{$data[lst].uid}
</td>
<td>
<a href="index.php?module=containerDisplay&container_id={$data[lst].container_id}" title="Consultez le détail">
{$data[lst].identifier}
</a>
</td>
<td >
{$data[lst].container_status_name}
</td>
<td>
{$data[lst].container_family_name}/
{$data[lst].container_type_name}
</td>
<td>
{$data[lst].storage_condition_name}
</td>
<td>
{$data[lst].storage_product}
</td>
<td>
{$data[lst].clp_classification}
</td>
</tr>
{/section}
</tbody>
</table>

{/if}
</div>
</div>