<script>
	$(document).ready(function () {
		var visible = false;
		$(".passwordVisible").click(function () {
			var fieldname = "#password";
			if (visible) {
				$(fieldname).prop("type", "password");
				visible = false;
				$(this).attr("src", "display/images/framework/visible-24.png");
			} else {
				$(fieldname).prop("type", "text");
				visible = true;
				$(this).attr("src", "display/images/framework/invisible-24.png");
			}
		});
	});
</script>
<br>
<div class="container">
	<div class="row">
		<div class="form-horizontal">
			<form id="loginForm" method="POST" action="loginExec">
				<input type="hidden" name="identificationType" value="BDD">
				<div class="row mb-6">
					<label for="login" class="form-label col-4">
						{t}Login :{/t}
					</label>
					<div class="col-8">
						<input class="form-control " name="login" id="login" required autofocus>
					</div>
				</div>
				<div class="row mb-6">
					<label for="login" class="form-label col-4">
						{t}Mot de passe :{/t}
					</label>
					<div class="col-7">
						<input class="form-control " name="password" id="password" type="password" autocomplete="off"
							required maxlength="256">
					</div>
					<div class="col-1">
						<img src="display/images/framework/visible-24.png" height="16" id="passVisible"
							class="passwordVisible">
					</div>
				</div>
				{if $tokenIdentityValidity > 0}
				<div class="row mb-6 center checkbox col-12 ">
					<label>
						{$duration = $tokenIdentityValidity / 3600}
						<input type="checkbox" name="loginByTokenRequested" class="" value="1" checked>
						{t}Conserver la connexion pendant{/t} {$duration} {t}heures{/t}
					</label>
				</div>
				{/if}
				{if $lostPassword == 1 }
				<div class="row mb-6 center col-12 ">
					<a href="passwordlostIslost">
						{t}Mot de passe oublié ?{/t}</a>
				</div>
				{/if}
				<div class="row mb-6 center ">
					<div class="col-2-offset-4">
						<button type="submit" class=" btn btn-primary  ">{t}Se connecter{/t}</button>
					</div>
					
				</div>
				{$csrf}
			</form>
			{if $CAS_enabled == 1 || $OIDC_enabled == 1}
			{if $CAS_enabled == 1}
			<form id="loginCasForm" method="GET" action="loginCasExec">
				<input type="hidden" name="identificationType" value="CAS">
				{else}
				<form id="loginCasForm" method="GET" action="oidcExec">
					<input type="hidden" name="identificationType" value="OIDC">
					{/if}
					<div class="row mb-6">
						<label for="cas" class="form-label col-4">{t}ou :{/t}</label>
						<div class="col-8">
							<button type="submit" id="cas" class="btn btn-primary">
								{if !empty ($getLogo)}
								<img src="getLogo" height="25">
								{/if}
								{t}Se connecter avec l'identification centralisée{/t}
							</button>
						</div>
					</div>
				</form>
				{/if}
		</div>
	</div>
</div>