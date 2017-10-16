<h2>Types d'échantillons</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=sampleTypeChange&sample_type_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="sampleTypeList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>Nom</th>
<th>Id</th>
<th>Type de container</th>
<th>Protocole / operation</th>
<th>Sous-échantillonnage</th>
<th>Modèle de métadonnées</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=sampleTypeChange&sample_type_id={$data[lst].sample_type_id}">
{$data[lst].sample_type_name}
</a>
{else}
{$data[lst].sample_type_name}
{/if}
</td>
<td class="center">{$data[lst].sample_type_id}</td>
<td>{$data[lst].container_type_name}</td>
<td>
{$data[lst].protocol_year} {$data[lst].protocol_name} {$data[lst].protocol_version} {$data[lst].operation_name} {$data[lst].operation_version} 
</td>
<td>
{if $data[lst].multiple_type_id > 0}
{$data[lst].multiple_type_name} : {$data[lst].multiple_unit}
{/if}
</td>
<td>{$data[lst].metadata_name}</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>