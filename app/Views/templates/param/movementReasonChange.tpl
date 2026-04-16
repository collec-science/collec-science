<div class="container">
    <h2>{t}Création - Modification des motifs de déstockage{/t}</h2>
    <div class="row">
        <a href="movementReasonList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
    </div>
    <div class="row">
        <form class="form-horizontal " id="movementReasonForm" method="post" action="movementReasonWrite">
            <input type="hidden" name="moduleBase" value="movementReason">
            <input type="hidden" name="movement_reason_id" value="{$data.movement_reason_id}">
            <div class="row">
                <label for="movementReasonName" class="form-label col-4"><span class="red">*</span> {t}Nom :{/t}</label>
                <div class="col-8">
                    <input id="movementReasonName" type="text" class="form-control" name="movement_reason_name" value="{$data.movement_reason_name}" autofocus required>
                </div>
            </div>

            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
                {if $data.movement_reason_id > 0 }
                <div class="col-auto">
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                </div>
                {/if}
            </div>

            {$csrf}
        </form>
    </div>
    <div class="row col-12 d-inline">
        <span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
    </div>
</div>