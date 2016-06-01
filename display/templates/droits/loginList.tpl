<h2>Liste des logins déclarés dans le module de gestion des droits</h2>
	<div class="row">
	<div class="col-md-6">
<a href="index.php?module=aclloginChange&acllogin_id=0">
Nouveau login...
</a>
<table id="loginListe" class="table table-bordered table-hover datatable" id="table_id"
		data-order='[[ 1, "asc" ]]' data-page-length='25'>
<thead>
<tr>
<th>Utilisateur</th>
<th>Login employé</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
<a href="index.php?module=aclloginChange&acllogin_id={$data[lst].acllogin_id}">
{$data[lst].logindetail}
</a>
</td>
<td>{$data[lst].login}</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>