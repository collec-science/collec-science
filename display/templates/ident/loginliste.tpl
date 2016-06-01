<h2>Liste des logins déclarés dans la base de données</h2>
	<div class="row">
	<div class="col-md-6">
<a href="index.php?module=loginChange&id=0">{$LANG.login.5}</a>
<table class="table table-bordered table-hover" data-order='[[ 1, "asc" ]]' data-page-length='25'>
<thead>
	<tr>
		<th>{$LANG.login.6}</th>
		<th>{$LANG.login.7}</th>
		<th>{$LANG.login.8}</th>
		<th>{$LANG.login.13}</th>
	</tr>
</thead>
<tbody>
	 {section name=lst loop=$liste}
	<tr>
		<td><a href="index.php?module=loginChange&id={$liste[lst].id}">{$liste[lst].login}</a></td>
		<td>{$liste[lst].nom}&nbsp;{$liste[lst].prenom}</td>
		<td>{$liste[lst].mail}&nbsp;</td>
		<td>{if $liste[lst].actif == 1}{$LANG.message.yes}{else}{$LANG.message.no}{/if}</td>
	</tr>
	{/section}
</tbody>	
</table>

</div>
</div>