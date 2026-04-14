<div class="container">
    <h2>{t}Modification d'un login (module de gestion des droits){/t}</h2>
    <div class="container">
        <div class="row">
            <a href="aclloginList">
                <img src="display/images/list.png" height="25">
                {t}Retour à la liste des logins{/t}
            </a>
        </div>
        <div class="row">
            <form class="form-horizontal" id="loginForm" method="post" action="aclloginWrite">
                <input type="hidden" name="moduleBase" value="acllogin">
                <input type="hidden" name="action" value="Write">
                <input type="hidden" name="acllogin_id" value="{$data.acllogin_id}">
                <div class="row">
                    <label for="logindetail" class="form-label col-4"><span class="red">*</span>
                        {t}Nom de l'utilisateur :{/t}
                    </label>
                    <div class="col-8">
                        <input id="logindetail" type="text" class="form-control" name="logindetail"
                            value="{$data.logindetail}" autofocus required>
                    </div>
                </div>
                <div class="row">
                    <label for="login" class="form-label col-4"><span class="red">*</span>
                        {t}Login utilisé :{/t}
                    </label>
                    <div class="col-8">
                        <input id="login" type="text" class="form-control" name="login" value="{$data.login}" required>
                    </div>
                </div>
                <div class="row">
                    <label for="email" class="form-label col-4">
                        {t}Adresse email :{/t}
                    </label>
                    <div class="col-8">
                        <input id="email" type="text" class="form-control" name="email" value="{$data.email}">
                    </div>
                </div>
                <div class="row">
                    <label for="totp_reset" class="form-label col-4">
                        {t}Désactiver l'identification à double facteur :{/t}
                    </label>
                    <div class="col-8">
                        <input id="totp_reset" type="checkbox" class="form-check-input" name="totp_reset" value="1">
                    </div>
                </div>
                <div class="row d-flex justify-content-center">
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                    </div>
                    {if $data.acllogin_id > 0 }
                    <div class="col-auto">
                        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                    </div>
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
</div>