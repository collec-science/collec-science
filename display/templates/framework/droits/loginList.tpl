{* Administration > ACL - logins > *}
<h2>{t}Liste des logins déclarés dans le module de gestion des droits{/t}</h2>
<div class="row">
	<div class="col-md-6">
		<a href="index.php?module=aclloginChange&acllogin_id=0">
			{t}Nouveau login...{/t}
		</a>
		<table id="loginListe" class="table table-bordered table-hover datatable" id="table_id" data-order='[[ 1, "asc" ]]'
			data-page-length='25'>
			<thead>
				<tr>
					<th>{t}Utilisateur{/t}</th>
					<th>{t}Login employé{/t}</th>
					<th>{t}Double identification activée ?{/t}</th>
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
					<td class="center">{if $data[lst].totp_key == 1}{t}oui{/t}{/if}</td>
				</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>
