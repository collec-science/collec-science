<div class="container">
    <h2>{t}Création - Modification des risques de manipulation{/t}</h2>
    <div class="row">
        <a href="riskList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
    </div>
    <div class="row">
        <form class="form-horizontal " id="riskForm" method="post" action="riskWrite">
            <input type="hidden" name="moduleBase" value="risk">
            <input type="hidden" name="risk_id" value="{$data.risk_id}">
            <div class="row">
                <label for="riskName" class="form-label col-4"><span class="red">*</span>
                    {t}Nom du risque, selon la nomenclature CLP :{/t}
                </label>
                <div class="col-8">
                    <input id="riskName" type="text" class="form-control" name="risk_name" value="{$data.risk_name}" autofocus required>
                </div>
            </div>
            <div class="row d-inline">
                <span class="messagebas"><span class="red">*</span>&nbsp;{t}Donnée obligatoire{/t}</span>
            </div>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
                {if $data.risk_id > 0 }
                <div class="col-auto">
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                </div>
                {/if}
            </div>
            {$csrf}
        </form>
    </div>
</div>