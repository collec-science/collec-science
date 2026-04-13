<div class="container">
      <h2>{t}Modification d'un groupe et rattachement des logins{/t}</h2>
      <div class="row">
            <a href="groupList">{t}Retour à la liste des groupes{/t}</a>

            <form id="groupForm" method="post" class="form-horizontal protoform" action="index.php">
                  <input type="hidden" name="moduleBase" value="group">
                  <input type="hidden" name="action" value="Write">
                  <input type="hidden" name="aclgroup_id" value="{$data.aclgroup_id}">
                  <div class="row d-flex justify-content-center">
                        <div class="col-auto">
                              <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                        </div>
                        {if $data.aclgroup_id > 0 }
                        <div class="col-auto">
                              <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                        </div>
                        {/if}
                  </div>
      </div>
      <div class="row">
            <label for="groupe" class="form-label col-4">
                  <span class="red">*</span> {t}Nom du groupe :{/t}
            </label>
            <div class="col-8"><input type="text" class="form-control" id="groupe" name="groupe" value="{$data.groupe}"
                        autofocus required>
            </div>
      </div>
      <div class="row">
            <label for="aclgroup_id_parent" class="form-label col-4">{t}Groupe de rattachement{/t}</label>
            <div class="col-8">
                  <select id="aclgroup_id_parent" name="aclgroup_id_parent" class="form-select">
                        <option value="" {if $data.aclgroup_id_parent=="" }selected{/if}></option>
                        {foreach $groups as $group}
                        {if $group.aclgroup_id != $data["aclgroup_id"]}
                        <option value="{$group.aclgroup_id}" {if
                              $data.aclgroup_id_parent==$group.aclgroup_id}selected{/if}>
                              {for $boucle = 1 to $group.level}&nbsp;&nbsp;&nbsp;{/for}{$group.groupe}
                        </option>
                        {/if}
                        {/foreach}
                  </select>
            </div>
      </div>
      <div class="row">
            <fieldset class="col-12">
                  <legend><span class="red">*</span> {t}Logins rattachés{/t}</legend>
                  {section name=lst loop=$logins}
                  <div class="col-3 offset-1">
                        <input id="login{$smarty.section.lst.index}" class="form-check-input" type="checkbox"
                              name="logins[]" value="{$logins[lst].acllogin_id}" {if
                              $logins[lst].checked==1}checked{/if}>
                        <label class="form-check-label" for="login{$smarty.section.lst.index}">
                              {$logins[lst].logindetail}
                        </label>
                  </div>
                  {/section}
            </fieldset>
      </div>
      {$csrf}
      </form>
</div>
</div>
<div class="row col-12 d-inline">
      <span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
</div>