<fieldset class="col-sm-6">
<legend>{$LANG["login"].58}</legend>

<form class="form-horizontal protoform" id="sendMail" method="post" action="index.php">
<input type="hidden" name="module" value="passwordlostSendmail">
<div class="form-group">
<label for="mail" class="control-label col-sm-4">
{$LANG["login"].57}<span class="red">*</span> :
</label>
<div class="col-sm-8">
<input type="text" class="form-control" id="mail" name="mail" required autofocus>
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
</div>
</form>
</fieldset>
