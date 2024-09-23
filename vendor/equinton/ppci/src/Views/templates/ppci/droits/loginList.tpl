<script >
	$(document).ready(function () {
		var mails = "";
		$(".mail").each(function (i, elem) {
			var mail = $(elem).text();
			if (mail.length > 0) {
				if (mails.length > 0) {
					mails += ";";
				}
				mails += mail;
			}
		});
		$("#mails").val(mails);
		$("#copyMails").click(function () {
			var temp = $("<input>");
			$("body").append(temp);
			temp.val($("#mails").val()).select();
			document.execCommand("copy");
			temp.remove();
			$("#message").text("{t}Adresses enregistrées dans le presse-papiers{/t}");
			$("#messageDiv").show();
		});
	});
</script>
<h2>{t}Liste des logins déclarés dans le module de gestion des droits{/t}</h2>
<div class="row">
	<div class="col-md-6">
		<a href="aclloginChange?acllogin_id=0">
			{t}Nouveau login...{/t}
		</a>
		<table id="loginListe" class="table table-bordered table-hover datatable-searching" id="table_id" data-order='[[ 0, "asc" ]]'
			data-page-length='25'>
			<thead>
				<tr>
					<th>{t}Utilisateur{/t}</th>
					<th>{t}Login employé{/t}</th>
					<th>{t}Email{/t}</th>
					<th>{t}Double identification activée ?{/t}</th>
				</tr>
			</thead>
			<tbody>
				{section name=lst loop=$data}
				<tr>
					<td>
						<a href="aclloginChange?acllogin_id={$data[lst].acllogin_id}">
							{$data[lst].logindetail}
						</a>
					</td>
					<td>{$data[lst].login}</td>
					<td class="nowrap"><div class="mail">{$data[lst].email}</div></td>
					<td class="center">{if $data[lst].totp_key == 1}{t}oui{/t}{/if}</td>
				</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<form class="form-horizontal">
			<div class="form-group">
				<label for="mails" class="control-label col-md-2">
					{t}Adresses mails :{/t}
				</label>
				<div class="col-md-9">
					<input class="form-control" id="mails" readonly>
				</div>
				<div class="col-md-1">
					<img src="display/images/copy.png" height="24" id="copyMails">
				</div>
			</div>
		</form>
	</div>
</div>
