{* Administration > ACL - logins > User > *}
<h2>{t}Modification d'un login (module de gestion des droits){/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=aclloginList">{t}Retour à la liste des logins{/t}</a>

<form class="form-horizontal protoform" id="loginForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="acllogin">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="acllogin_id" value="{$data.acllogin_id}">
<div class="form-group">
<label for="logindetail"  class="control-label col-md-4"><span class="red">*</span> {t}Nom de l'utilisateur :{/t}</label>
<div class="col-md-8">
<input id="logindetail" type="text" class="form-control" name="logindetail" value="{$data.logindetail}" autofocus required></div>
</div>
<div class="form-group">
<label for="login"  class="control-label col-md-4"><span class="red">*</span> {t}Login utilisé :{/t} </label>
<div class="col-md-8">
<input id="login" type="text" class="form-control" name="login" value="{$data.login}" required>
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.acllogin_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
<div class="row">
<div class="col-md-6">
<fieldset>
<legend>{t}Droits attribués{/t}</legend>
{foreach $loginDroits as $droit=>$value}
<div class="col-md-2 col-sm-offset-2">
{$droit}
</div>
{/foreach}
</fieldset>
</div>
</div>