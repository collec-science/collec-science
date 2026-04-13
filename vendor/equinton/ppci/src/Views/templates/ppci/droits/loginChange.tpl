<div class="container">
<h2>{t}Modification d'un login (module de gestion des droits){/t}</h2>
<div class="row">
      <div class="col-6">
            <a href="aclloginList">{t}Retour à la liste des logins{/t}</a>

            <form class="form-horizontal protoform" id="loginForm" method="post" action="index.php">
                  <input type="hidden" name="moduleBase" value="acllogin">
                  <input type="hidden" name="action" value="Write">
                  <input type="hidden" name="acllogin_id" value="{$data.acllogin_id}">
                  <div class="row mb-6">
                        <label for="logindetail" class="form-label col-4"><span class="red">*</span> 
                              {t}Nom de l'utilisateur :{/t}
                        </label>
                        <div class="col-8">
                              <input id="logindetail" type="text" class="form-control" name="logindetail"
                                    value="{$data.logindetail}" autofocus required>
                        </div>
                  </div>
                  <div class="row mb-6">
                        <label for="login" class="form-label col-4"><span class="red">*</span>
                              {t}Login utilisé :{/t}
                        </label>
                        <div class="col-8">
                              <input id="login" type="text" class="form-control" name="login" value="{$data.login}"
                                    required>
                        </div>
                  </div>
                  <div class="row mb-6">
                        <label for="email" class="form-label col-4">
                              {t}Adresse email :{/t}
                        </label>
                        <div class="col-8">
                              <input id="email" type="text" class="form-control" name="email" value="{$data.email}">
                        </div>
                  </div>
                  <div class="row mb-6">
                        <label for="totp_reset" class="form-label col-4">
                              {t}Désactiver l'identification à double facteur :{/t}
                        </label>
                        <div class="col-8">
                              <input id="totp_reset" type="checkbox" class="form-control" name="totp_reset" value="1">
                        </div>
                  </div>
                  <div class="row mb-6 center">
                        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                        {if $data.acllogin_id > 0 }
                        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                        {/if}
                  </div>
                  {$csrf}
            </form>
      </div>
</div>
	<div class="row col-12 d-inline">
		<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
	</div>
<div class="row">
      <div class="col-6">
            <fieldset>
                  <legend>{t}Droits attribués{/t}</legend>
                  {foreach $loginDroits as $droit=>$value}
                  <div class="col-2 col-offset-2">
                        {$droit}
                  </div>
                  {/foreach}
            </fieldset>
      </div>
</div>