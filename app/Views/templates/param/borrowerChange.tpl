<h2>{t}Création - Modification d'un emprunteur{/t}</h2>
<div class="row">
    <div class="col-md-6">
        <a href="borrowerList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
        {if $data.borrower_id > 0}
            &nbsp;
            <a href="borrowerDisplay?borrower_id={$data.borrower_id}">
                <img src="display/images/display.png" height="25">
                {t}Retour au détail{/t}
            </a>
        {/if}

        <form class="form-horizontal protoform" id="borrowerForm" method="post" action="index.php">
        <input type="hidden" name="moduleBase" value="borrower">
        <input type="hidden" name="action" value="Write">
        <input type="hidden" name="borrower_id" value="{$data.borrower_id}">
        <div class="form-group">
            <label for="borrower_name"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
            <div class="col-md-8">
                <input id="borrower_name" type="text" class="form-control" name="borrower_name" value="{$data.borrower_name}" autofocus required>
            </div>
        </div>
        <div class="form-group">
            <label for="borrower_address"  class="control-label col-md-4">{t}Adresse :{/t}</label>
            <div class="col-md-8">
                <textarea  id="borrower_address" class="form-control" name="borrower_address" rows="5">{$data.borrower_address}</textarea>
            </div>
        </div>
        <div class="form-group">
            <label for="borrower_phone"  class="control-label col-md-4">{t}N° de téléphone :{/t}</label>
            <div class="col-md-8">
                <input id="borrower_phone" type="tel" class="form-control" name="borrower_phone" value="{$data.borrower_phone}">
            </div>
        </div>
        <div class="form-group">
            <label for="borrower_phone"  class="control-label col-md-4">{t}Mail :{/t}</label>
            <div class="col-md-8">
                <input id="borrower_mail" type="email" class="form-control" name="borrower_mail" value="{$data.borrower_mail}">
            </div>
        </div>
        <div class="form-group">
            <label for="laboratory_code"  class="control-label col-md-4">{t}Code du laboratoire :{/t}</label>
            <div class="col-md-8">
                <input id="laboratory_code"  class="form-control" name="laboratory_code" value="{$data.laboratory_code}">
            </div>
        </div>
        <div class="form-group center">
              <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
              {if $data.borrower_id > 0 }
              <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
              {/if}
        </div>
        {$csrf}</form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>