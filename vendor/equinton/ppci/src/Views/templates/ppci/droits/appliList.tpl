<h2>{t}Liste des applications disponibles dans le module de gestion des droits{/t}</h2>
	<div class="row">
	<div class="col-md-6">
<a href="appliChange?aclappli_id=0">
{t}Nouvelle application...{/t}
</a>
<table id="appliListe" class="table table-bordered table-hover datatable display" data-order='[[ 0, "asc" ]]' data-page-length='25'>
<thead>
<tr>
<th>{t}Modifier{/t}</th>
<th>{t}Nom de l'application{/t}</th>
<th>{t}Description{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td class="center"><a href="appliChange?aclappli_id={$data[lst].aclappli_id}">
<img src="display/images/edit.gif" height="25">
</a>
<td>
<a href="appliDisplay?aclappli_id={$data[lst].aclappli_id}">
{$data[lst].appli}
</a>
</td>
<td>{$data[lst].applidetail}</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>