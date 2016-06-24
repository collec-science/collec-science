<!-- Liste des conteneurs pour affichage -->
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
{section name=lst loop=$containers}
<tr>
<td class="text-center">
<a href="index.php?module=containerDisplay&uid={$containers[lst].uid}" title="Consultez le détail">
{$containers[lst].uid}
</td>
<td>
<a href="index.php?module=containerDisplay&uid={$containers[lst].uid}" title="Consultez le détail">
{$containers[lst].identifier}
</a>
</td>
<td >
{$containers[lst].container_status_name}
</td>
<td>
{$containers[lst].container_family_name}/
{$containers[lst].container_type_name}
</td>
<td>
{$containers[lst].storage_condition_name}
</td>
<td>
{$containers[lst].storage_product}
</td>
<td>
{$containers[lst].clp_classification}
</td>
</tr>
{/section}
</tbody>
</table>