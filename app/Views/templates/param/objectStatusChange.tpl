<div class="container">
    <h2>{t}Modification d'un statut d'objets{/t}</h2>
    <div class="row">
        <a href="objectStatusList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
    </div>
    <div class="row">
        <form class="form-horizontal " id="objectStatusForm" method="post" action="objectStatusWrite">
            <input type="hidden" name="moduleBase" value="objectStatus">
            <input type="hidden" name="object_status_id" value="{$data.object_status_id}">
            <div class="row">
                <label for="objectStatusName" class="form-label col-4"><span class="red">*</span>
                    {t}Nom:{/t}
                </label>
                <div class="col-8">
                    <input id="objectStatusName" type="text" class="form-control" name="object_status_name" value="{$data.object_status_name}" autofocus required>
                </div>
            </div>
            <div class="row d-inline">
                <span class="messagebas"><span class="red">*</span>&nbsp;{t}Donnée obligatoire{/t}</span>
            </div>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
            </div>
            {$csrf}
        </form>

    </div>

    <div class="row">
        <div class="bg-info">
            {t}Ne modifiez pas le sens général des libellés, certains statuts sont attribués automatiquement par l'application !{/t}
        </div>
    </div>
</div>