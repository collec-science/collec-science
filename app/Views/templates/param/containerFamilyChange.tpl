<h2>{t}Création - Modification d'une famille de contenants{/t}</h2>
<div class="row">
      <div class="col-md-6">
            <a href="containerFamilyList">{t}Retour à la liste{/t}</a>

            <form class="form-horizontal " id="containerFamilyForm" method="post" action="containerFamilyWrite">
                  <input type="hidden" name="moduleBase" value="containerFamily">
                  <input type="hidden" name="container_family_id" value="{$data.container_family_id}">
                  <div class="form-group">
                        <label for="containerFamilyName" class="control-label col-md-4"><span class="red">*</span>
                              {t}Nom :{/t}</label>
                        <div class="col-md-8">
                              <input id="containerFamilyName" type="text" class="form-control"
                                    name="container_family_name" value="{$data.container_family_name}" autofocus
                                    required>
                        </div>
                  </div>

                  <div class="form-group center">
                        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                        {if $data.container_family_id > 0 }
                        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                        {/if}
                  </div>
                  {$csrf}
            </form>
      </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>