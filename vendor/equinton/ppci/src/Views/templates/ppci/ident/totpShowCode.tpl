<div class="container">
    <h2>{t}Affichage de la clé TOTP{/t}</h2>
    <div class="row">
        <div class="bg-info ">
            {t}Ce module vous permet de visualiser les paramètres de votre clé TOTP, pour pouvoir configurer un autre appareil le cas échéant{/t}
        </div>
    </div>
    {if empty($issuer)}
    <form id="otpform" class="form-horizontal protoform" method="post" action="totpShowCode">
        <div class="row">
            <label for="otpcode" class="form-label col-4">
                {t}Code généré par le logiciel TOTP :{/t}
            </label>
            <div class="col-8">
                <input id="otpcode" type="number" class="form-control" name="otpcode" class="nombre" required autofocus>
            </div>
        </div>
        <div class="row d-flex justify-content-center">
            <div class="col-auto">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
            </div>
        </div>
        {$csrf}
    </form>
    {else}
    <div class="center">
        <img src="totpGetQrcode" height="150" style="margin-top:2.5em">
    </div>
    <div class="row" id="displayCode">
        <div class="form-display">
            <dl class="dl-horizontal">
                <dt>{t}Fournisseur{/t}</dt>
                <dd>{$issuer}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Compte{/t}</dt>
                <dd>{$login}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Jeton{/t}</dt>
                <dd>{$secret}</dd>
            </dl>
        </div>
    </div>
    {/if}
</div>