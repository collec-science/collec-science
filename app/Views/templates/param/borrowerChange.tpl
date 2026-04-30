<div class="container">
    <h2>{t}Création - Modification d'un emprunteur{/t}</h2>
    <div class="row">
        <div class="col-auto">
            <a href="borrowerList">
                <img src="display/images/list.png" height="25">
                {t}Retour à la liste{/t}
            </a>
        </div>

        {if $data.borrower_id > 0}
        <div class="col-auto">
            <a href="borrowerDisplay?borrower_id={$data.borrower_id}">
                <img src="display/images/display.png" height="25">
                {t}Retour au détail{/t}
            </a>
        </div>
        {/if}

        <form class="form-horizontal " id="borrowerForm" method="post" action="borrowerWrite">
            <input type="hidden" name="moduleBase" value="borrower">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="borrower_id" value="{$data.borrower_id}">
            <div class="row">
                <label for="borrower_name" class="form-label col-4"><span class="red">*</span> {t}Nom :{/t}</label>
                <div class="col-8">
                    <input id="borrower_name" type="text" class="form-control" name="borrower_name" value="{$data.borrower_name}" autofocus required>
                </div>
            </div>
            <div class="row">
                <label for="borrower_address" class="form-label col-4">{t}Adresse :{/t}</label>
                <div class="col-8">
                    <textarea id="borrower_address" class="form-control" name="borrower_address" rows="5">{$data.borrower_address}</textarea>
                </div>
            </div>
            <div class="row">
                <label for="borrower_phone" class="form-label col-4">{t}N° de téléphone :{/t}</label>
                <div class="col-8">
                    <input id="borrower_phone" type="tel" class="form-control" name="borrower_phone" value="{$data.borrower_phone}">
                </div>
            </div>
            <div class="row">
                <label for="borrower_phone" class="form-label col-4">{t}Mail :{/t}</label>
                <div class="col-8">
                    <input id="borrower_mail" type="email" class="form-control" name="borrower_mail" value="{$data.borrower_mail}">
                </div>
            </div>
            <div class="row">
                <label for="laboratory_code" class="form-label col-4">{t}Code du laboratoire :{/t}</label>
                <div class="col-8">
                    <input id="laboratory_code" class="form-control" name="laboratory_code" value="{$data.laboratory_code}">
                </div>
            </div>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
                {if $data.borrower_id > 0 }
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