<div class="container">
    <h2>{t}Création - Modification d'une licence de publication d'une collection{/t}</h2>
    <div class="row">
        <a href="licenseList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
    </div>
    <div class="row">
        <form class="form-horizontal" id="licenseForm" method="post" action="licenseWrite">
            <input type="hidden" name="moduleBase" value="license">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="license_id" value="{$data.license_id}">
            <div class="row">
                <label for="" class="form-label col-4"><span class="red">*</span> {t}Code de la licence :{/t}</label>
                <div class="col-8">
                    <input id="license_name" type="text" class="form-control" name="license_name" value="{$data.license_name}" autofocus required>
                </div>
            </div>
            <div class="row">
                <label for="license_url" class="form-label col-4"><span class="red">*</span> {t}URL :{/t}</label>
                <div class="col-8">
                    <input id="license_url" type="text" class="form-control" name="license_url" value="{$data.license_url}">
                </div>
            </div>
            <div class="row d-inline">
                <span class="messagebas"><span class="red">*</span>&nbsp;{t}Donnée obligatoire{/t}</span>
            </div>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
                {if $data.license_id > 0 }
                <div class="col-auto">
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                </div>
                {/if}
            </div>
            {$csrf}
        </form>
    </div>
</div>