<div class="container">
<h2>{t}Création - Modification d'une condition de stockage{/t}</h2>
<div class="row">
      <div class="col-6">
            <a href="storageConditionList">{t}Retour à la liste{/t}</a>
            <form class="form-horizontal " id="loginForm" method="post" action="storageConditionWrite">
                  <input type="hidden" name="moduleBase" value="storageCondition">
                  <input type="hidden" name="storage_condition_id" value="{$data.storage_condition_id}">
                  <div class="row">
                        <label for="storageConditionName" class="form-label col-4"><span class="red">*</span>
                              {t}Nom :{/t}</label>
                        <div class="col-8">
                              <input id="storageConditionName" type="text" class="form-control"
                                    name="storage_condition_name" value="{$data.storage_condition_name}" autofocus
                                    required>
                        </div>
                  </div>

                  <div class="row center">
                        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                        {if $data.storage_condition_id > 0 }
                        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                        {/if}
                  </div>
                  {$csrf}
            </form>
      </div>
</div>
	<div class="row col-12 d-inline">
		<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
	</div>