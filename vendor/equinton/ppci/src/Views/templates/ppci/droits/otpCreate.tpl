<h2>{t}Activation de la double authentification{/t}</h2>
<div class="row">
  <div class="col-lg-6 col-md-8">
    <div class="bg-info ">
      {t}La double identification limite les risques d'usurpation de votre compte.{/t}
      <br>
      {t}Pour l'activer, vous devrez installer dans votre smartphone une application compatible avec l'identificationTOTP, par exemple FreeOTP, Google Authenticator, etc.{/t}
      <br>
      {t}Une fois l'application installée, scannez le QRCODE, puis tapez le code généré par l'application pour valider votre double identification.{/t}
    </div>
  </div>
</div>
<div class="col-lg-6 col-md-8">
  <div class="row">


    <div class="center">
      <img src="totpGetQrcode" height="150" style="margin-top:2.5em">
    </div>
    <form id="otpform" class="form-horizontal protoform" method="post" action="totpCreateVerify">
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
  </div>
  </div>
