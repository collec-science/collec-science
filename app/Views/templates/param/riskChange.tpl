<h2>{t}Création - Modification des risques de manipulation{/t}</h2>
<div class="row">
    <div class="col-md-6">
        <a href="riskList">{t}Retour à la liste{/t}</a>

        <form class="form-horizontal " id="riskForm" method="post" action="riskWrite">
            <input type="hidden" name="moduleBase" value="risk">
            <input type="hidden" name="risk_id" value="{$data.risk_id}">
            <div class="form-group">
                <label for="riskName" class="control-label col-md-4"><span class="red">*</span> 
                    {t}Nom du risque, selon la nomenclature CLP :{/t}
                </label>
                <div class="col-md-8">
                    <input id="riskName" type="text" class="form-control" name="risk_name"
                        value="{$data.risk_name}" autofocus required>
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.risk_id > 0 }
                <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
            {$csrf}
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>