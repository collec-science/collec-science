<script >
$(document).ready(function() {
	$("#formPassword").submit(function (event) {
		var error = false;
		var message = "";
		/*
		 * Verifications
		 */
		 var mdp1 = $("#pass1").val();
		 var mdp2 = $("#pass2").val();
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
		 $("#message").text(message);
		/*
	 	 * Blocage de l'envoi du formulaire
		 */
		 if (error == true)
			event.preventDefault();
	});

});

</script>

<h2>{$LANG["login"][31]}</h2>
<div class="row">
<div class="col-lg-6">
<form id="formPassword" method="post" class="form-horizontal protoform" action="index.php">
<input type="hidden" name="id" value="{$data.id}">
<input type="hidden" name="module" value="loginChangePasswordExec">
<div class="form-group">
<label for="oldPassword" class="control-label col-md-4">{$LANG.login.23} :</label>
<div class="col-md-8">
<input id="oldPassword" class="form-control" type="password" name="oldPassword" autocomplete="off" autofocus>
</div>
</div>
<div class="form-group">
<label for="pass1" class="control-label col-md-4">
{$LANG.login.24} :
</label>
<div class="col-md-8">
<input type="password" id="pass1" class="form-control" autocomplete="off" name="pass1">
</div>
</div>
<div class="form-group">
<label for="pass1" class="control-label col-md-4">
{$LANG.login.12} :
</label>
<div class="col-md-8">
<input type="password" id="pass2" name="pass2" class="form-control" autocomplete="off">
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
</div>
<span id="helpBlock" class="help-block center">{$LANG.login.25}</span>
</form>
</div>
</div>
<div class="row">
<div class="col-lg-6">
<div id="message"></div>
</div>
</div>