<div class="container">
    <h2>{t}Création - Modification d'une famille de contenants{/t}</h2>
    <div class="row">
        <a href="containerFamilyList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>

        <form class="form-horizontal " id="containerFamilyForm" method="post" action="containerFamilyWrite">
            <input type="hidden" name="moduleBase" value="containerFamily">
            <input type="hidden" name="container_family_id" value="{$data.container_family_id}">
            <div class="row">
                <label for="containerFamilyName" class="form-label col-4"><span class="red">*</span>
                    {t}Nom :{/t}</label>
                <div class="col-8">
                    <input id="containerFamilyName" type="text" class="form-control" name="container_family_name" value="{$data.container_family_name}" autofocus required>
                </div>
            </div>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
                {if $data.container_family_id > 0 }
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