<h2>{t}Modification d'un groupe et rattachement des logins{/t}</h2>
<div class="row">
<div class="col-lg-6">
<a href="groupList">{t}Retour à la liste des groupes{/t}</a>

<form id="groupForm" method="post"  class="form-horizontal protoform"  action="index.php">
<input type="hidden" name="moduleBase" value="group">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="aclgroup_id" value="{$data.aclgroup_id}">
<!--input type="hidden" name="aclgroup_id_parent" value="{$data.aclgroup_id_parent}"-->
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.aclgroup_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
</div>
<div class="form-group">
<label for="groupe" class="control-label col-md-4">
<span class="red">*</span> {t}Nom du groupe :{/t}
</label>
<div class="col-md-8"><input type="text" class="form-control" id="groupe" name="groupe" value="{$data.groupe}" autofocus required>
</div>
</div>
<div class="form-group">
      <label for="aclgroup_id_parent" class="control-label col-md-4">{t}Groupe de rattachement{/t}</label>
      <div class="col-md-8">
            <select id="aclgroup_id_parent" name="aclgroup_id_parent" class="form-control">
            <option value="" {if $data.aclgroup_id_parent == ""}selected{/if}></option>
            {foreach $groups as $group}
                  {if $group.aclgroup_id != $data["aclgroup_id"]}
                        <option value="{$group.aclgroup_id}" {if $data.aclgroup_id_parent == $group.aclgroup_id}selected{/if}>
                        {for $boucle = 1 to $group.level}&nbsp;&nbsp;&nbsp;{/for}{$group.groupe}
                        </option>
                  {/if}
            {/foreach}
            </select>
      </div>
</div>
<div class="form-group">
<fieldset class="col-lg-12">
<legend><span class="red">*</span> {t}Logins rattachés{/t}</legend>
{section name=lst loop=$logins}
<div class="col-md-2 col-sm-offset-2">
      <div class="checkbox">
        <label>


<input type="checkbox" name="logins[]" value="{$logins[lst].acllogin_id}" {if $logins[lst].checked == 1}checked{/if}>
{$logins[lst].logindetail}
</label>
</div>
</div>
{/section}
</fieldset>
</div>
{$csrf}
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
