<script>
    $(document).ready(function(){
        $("#displayCodeLink").on("click", function() { 
            $("#displayCode").show();
        });
    });
</script>
<div class="container">
<h2>{t}Activation de la double authentification{/t}</h2>
<div class="row">
    <div class="col-6 col-8">
        <div class="bg-info ">
            {t}La double identification limite les risques d'usurpation de votre compte.{/t}
            <br>
            {t}Pour l'activer, vous devrez installer dans votre smartphone une application compatible avec l'identificationTOTP, par exemple FreeOTP+, Google Authenticator, etc.{/t}
            <br>
            {t}Si vous devez travailler dans une pièce à accès restreint (laboratoire protégé), vous pouvez également utiliser un logiciel qui s'installe dans votre ordinateur, comme Ente Auth pour Windows ou Authenticator pour Linux. Ces logiciels vous permettent d'échanger les clés d'un ordinateur à un autre, pensez simplement à chiffrer les informations quand vous les exportez.{/t}
            <br>
            {t}Une fois l'application installée, scannez le QRCODE, puis tapez le code généré par l'application pour valider votre double identification.{/t}
        </div>
    </div>
</div>
<div class="col-6 col-8">
    <div class="row">


        <div class="center">
            <img src="totpGetQrcode" height="150" style="margin-top:2.5em">
        </div>
    </div>
    <div class="row">
        <div class="center">
            <a href="#" id="displayCodeLink">
                {t}Afficher le contenu du QRCODE pour une saisie manuelle{/t}
            </a>
        </div>
    </div>
    <div class="row" id="displayCode" hidden>
        <div class="form-display col-12">
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

    <form id="otpform" class="form-horizontal protoform" method="post" action="totpCreateVerify">
        <div class="row mb-6">
            <label for="otpcode" class="form-label col-4">{t}Code généré par le logiciel TOTP :{/t} </label>
            <div class="col-8">
                <input id="otpcode" type="number" class="form-control" name="otpcode" class="nombre" required autofocus>
            </div>
        </div>
        <div class="center">
            <button type="submit" class="bg-primary btn">{t}Valider{/t}</button>
        </div>
        {$csrf}
    </form>
</div>
</div>