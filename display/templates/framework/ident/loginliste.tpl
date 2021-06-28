<script>
$(document).ready(function() {
	var mails ="";
	$(".mail").each(function (i, elem){
		var mail = $(elem).text();
		if (mail.length > 0) {
			if (mails.length > 0) {
					mails += ";";
			}
			mails += mail;
		}
	});
	$("#mails").val(mails);
	$("#copyMails").click(function() {
		var temp = $("<input>");
		$("body").append(temp);
		temp.val($("#mails").val()).select();
		document.execCommand("copy");
		temp.remove();
	});
});
</script>
<h2>{t}Liste des logins déclarés dans la base de données{/t}</h2>

<a href="index.php?module=loginChange&id=0">{t}Nouveau login{/t}</a>
<div class="row">
	<div class="col-md-6">
		<table class="table table-bordered table-hover datatable" data-order='[[ 1, "asc" ]]'>
			<thead>
				<tr>
					<th>{t}Login{/t}</th>
					<th>{t}Nom - Prénom{/t}</th>
					<th>{t}Adresse e-mail{/t}</th>
					<th>{t}Actif{/t}</th>
					<th>{t}Compte utilisé pour service web{/t}</th>
					<th>{t}Mot de passe en attente de changement{/t}</th>
				</tr>
			</thead>
			<tbody>
				{section name=lst loop=$liste}
				<tr>
					<td><a href="index.php?module=loginChange&id={$liste[lst].id}">{$liste[lst].login}</a></td>
					<td>{$liste[lst].nom}&nbsp;{$liste[lst].prenom}</td>
					<td><div class="mail">{$liste[lst].mail}</div>&nbsp;</td>
					<td class="center">{if $liste[lst].actif == 1}{t}oui{/t}{/if}</td>
					<td class="center">{if $liste[lst].is_clientws == 1}{t}oui{/t}{/if}</td>
					<td class="center">
						{if $liste[lst].dbconnect_provisional_nb > 3 }{t}Compte bloqué{/t}
						{else if $liste[lst].dbconnect_provisional_nb > 3 }{t}oui{/t}
						{/if}
					</td>
				</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>
<div class="row">
	<div class="col-md-6">
		<form class="form-horizontal">
			<div class="form-group">
				<label for="mails" class="control-label col-md-4">
					{t}Adresses mails :{/t}
				</label>
			<div class="col-md-7">
				<input class="form-control" id="mails" readonly>
			</div>
			<div class="col-md-1">
				<img src="display/images/copy.png" height="24" id="copyMails">
			</div>
		</form>
	</div>
</div>
