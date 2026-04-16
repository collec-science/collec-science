<div class="container">
    <h2>{t}Création - Modification d'un type de réglementation{/t}</h2>
    <div class="row">
        <a href="regulationList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
    </div>
    <div class="row">
        <form class="form-horizontal " id="regulationForm" method="post" action="regulationWrite">
            <input type="hidden" name="moduleBase" value="regulation">
            <input type="hidden" name="regulation_id" value="{$data.regulation_id}">
            <div class="row">
                <label for="regulationName" class="form-label col-4"><span class="red">*</span>
                    {t}Nom de la réglementation :{/t}</label>
                <div class="col-8">
                    <input id="regulationName" type="text" class="form-control" name="regulation_name" value="{$data.regulation_name}" autofocus required>
                </div>
            </div>
            <div class="row">
                <label for="regulation_comment" class="form-label col-4">{t}Description :{/t}</label>
                <div class="col-8">
                    <textarea rows="5" class="form-control" name="regulation_comment">{$data.regulation_comment}</textarea>
                </div>
            </div>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
                {if $data.regulation_id > 0 }
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