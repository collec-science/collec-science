<h2>Types de containers</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=containerTypeChange&container_type_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="containerTypeList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>Nom</th>
<th>Id</th>
<th>Famille</th>
<th>Description</th>
<th>Nbre<br>d'emplacements</th>
<th>Condition de stockage</th>
<th>Produit utilisé</th>
<th>Code CLP (risque)</th>
<th>Modèle d'étiquette</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=containerTypeChange&container_type_id={$data[lst].container_type_id}">
{$data[lst].container_type_name}
</a>
{else}
{$data[lst].container_type_name}
{/if}
</td>
<td class="center">{$data[lst].container_type_id}</td>
<td >
{$data[lst].container_family_name}
</td>
<td class="textareaDisplay">{$data[lst].container_type_description}</td>
<td>
L : {$data[lst].lines} C : {$data[lst].columns}
{if $data[lst].lines > 1}
<br>
1ère ligne : 
{if $data[lst].first_line == "T"}haut
{else}bas
{/if}
{/if}
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
<td>
{$data[lst].label_name}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>