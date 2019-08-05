<h2>{t}Liste des logins déclarés dans la base de données{/t}</h2>
	<div class="row">
	<div class="col-md-6">
<a href="index.php?module=loginChange&id=0">{t}Nouveau login{/t}</a>
<table class="table table-bordered table-hover" data-order='[[ 1, "asc" ]]' data-page-length='25'>
<thead>
	<tr>
		<th>{t}Login{/t}</th>
		<th>{t}Nom - Prénom{/t}</th>
		<th>{t}Adresse e-mail{/t}</th>
		<th>{t}Actif{/t}</th>
		<th>{t}Compte utilisé pour service web{/t}</th>
	</tr>
</thead>
<tbody>
	 {section name=lst loop=$liste}
	<tr>
		<td><a href="index.php?module=loginChange&id={$liste[lst].id}">{$liste[lst].login}</a></td>
		<td>{$liste[lst].nom}&nbsp;{$liste[lst].prenom}</td>
		<td>{$liste[lst].mail}&nbsp;</td>
		<td class="center">{if $liste[lst].actif == 1}{t}oui{/t}{/if}</td>
		<td class="center">{if $liste[lst].is_clientws == 1}{t}oui{/t}{/if}</td>
	</tr>
	{/section}
</tbody>	
</table>

</div>
</div>