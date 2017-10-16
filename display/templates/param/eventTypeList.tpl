<h2>Types d'événement</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=eventTypeChange&event_type_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="eventTypeList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>Nom</th>
<th>Valide pour les échantillons ?</th>
<th>Valide pour les containers ?</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=eventTypeChange&event_type_id={$data[lst].event_type_id}">
{$data[lst].event_type_name}
</a>
{else}
{$data[lst].event_type_name}
{/if}
</td>
<td class="center">
{if $data[lst].is_sample == 1}oui{else}non{/if}
</td>
<td class="center">
{if $data[lst].is_container == 1}oui{else}non{/if}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>