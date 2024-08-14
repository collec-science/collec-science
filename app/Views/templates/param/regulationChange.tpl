<h2>{t}Création - Modification d'un type de réglementation{/t}</h2>
<div class="row">
    <div class="col-md-6">
        <a href="regulationList">{t}Retour à la liste{/t}</a>

        <form class="form-horizontal " id="regulationForm" method="post" action="regulationWrite">
            <input type="hidden" name="moduleBase" value="regulation">
            <input type="hidden" name="regulation_id" value="{$data.regulation_id}">
            <div class="form-group">
                <label for="regulationName" class="control-label col-md-4"><span class="red">*</span>
                    {t}Nom de la réglementation :{/t}</label>
                <div class="col-md-8">
                    <input id="regulationName" type="text" class="form-control" name="regulation_name"
                        value="{$data.regulation_name}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="regulation_comment" class="control-label col-md-4">{t}Description :{/t}</label>
                <div class="col-md-8">
                    <textarea rows="5" class="form-control"
                        name="regulation_comment">{$data.regulation_comment}</textarea>
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.regulation_id > 0 }
                <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
            {$csrf}
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>