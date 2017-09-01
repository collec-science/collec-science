<h2>Lieux de prélèvement</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=samplingPlaceChange&sampling_place_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="samplingPlaceList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>Id</th>
<th>Nom</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>{$data[lst].sampling_place_id}</td>
<td>
{if $droits.param == 1}
<a href="index.php?module=samplingPlaceChange&sampling_place_id={$data[lst].sampling_place_id}">
{$data[lst].sampling_place_name}
</a>
{else}
{$data[lst].sampling_place_name}
{/if}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>