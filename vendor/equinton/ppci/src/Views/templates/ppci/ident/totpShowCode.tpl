<h2>{t}Affichage de la clé TOTP{/t}</h2>

<div class="row">
    <div class="col-lg-6 col-md-8">
        <div class="bg-info ">
            {t}Ce module vous permet de visualiser les paramètres de votre clé TOTP, pour pouvoir configurer un autre appareil le cas échéant{/t}
        </div>
    </div>
</div>
<div class="col-md-6">
    {if empty($issuer)}
    <form id="otpform" class="form-horizontal protoform" method="post" action="totpShowCode">
        <div class="form-group">
            <label for="otpcode" class="control-label col-md-4">{t}Code généré par le logiciel TOTP :{/t} </label>
            <div class="col-md-8">
                <input id="otpcode" type="number" class="form-control" name="otpcode" class="nombre" required autofocus>
            </div>
        </div>
        <div class="center">
            <button type="submit" class="bg-primary btn">{t}Valider{/t}</button>
        </div>
        {$csrf}
    </form>
    {else}
    <div class="center">
        <img src="totpGetQrcode" height="150" style="margin-top:2.5em">
    </div>
    <div class="row" id="displayCode">
        <div class="form-display col-md-12">
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