<h2>Types d'identifiants</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=identifierTypeChange&identifier_type_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="identifierTypeList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>Nom</th>
<th>Code</th>
<th>Utilisé pour la recherche ?</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=identifierTypeChange&identifier_type_id={$data[lst].identifier_type_id}">
{$data[lst].identifier_type_name}
</a>
{else}
{$data[lst].identifier_type_name}
{/if}
</td>
<td>
{$data[lst].identifier_type_code}
</td>
<td>
{if $data[lst].used_for_search == 1}oui{else}non{/if}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>