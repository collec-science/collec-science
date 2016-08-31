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
<th>Type de conteneur</th>
<th>Jeu de métadonnées</th>
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
{if $data[lst].metadata_set_id > 0}
<a href="index.php?module=metadataSetDisplay&metadata_set_id={$data[lst].metadata_set_id}>
{$data[lst].metadata_set_name}
</a>
{/if}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>