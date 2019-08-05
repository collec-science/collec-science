<fieldset class="col-sm-6">
<legend>{t}Mot de passe oublié ?{/t} {t}lancement de la procédure de récupération{/t}</legend>

<form class="form-horizontal protoform" id="sendMail" method="post" action="index.php">
<input type="hidden" name="module" value="passwordlostSendmail">
<div class="form-group">
<label for="mail" class="control-label col-sm-4">
<span class="red">*</span> {t}Entrez votre adresse e-mail :{/t}
</label>
<div class="col-sm-8">
<input type="text" class="form-control" id="mail" name="mail" required autofocus>
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Recevoir un mail de récupération{/t}</button>
</div>
</form>
</fieldset>