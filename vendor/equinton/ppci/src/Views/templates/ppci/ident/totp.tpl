<div class="container">
    <h2>{t}Vérification du compte avec la double authentification{/t}</h2>
    <div class="bg-info">
        {t}Pour vérifier votre identification, veuillez taper le code TOTP que vous avez configuré dans votre smartphone{/t}
    </div>
    <form id="otpform" class="form-horizontal" method="post" action="totpVerifyExec">
        <input type="hidden" name="moduleCalled" value="{$moduleCalled}">
        <div class="row">
            <label for="otpcode" class="form-label col-4"><span class="red">*</span>&nbsp;{t}Code généré par le logiciel TOTP :{/t}</label>
            <div class="col-8">
                <input id="otpcode" type="number" class="form-control nombre" name="otpcode" required autofocus autocomplete="off">
            </div>
        </div>
        {if !$isAdmin}
        <div class="row">
            <label for="otptrusted" class="form-check-label col-4">{t}Faire confiance à ce navigateur :{/t}</label>
            <div class="col-8">
                <input type="checkbox" id="otptrusted" class="form-check-input" name="otptrusted">
            </div>
        </div>
        <div class="bg-info ">
            {t}En cochant cette case, vous désactiverez la demande du code TOTP pour ce navigateur, sauf pour accéder aux fonctions d'administration, le cas échéant{/t}
        </div>
        {/if}
        <div class="row d-inline">
            <span class="messagebas"><span class="red">*</span>&nbsp;{t}Donnée obligatoire{/t}</span>
        </div>
        <div class="row d-flex justify-content-center">
            <div class="col-auto">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
            </div>
        </div>
        {$csrf}
    </form>
</div>