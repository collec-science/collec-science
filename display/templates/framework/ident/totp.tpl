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
    <form id="otpform" class="form-horizontal protoform" method="post" action="index.php">
      <input type="hidden" name="module" value="totpVerifyExec">
      <input type="hidden" name="moduleCalled" value="{$moduleCalled}"">
        <div class="form-group">
          <label for="otpcode" class="control-label col-md-4">{t}Code généré par le logiciel TOTP :{/t} </label>
          <div class="col-md-8">
            <input id="otpcode" type="text" class="form-control" name="otpcode" class="nombre" required autofocus autocomplete="off">
          </div>
        </div>
        <div class="center">
          <button type="submit" class="bg-primary btn">{t}Valider{/t}</button>
        </div>
    </form>
  </div>
  </div>
