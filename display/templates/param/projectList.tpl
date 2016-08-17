<h2>Projets</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=projectChange&project_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="projectList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>Nom du projet</th>
<th>Id</th>
<th>Groupes de login autorisés</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=projectChange&project_id={$data[lst].project_id}">
{$data[lst].project_name}
</a>
{else}
{$data[lst].project_name}
{/if}
</td>
<td class="center">{$data[lst].project_id}</td>
<td>
{$data[lst].groupe}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>