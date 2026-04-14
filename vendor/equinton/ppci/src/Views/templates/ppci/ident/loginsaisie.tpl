<script>
	$(document).ready(function () {
		var visible = [false, false];
		var minLength = {$passwordMinLength};
		$("#formLogin").submit(function (event) {
			var error = false;
			var message = "";
			/*
			 * Verifications
			 */
			var mdp1 = $("#pass1").val();
			var mdp2 = $("#pass2").val();
			if (mdp1.length > 0 || mdp2.length > 0) {
				if (mdp1 != mdp2) {
					error = true;
					message = "{t}Les mots de passe ne sont pas identiques{/t}";
				} else if (mdp1.length < minLength) {
					error = true;
					message = "{t}Le mot de passe est trop court. Minimum : {/t}" + {$passwordMinLength} + " {t}caractères{/t}";
				} else if (verifyComplexity(mdp1) == false) {
					error = true;
					message = "{t}Le mot de passe n'est pas assez complexe (mixez 3 jeux de caractères parmi les minuscules, majuscules, chiffres et signes de ponctuation){/t}";
				}
			}
			$("#message").text(message);
			/*
			   * Blocage de l'envoi du formulaire
			 */
			if (error == true)
				event.preventDefault();
		});

		$("#generate").click(function () {
			getPassword('pass1', 'pass2', 'motdepasse', minLength);
		});

		$("#password_copy").click(function () {
			var temp = $("<input>");
			$("body").append(temp);
			temp.val($("#motdepasse").val()).select();
			document.execCommand("copy");
			temp.remove();
		});
		/*
		 * Ajouts pour gestion des services web
		 */
		$("#tokenws_reset").click(function () {
			$("#tokenws").val("");
		});
		$("#tokenws_copy").click(function () {
			var temp = $("<input>");
			$("body").append(temp);
			temp.val($("#tokenws").val()).select();
			document.execCommand("copy");
			temp.remove();
		});
		$("#is_clientws2").click(function () {
			$("#tokenws").val("");
		});

		$(".passwordVisible").click(function () {
			var fieldnumber = Number($(this).data("fieldnumber"));
			var fieldname = "#pass" + (fieldnumber + 1);
			if (visible[fieldnumber]) {
				$(fieldname).prop("type", "password");
				visible[fieldnumber] = false;
				$(this).attr("src", "display/images/framework/eye-open.png");
			} else {
				$(fieldname).prop("type", "text");
				visible[fieldnumber] = true;
				$(this).attr("src", "display/images/framework/eye-close.png");
			}
		});
	});

</script>
<div class="container">
	<div class="container">
