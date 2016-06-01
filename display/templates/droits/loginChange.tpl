<h2>{$LANG["login"][27]}</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=aclloginList">{$LANG["login"][28]}</a>

<form class="form-horizontal protoform" id="loginForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="acllogin">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="acllogin_id" value="{$data.acllogin_id}">
<div class="form-group">
<label for="logindetail"  class="control-label col-md-4">{$LANG["login"][29]} <span class="red">*</span> :</label>
<div class="col-md-8">
<input id="logindetail" type="text" class="form-control" name="logindetail" value="{$data.logindetail}" autofocus required></div>
</div>
<div class="form-group">
<label for="login"  class="control-label col-md-4">{$LANG["login"][30]} <span class="red">*</span> : </label>
<div class="col-md-8">
<input id="login" type="text" class="form-control" name="login" value="{$data.login}" required>
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.acllogin_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>
<div class="row">
<div class="col-md-6">
<fieldset>
<legend>{$LANG["login"][26]}</legend>
{foreach $loginDroits as $droit=>$value}
<div class="col-md-2 col-sm-offset-2">
{$droit}
</div>
{/foreach}
</fieldset>
</div>
</div>