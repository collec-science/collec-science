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
        var myStorage = window.localStorage;
        var provider;
        try {
            provider = myStorage.getItem("loginMixedProvider");
        } catch (Exception) {
        }
        try {
            if (provider.length > 0) {
                $("#" + provider).prop("checked", true);
            }
        } catch (Exception) { }
        $(".provider").change(function () {
            myStorage.setItem("loginMixedProvider", this.value);
        });
    });
</script>
<br>
<div class="container">
    {if !empty($localIdentification)}
    <div class="row">
        <div class="form-horizontal">
            <form id="loginForm" method="POST" action="loginMixedExec">
                <input type="hidden" name="identificationType" value="BDD">
                <div class="row">
                    <label for="login" class="form-label col-4">
                        {t}Login :{/t}
                    </label>
                    <div class="col-8">
                        <input class="form-control " name="login" id="login" required autofocus>
                    </div>
                </div>
                <div class="row">
                    <label for="login" class="form-label col-4">
                        {t}Mot de passe :{/t}
                    </label>
                    <div class="col-7">
                        <input class="form-control " name="password" id="password" type="password" autocomplete="off" required maxlength="256">
                    </div>
                    <div class="col-1">
                        <img src="display/images/framework/visible-24.png" height="16" id="passVisible" class="passwordVisible">
                    </div>
                </div>
                {if $tokenIdentityValidity > 0}
                <div class="row center checkbox col-12 ">
                    <label>
                        {$duration = $tokenIdentityValidity / 3600}
                        <input type="checkbox" name="loginByTokenRequested" class="" value="1" checked>
                        {t}Conserver la connexion pendant{/t} {$duration} {t}heures{/t}
                    </label>
                </div>
                {/if}
                {if $lostPassword == 1 && ($localIdentification == "BDD" || $localidentification == "LDAP-BDD") }
                <div class="row center col-12 ">
                    <a href="passwordlostIslost">
                        {t}Mot de passe oublié ?{/t}</a>
                </div>
                {/if}
                <div class="row center ">
                    <div class="row d-flex justify-content-center">
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary button-valid">{t}Se connecter{/t}</button>
                        </div>
                    </div>
                </div>
                {$csrf}
            </form>
        </div>
    </div>
    <br>
    {/if}
    {if !empty($providers)}
    <div class="row form-horizontal">
        <fieldset>
            <legend>{t}Connexion à partir d'un serveur d'identification tiers{/t}</legend>
            <form id="loginExternal" method="POST" action="loginExternalExec">
                {foreach $providers as $provider}
                <div class="form-check">
                    <input type="radio" id="{$provider.name}" class="form-check-input provider" name="provider" value="{$provider.name}">
                    <label class="form-check-label" for="{$provider.name}">
                        <img src="{$provider.logo}" height="25">
                        {$provider.name}
                    </label>
                </div>
                {/foreach}
                <div class="row center ">
                    <div class="row d-flex justify-content-center">
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary button-valid">{t}Se connecter{/t}</button>
                        </div>
                    </div>
                </div>
            </form>
        </fieldset>
    </div>
    {/if}
</div>