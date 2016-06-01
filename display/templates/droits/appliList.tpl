<h2>Liste des applications disponibles dans le module de gestion des droits</h2>
	<div class="row">
	<div class="col-md-6">
<a href="index.php?module=appliChange&aclappli_id=0">
Nouvelle application...
</a>
<table id="appliListe" class="table table-bordered table-hover datatable" data-order='[[ 0, "asc" ]]' data-page-length='25'>
<thead>
<tr>
<th>Modifier</th>
<th>Nom de l'application</th>
<th>Description</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td class="center"><a href="index.php?module=appliChange&aclappli_id={$data[lst].aclappli_id}">
<img src="display/images/edit.gif" height="25">
</a>
<td>
<a href="index.php?module=appliDisplay&aclappli_id={$data[lst].aclappli_id}">
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