<h2>{t}Saisie/modification d'un compte{/t}</h2>
	<div class="row">
		<a href="loginList">
			<img src="display/images/list.png" height="25">
			{t}Retour à la liste des logins{/t}
		</a>

		<form class="form-horizontal" id="formLogin" method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="login">
			<input type="hidden" name="action" value="Write">
			<input type="hidden" name="id" value="{$data.id}">
			<div class="row">
				<label for="login" class="form-label col-4"><span class="red">*</span> {t}Login :{/t}</label>
				<div class="col-8">
					<input id="login" type="text" class="form-control" name="login" value="{$data.login}" autofocus>
				</div>
			</div>
			<div class="row">
				<label for="nom" class="col-4 form-label">{t}Nom de famille :{/t} </label>
				<div class="col-8">
					<input id="nom" type="text" class="form-control" name="nom" value="{$data.nom}">
				</div>
			</div>
			<div class="row">
				<label for="prenom" class="col-4 form-label">{t}Prénom :{/t} </label>
				<div class="col-8">
					<input id="prenom" type="text" class="form-control" name="prenom" value="{$data.prenom}">
				</div>
			</div>
			<div class="row">
				<label for="mail" class="col-4 form-label">{t}Adresse e-mail :{/t} </label>
				<div class="col-8">
					<input type="email" id="mail" class="form-control" name="mail" value="{$data.mail}">
				</div>
			</div>
			<div class="row">
				<label for="datemodif" class="col-4 form-label">{t}Date :{/t} </label>
				<div class="col-8">
					<input class="form-control-plaintext" id="datemodif" name="datemodif" value="{$data.datemodif}" readonly>
				</div>
			</div>
			<div class="row">
				<label for="is_clientws_group" class="col-4 form-label">{t}Compte utilisé pour service web :{/t}
				</label>
				<div class="col-8 ">
					<div id="is_clientws_group" class="form-check form-check-inline">
						<input type="radio" class="form-check-input" id="is_clientws1" name="is_clientws" value="1" {if
							$data.is_clientws=='t' }checked{/if}>
						<label class="form-check-label" for="is_clientws1">{t}oui{/t}</label>
					</div>
					<div id="is_clientws_group2" class="form-check form-check-inline">
						<input type="radio" class="form-check-input" id="is_clientws2" name="is_clientws" value="0" {if
							$data.is_clientws !="t" }checked{/if}>
						<label class="form-check-label" for="is_clientws2">{t}non{/t}</label>
					</div>
				</div>
			</div>
			<div class="row">
				<label for="tokenws" class="col-4 form-label">{t}Jeton d'identification du service web :{/t}
				</label>
				<div class="col-8">
					<input class="form-control" id="tokenws" name="tokenws" value="{$data.tokenws}" readonly>
					<div class="input-group-append">
						<button class="btn btn-info" id="tokenws_copy" type="button">
							{t}Copier dans le presse-papier{/t}
						</button>
						<button class="btn btn-info" id="tokenws_reset" type="button">{t}Réinitialiser...{/t}</button>
					</div>
				</div>
			</div>
			{if $data.dbconnect_provisional_nb > 3}
			<div class="row">
				<div class="col-12 center red">
					{t}Le compte est verrouillé, le mot de passe n'a pas été changé après 3 connexions{/t}
				</div>
			</div>
			{/if}
			<div class="row">
				<label for="pass1" class="col-4 form-label"><span class="red">*</span> {t}Mot de passe :{/t}
				</label>
				<div class="col-7">
					<input class="form-control" type="password" autocomplete="off" id="pass1" name="pass1">
				</div>
				<div class="col-1">
					<img src="display/images/framework/eye-open.png" height="16" id="passVisible"
						class="passwordVisible" data-fieldnumber="0">
				</div>
			</div>
			<div class="row">
				<label for="pass2" class="col-4 form-label"><span class="red">*</span>
					{t}Répétez le mot de passe :{/t}
				</label>
				<div class="col-7">
					<input type="password" class="form-control" id="pass2" autocomplete="off" name="pass2">
				</div>
				<div class="col-1">
					<img src="display/images/framework/eye-open.png" height="16" id="passVisible2"
						class="passwordVisible" data-fieldnumber="1">
				</div>
			</div>
			<div class="row">
				<label for="generate" class="col-4 form-label">{t}Générez un mot de passe aléatoire{/t}</label>
				<div class="col-2">
					<input id="generate" type="button" class="btn btn-info" name="generate" value="{t}Générez{/t}">
				</div>
				<div class="col-6">
					<label for="motdepasse" class="sr-only">{t}Mot de passe généré{/t}</label>
					<input name="motdepasse" id="motdepasse" class="form-control">
					<button class="btn btn-info" id="password_copy" type="button">
						{t}Copier dans le presse-papier{/t}
					</button>
				</div>
			</div>
			<div class="col-12">
				<div class="bg-info">
					{t}Caractéristiques du mot de passe :{/t}
					<ul>
						<li>{t}Longueur minimale : {/t}{$passwordMinLength}&nbsp;{t}caractères{/t}</li>
						<li>{t}Au minimum 3 types de caractères différents parmi :{/t}
							<ul>
								<li>{t}des minuscules{/t}</li>
								<li>{t}des majuscules{/t}</li>
								<li>{t}des chiffres{/t}</li>
								<li>{t}des caractères de ponctuation ou spéciaux{/t}</li>
							</ul>
						</li>
					</ul>
				</div>
			</div>
			<div class="row">
				<label for="actif" class="col-4 form-label">{t}Actif{/t}</label>
				<div class="col-8">
					<div class="form-check form-check-inline">
						<input type="radio" id="actif1" class="form-check-input" name="actif" value="1" {if
							$data.actif==1}checked{/if}>
						<label class="form-check-label" for="actif1">
							{t}oui{/t}
						</label>
					</div>
					<div class="form-check form-check-inline">
						<input type="radio" id="actif0" class="form-check-input" name="actif" value="0" {if
							$data.actif==0}checked{/if}>
						<label class="form-check-label" for="actif0">
							{t}non{/t}
						</label>
					</div>
				</div>
				<div class="row">
					<label for="attempts" class="col-4 form-label">
						{t}Essais de connexion infructueux et date du dernier essai :{/t}
					</label>
					<div class="col-2">
						<input class="form-control" id="nbattempts" name="nbattempts" value="{$data.nbattempts}"
							readonly>
					</div>
					<div class="col-4">
						<input class="form-control" id="lastattempt" name="lastattempts" value="{$data.lastattempt}"
							readonly>
					</div>
					<div class="col-2">
						<input type="checkbox" class="form-check-input" id="resetattempts" name="resetattempts" value="1">
						<label class="form-check-label" for="resetattempts">{t}Réinitialiser...{/t}</label>
					</div>
				</div>
				<div class="row d-flex justify-content-center">
					<div class="col-auto">
						<button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
					</div>				
						{if $data.id > 0 }
						<div class="col-auto">
							<button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
						</div>		
						{/if}
					</div>
				</div>
				{$csrf}
		</form>
	</div>
	<div class="row">
		<div class="col-6">
			<div id="message"></div>
		</div>
	</div>
	<div class="row col-12 d-inline">
		<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
	</div>
</div>