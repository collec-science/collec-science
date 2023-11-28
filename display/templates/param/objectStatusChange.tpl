<h2>{t}Modification d'un statut d'objets{/t}</h2>
<div class="row">
    <div class="col-md-6">
        <a href="index.php?module=objectStatusList">{t}Retour à la liste{/t}</a>

        <form class="form-horizontal protoform" id="objectStatusForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="objectStatus">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="object_status_id" value="{$data.object_status_id}">
            <div class="form-group">
                <label for="objectStatusName" class="control-label col-md-4"><span class="red">*</span>
                    {t}Nom:{/t}
                </label>
                <div class="col-md-8">
                    <input id="objectStatusName" type="text" class="form-control" name="object_status_name"
                        value="{$data.object_status_name}" autofocus required>
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
            </div>
        </form>
    </div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
<div class="row">
    <div class="col-md-6 bg-info">
        {t}Ne modifiez pas le sens général des libellés, certains statuts sont attribués automatiquement par l'application !{/t}
    </div>
</div>