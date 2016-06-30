<script >
$(document).ready(function() {
	$("#formLogin").submit(function (event) {
		var error = false;
		var message = "";
		/*
		 * Verifications
		 */
		 var mdp1 = $("#pass1").val();
		 var mdp2 = $("#pass2").val();
		 if (mdp1.length > 0 && mdp2.length > 0) {
			 if (mdp1 != mdp2) {
			 	error = true;
			 	message = "{$LANG["message"].39}";
			 } else if (verifyLength(mdp1) == false) {
			 	error = true;
			 	message = "{$LANG["message"].40}";
			 } else if (verifyComplexity(mdp1) == false) {
			 	error = true;
			 	message = "{$LANG["message"].41}";
			 }
		 }
		 $("#message").text(message);
		/*
	 	 * Blocage de l'envoi du formulaire
		 */
		 if (error == true)
			event.preventDefault();
	});

});

</script>

<h2>Saisie/modification d'un compte</h2>
<div class="row">
<div class="col-lg-6">
<a href="index.php?module=loginList">Retour à la liste des logins</a>

<form class="form-horizontal protoform" id="formLogin" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="login">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="id" value="{$data.id}">
<input type="hidden" name="password" value="{$data.password}">
	

<div class="form-group">
<label for="login" class="control-label col-md-4">{$LANG.login.0} <span class="red">*</span> :</label>
<div class="col-md-8">
<input id="login" type="text" class="form-control" name="login" value="{$data.login}" autofocus>
</div>
</div>

<div class="form-group">
<label for="nom" class="col-md-4 control-label">{$LANG.login.9} : </label>
<div class="col-md-8">
<input id="nom" type="text" class="form-control" name="nom" value="{$data.nom}"></div>
</div>
<div class="form-group">
<label for="prenom" class="col-md-4 control-label">{$LANG.login.10} : </label>
<div class="col-md-8">
<input id="prenom" type="text" class="form-control" name="prenom" value="{$data.prenom}">
</div>
</div>
<div class="form-group">
<label for="mail" class="col-md-4 control-label">{$LANG.login.8} : </label>
<div class="col-md-8">
<input type="email" id="mail" class="form-control" name="mail" value="{$data.mail}"> 
</div>
</div>
<div class="form-group">
<label for="datemodif" class="col-md-4 control-label">{$LANG.login.11} : </label>
<div class="col-md-8">
<input class="form-control" id="datemodif" name="datemodif" value="{$data.datemodif}" readonly>
</div>
</div>
<div class="form-group">
<label for="pass1" class="col-md-4 control-label">{$LANG.login.1} : </label>
<div class="col-md-8">
<input class="form-control" type="password" autocomplete="off" id="pass1" name="pass1" >
</div>
</div>
<div class="form-group">
<label for="pass2" class="col-md-4 control-label">{$LANG.login.12}</label> 
<div class="col-md-8">
<input type="password" class="form-control" id="pass2" autocomplete="off" name="pass2">
</div>
</div>
<div class="form-group">
<label for="generate" class="col-md-4 control-label">{$LANG.login.21}</label> 
<div class="col-md-2">
<input id="generate" type="button" class="btn btn-info" name="generate" value="{$LANG.login.22}" onclick="getPassword('pass1', 'pass2', 'motdepasse')">
</div>
<div class="col-md-6">
<label for="motdepasse" class="sr-only">Mot de passe généré</label>
<input name="motdepasse" id="motdepasse" size="20">
</div>
</div>
<div class="form-group">
<label for="actif" class="col-md-4 control-label">{$LANG.login.13}</label>
<span id="actif">
<label class="radio-inline">
<input type="radio" name="actif" value="1" {if $data.actif == 1}checked{/if}>{$LANG.message.yes}
</label>
<label class="radio-inline">
<input type="radio" name="actif" value="0" {if $data.actif == 0}checked{/if}>{$LANG.message.no}
</label>
</span>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<div class="row">
<div class="col-lg-6">
<div id="message"></div>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>

