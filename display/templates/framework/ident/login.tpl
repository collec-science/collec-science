	<script>
		$(document).ready(function() {
			var visible = false;
			$(".passwordVisible").click(function() {
				var fieldname = "#password";
				if (visible) {
					$(fieldname).prop("type", "password");
					visible = false;
					$(this).attr("src","display/images/framework/visible-24.png");
				} else {
					$(fieldname).prop("type", "text");
					visible = true;
					$(this).attr("src","display/images/framework/invisible-24.png");
				}
			});
		});
	</script>
	
	<div class="col-sm-12 col-md-6">
			<form id="theForm" method="POST" action="index.php">
					<input type="hidden" name="module" value={$module}>
	<div class="form-horizontal protoform">
	<div class="form-group">
	<label for="login" class="control-label col-sm-4">
	{t}Login :{/t}
	</label>
	<div class="col-sm-8"> 
	<input class="form-control input-lg" name="login" id="login" maxlength="64" required autofocus>
	</div>
	</div>
	<div class="form-group">
	<label for="login" class="control-label col-sm-4">
	{t}Mot de passe :{/t}
	</label>
	<div class="col-sm-7">
	<input  class="form-control input-lg" name="password" id="password" type="password" autocomplete="off" required maxlength="256">
	</div>
	<div class="col-md-1">
		<img src="display/images/framework/visible-24.png" height="16" id="passVisible" class="passwordVisible" >
	</div>
	</div>


  {if $tokenIdentityValidity > 0}
  	<div class="form-group center checkbox col-sm-12 input-lg">
  	<label>
  {$duration = $tokenIdentityValidity / 3600}
  <input type="checkbox" name="loginByTokenRequested" class="" value="1" checked>
  {t}Conserver la connexion pendant{/t} {$duration} {t}heures{/t} 
  </label>
  </div>
  {/if}
  {if $lostPassword == 1 }
  <div class="form-group center col-sm-12 input-lg">
  <a href="index.php?module=passwordlostIslost">{t}Mot de passe oublié ?{/t}</a>
  </div>
  {/if}
  <div class="form-group center">
	<button type="submit" class="btn btn-primary button-valid input-lg">{t}Se connecter{/t}</button>
	</div>
	</form>
	
	</div>
</div>

