<h2>{t}Vérification du compte avec la double authentification{/t}</h2>
<div class="row">
    <div class="col-lg-6 col-md-8">
        <div class="bg-info ">
            {t}Pour vérifier votre identification, veuillez taper le code TOTP que vous avez configuré dans votre smartphone{/t}
        </div>
    </div>
</div>
<div class="col-lg-6 col-md-8">
    <div class="row">
        <form id="otpform" class="form-horizontal protoform" method="post" action="totpVerifyExec">
            <input type="hidden" name="moduleCalled" value="{$moduleCalled}"">
        <div class=" form-group">
            <label for="otpcode" class="control-label col-md-4">
                {t}Code généré par le logiciel TOTP :{/t}
            </label>
            <div class="col-md-8">
                <input id="otpcode" type="number" class="form-control nombre" name="otpcode" required autofocus
                    autocomplete="off">
            </div>
    </div>
    {if !$isAdmin}
    <div class="form-group">
        <label for="otptrusted" class="control-label col-md-4">
            {t}Faire confiance à ce navigateur :{/t}
        </label>
        <div class="col-md-8">
            <input type="checkbox" id="otptrusted" class="form-control" name="otptrusted">
        </div>
    </div>
    <div class="bg-info ">
        {t}En cochant cette case, vous désactiverez la demande du code TOTP pour ce navigateur, sauf pour accéder aux fonctions d'administration, le cas échéant{/t}
    </div>
    {/if}
    <div class="center">
        <button type="submit" class="bg-primary btn">{t}Valider{/t}</button>
    </div>
    {$csrf}
    </form>
</div>
</div>