<div class="container">
    <h2>{t}Création - Modification d'une operation{/t}</h2>
    <div class="row">
        <a href="operationList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
    </div>
    <div class="row">
        <form class="form-horizontal " id="operationForm" method="post" action="operationWrite">
            <input type="hidden" name="moduleBase" value="operation">
            <input type="hidden" name="operation_id" value="{$data.operation_id}">
            <div class="row">
                <label for="protocolId" class="form-label col-4"><span class="red">*</span> {t}Protocole :{/t}</label>
                <div class="col-8">
                    <select id="protocolId" name="protocol_id" class="form-select" autofocus>
                        {section name=lst loop=$protocol}
                        <option value="{$protocol[lst].protocol_id}" {if $data.protocol_id==$protocol[lst].protocol_id}selected{/if}>
                            {$protocol[lst].protocol_year} {$protocol[lst].protocol_name} {$protocol[lst].protocol_version}
                        </option>
                        {/section}
                    </select>
                </div>
            </div>

            <div class="row">
                <label for="operationName" class="form-label col-4"><span class="red">*</span> {t}Nom de l'opération :{/t}</label>
                <div class="col-8">
                    <input id="operationName" type="text" class="form-control" name="operation_name" value="{$data.operation_name}" required>
                </div>
            </div>

            <div class="row">
                <label for="operationVersion" class="form-label col-4"><span class="red">*</span> {t}Version de l'opération :{/t}</label>
                <div class="col-8">
                    <input id="operationVersion" type="text" class="form-control" name="operation_version" value="{$data.operation_version}" required>
                </div>
            </div>

            <div class="row">
                <label for="operationOrder" class="form-label col-4">{t}N° d'ordre :{/t}</label>
                <div class="col-8">
                    <input id="operationOrder" type="number" class="form-control" name="operation_order" value="{$data.operation_order}">
                </div>
            </div>
            <div class="row d-inline">
                <span class="messagebas"><span class="red">*</span>&nbsp;{t}Donnée obligatoire{/t}</span>
            </div>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
                {if $data.operation_id > 0 }
                <div class="col-auto">
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                </div>
                {/if}
            </div>
            {$csrf}
        </form>
    </div>
</div>