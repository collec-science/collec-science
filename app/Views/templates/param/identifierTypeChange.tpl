<script>
    $(document).ready(function () {
        $("#identifierTypeForm").submit(function (e) {
            if ($("#ufs1").prop("checked") && $("#identifierTypeCode").val().length == 0) {
                alert("{t}Le code doit être renseigné si l'identifiant est utilisable pour les recherches{/t}");
                e.preventDefault();
            }
        });
    });
</script>
<div class="container">
    <h2>{t}Création - Modification d'un type d'identifiant{/t}</h2>
    <div class="row">
        <a href="identifierTypeList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
    </div>
    <div class="row">
        <form class="form-horizontal " id="identifierTypeForm" method="post" action="identifierTypeWrite">
            <input type="hidden" name="moduleBase" value="identifierType">
            <input type="hidden" name="identifier_type_id" value="{$data.identifier_type_id}">
            <div class="row">
                <label for="identifierTypeName" class="form-label col-4"><span class="red">*</span> {t}Nom :{/t}</label>
                <div class="col-8">
                    <input id="identifierTypeName" type="text" class="form-control" name="identifier_type_name" value="{$data.identifier_type_name}" autofocus required>
                </div>
            </div>
            <div class="row">
                <label for="identifierTypeCode" class="form-label col-4">
                    {t}Code utilisé (étiquettes, recherche, import) :{/t}</label>
                <div class="col-8">
                    <input id="identifierTypeCode" type="text" class="form-control" name="identifier_type_code" value="{$data.identifier_type_code}">
                </div>
            </div>
            <div class="row">
                <label for="search" class="form-label col-4"><span class="red">*</span>
                    {t}Identifiant utilisé dans les recherches ?{/t}</label>
                <div class="col-8" id="search">
                    <div class="radio">
                        <label>
                            <input type="radio" name="used_for_search" id="ufs1" value="1" {if $data.used_for_search=='t' }checked{/if}>
                            {t}oui{/t}
                        </label>
                    </div>
                    <div class="radio">
                        <label>
                            <input type="radio" name="used_for_search" id="ufs2" value="0" {if $data.used_for_search!='t' }checked{/if}>
                            {t}non{/t}
                        </label>
                    </div>
                </div>
            </div>

            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
                {if $data.identifier_type_id > 0 }
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