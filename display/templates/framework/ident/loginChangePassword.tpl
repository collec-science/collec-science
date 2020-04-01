<script src="display/node_modules/zxcvbn/dist/zxcvbn.js">
</script>

<script >
$(document).ready(function() {
	var strength = {
        0: "{t}Le pire{/t} ☹ {t}Ajoutez un mot ou deux. Les mots inconnus sont meilleurs.{/t}",
        1: "{t}Mauvais{/t} ☹ {t}Ajoutez un mot ou deux. Les mots inconnus sont meilleurs.{/t}",
        2: "{t}Faible{/t} ☹ {t}Ajoutez un mot ou deux. Les mots inconnus sont meilleurs.{/t}",
        3: "{t}Bon{/t} ☺ {t}Ajoutez un ou deux autres mots. Les mots peu communs sont meilleurs, les mots inversés ne sont pas beaucoup plus difficiles à deviner.{/t}",
        4: "{t}Robuste{/t} ☻"
	}

var password = $("#pass1");
var meter = $('#password-strength-meter');
var text = $('#password-strength-text');
var  visible = [false, false, false];

$("#pass1").on('input', function()
{
    var val = $(this).val();
    var result = zxcvbn(val);
    
    // Update the password strength meter
    $('#password-strength-meter').val(result.score);
		console.log($('#password-strength-meter').val());
   
    // Update the text indicator
    if(val !== "") {
		message = "{t}Force du mot de passe :{/t} " + strength[result.score] ;
    }
    else {
        message = "";
    }
		$("#messageZxcvbn").val(result.score);
		$("#messageZxcvbn").attr("class","messageLevel"+result.score);
	$("#messageZxcvbn").text(message);
});

	$("#formPassword").submit(function (event) {
		var error = false;
		var message = "";
		var minLength = {$passwordMinLength};
		/*
		 * Verifications
		 */
		 var mdp1 = $("#pass1").val();
		 var mdp2 = $("#pass2").val();
		 if (mdp1 != mdp2) {
		 	error = true;
		 	message = "{t}Les mots de passe ne sont pas identiques{/t}";
		 } else if (mdp1.length < minLength ) {
		 	error = true;
		 	message = "{t}Le mot de passe est trop court. Minimum : {/t}" + {$passwordMinLength}+ " {t}caractères{/t}";
		 } else if (verifyComplexity(mdp1) == false) {
		 	error = true;
		 	message = "{t}Le mot de passe n'est pas assez complexe (mixez 3 jeux de caractères parmi les minuscules, majuscules, chiffres et signes de ponctuation){/t}";
		 }
		 $("#messageZxcvbn").val(4);
		 $("#messageZxcvbn").text(message);
		/*
	 	 * Blocage de l'envoi du formulaire
		 */
		 if (error == true)
			event.preventDefault();
	});

	$(".passwordVisible").click(function() {
		var fieldnumber = Number($(this).data("fieldnumber"));
		var fieldname = "#pass"+(fieldnumber + 1);
		if (visible[fieldnumber]) {
			$(fieldname).prop("type", "password");
			visible[fieldnumber] = false;
			$(this).attr("src","display/images/framework/visible-24.png");
		} else {
			$(fieldname).prop("type", "text");
			visible[fieldnumber] = true;
			$(this).attr("src","display/images/framework/invisible-24.png");
		}
	});

});

</script>

<h2>{t}Modifier le mot de passe{/t}</h2>
<div class="row">
<div class="col-lg-6">
<form id="formPassword" method="post" class="form-horizontal protoform" action="index.php">
<input type="hidden" name="id" value="{$data.id}">
<input type="hidden" name="is_expired" value="0">
{if $passwordLost == 1}
<input type="hidden" name="token" value="{$token}">
<input type="hidden" name="module" value="passwordlostReinitwrite">
{else}
<input type="hidden" name="module" value="loginChangePasswordExec">
<div class="form-group">
<label for="oldPassword" class="control-label col-md-4">{t}Ancien mot de passe :{/t}</label>
<div class="col-md-7">
<input id="pass3" class="form-control" type="password" name="oldPassword" autocomplete="off" autofocus>
</div>
<div class="col-md-1">
	<img src="display/images/framework/visible-24.png" height="16" id="passVisible" class="passwordVisible" data-fieldnumber="2">
</div>
</div>
{/if}
<div class="form-group">
<label for="pass1" class="control-label col-md-4">
{t}Nouveau mot de passe :{/t}
</label>
<div class="col-md-7">
<input type="password" id="pass1" class="form-control" autocomplete="off" name="pass1">
</div>
<div class="col-md-1">
	<img src="display/images/framework/visible-24.png" height="16" id="passVisible" class="passwordVisible" data-fieldnumber="0">
</div>
<div class="col-md-12 center">
	<meter min="0" low="1" optimum="2" high="3" max="4" id="password-strength-meter"></meter>
	<div id="messageZxcvbn" class="messageLevel"></div>
</div>

</div>
<div class="form-group">
<label for="pass2" class="control-label col-md-4">
{t}Répétez le mot de passe :{/t}
</label>
<div class="col-md-7">
<input type="password" id="pass2" name="pass2" class="form-control" autocomplete="off">
</div>
<div class="col-md-1">
	<img src="display/images/framework/visible-24.png" height="16" id="passVisible2" class="passwordVisible" data-fieldnumber="1">
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
</div>
<span id="helpBlock" class="help-block center">{t}Longueur minimale du mot de passe :{/t} {$passwordMinLength} {t}caractères{/t}
	<br>
{t}Il doit comprendre au minimum 3 types de caractères différents
(minuscule, majuscule, chiffre, ponctuation et autre symboles){/t}</span>
</form>
</div>
</div>
