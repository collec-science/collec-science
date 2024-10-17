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
<h2>{t}Liste des logins déclarés dans la base de données{/t}</h2>

<a href="loginChange?id=0">{t}Nouveau login{/t}</a>
<div class="row">
	<div class="col-lg-8">
		<div class="row">
			<div class="col-lg-12">
				<table class="table table-bordered table-hover datatable-searching display" data-order='[[ 1, "asc" ]]'>
					<thead>
						<tr>
							<th>{t}Login{/t}</th>
							<th>{t}Nom - Prénom{/t}</th>
							<th>{t}Adresse e-mail{/t}</th>
							<th>{t}Actif{/t}</th>
							<th>{t}Compte utilisé pour service web{/t}</th>
							<th>{t}Mot de passe en attente de changement{/t}</th>
							<th>{t}Nombre d'essais de connexion infructueux{/t}</th>
							<th>{t}Heure du dernier essai infructueux{/t}</th>
						</tr>
					</thead>
					<tbody>
						{section name=lst loop=$data}
						<tr>
							<td><a href="loginChange?id={$data[lst].id}">{$data[lst].login}</a></td>
							<td>{$data[lst].nom}&nbsp;{$data[lst].prenom}</td>
							<td>
								<div class="mail">{$data[lst].mail}</div>&nbsp;
							</td>
							<td class="center">{if $data[lst].actif == 1}{t}oui{/t}{/if}</td>
							<td class="center">{if $data[lst].is_clientws == 't'}{t}oui{/t}{/if}</td>
							<td class="center">
								{if $data[lst].dbconnect_provisional_nb > 3 }{t}Compte bloqué{/t}
								{else if $data[lst].dbconnect_provisional_nb > 3 }{t}oui{/t}
								{/if}
							</td>
							<td class="center">{if $data[lst].nbattempts > 0}{$data[lst].nbattempts}{/if}</td>
							<td>{$data[lst].lastattempt}</td>
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
	</div>
</div>