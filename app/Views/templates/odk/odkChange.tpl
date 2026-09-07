<div class="container">
    <h2>{t}Création - Modification d'un formulaire ODK - données générales{/t}</h2>
    <div class="row">
        <div class="col-auto">
            <a href="odkList">
                <img src="display/images/list.png" height="25">
                {t}Retour à la liste{/t}
            </a>
        </div>

        {if $data.odk_id > 0}
        <div class="col-auto">
            <a href="odkDisplay?odk_id={$data.odk_id}">
                <img src="display/images/display.png" height="25">
                {t}Retour au détail{/t}
            </a>
        </div>
        {/if}

        <form class="form-horizontal " id="odkForm" method="post" action="odkWrite">
            <input type="hidden" name="moduleBase" value="odk">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="odk_id" value="{$data.odk_id}">
            <div class="row">
                <label for="collection_id" class="form-label col-4"><span class="red">*</span>
                    {t}Collection de destination des échantillons :{/t}
                </label>
                <div class="col-8">
                    <select id="collection_id" name="collection_id" class="form-select" autofocus>
                        {foreach $collections as $collection}
                        <option value="{$collection.collection_id}" {if $data.collection_id==$collection.collection_id}selected{/if}>
                            {$collection.collection_name}
                        </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="row">
                <label for="odk_name" class="form-label col-4"><span class="red">*</span> {t}Nom du formulaire :{/t}</label>
                <div class="col-8">
                    <input id="odk_name" type="text" class="form-control" name="odk_name" value="{$data.odk_name}" autofocus required>
                </div>
            </div>
            <div class="row">
                <label for="odk_project" class="form-label col-4">{t}Projet ODK :{/t}</label>
                <div class="col-8">
                    <input id="odk_project" type="text" class="form-control" name="odk_project" value="{$data.odk_project}">
                </div>
            </div>
            <div class="row">
                <label for="odk_description" class="form-label col-4">{t}Description :{/t}</label>
                <div class="col-8">
                    <textarea id="odk_description" type="text" class="form-control" name="odk_description">{$data.odk_description}</textarea>
                </div>
            </div>
            <div class="row ">
                <label for="campaign_id" class="form-label col-4">
                    {t}Campagne de prélèvement :{/t}
                </label>
                <div class="col-8">
                    <select id="campaign_id" name="campaign_id" class="form-select">
                        <option value="" {if $data.campaign_id=="" }selected{/if}>{t}Choisissez...{/t}
                        </option>
                        {foreach $campaigns as $campaign}
                        <option value="{$campaign.campaign_id}" {if $data.campaign_id==$campaign.campaign_id}selected{/if}>
                            {$campaign.campaign_name}
                        </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="row">
                <label for="with_subsampling1" class="form-label col-4">{t}Certains échantillons peuvent être du sous-échantillonnage de l'échantillon principal ?{/t}</label>
                <div class="col-8">
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="with_subsampling" id="with_subsampling1" value="1" {if $data.with_subsampling == 1}checked{/if}>
                        <label class="form-check-label" for="with_subsampling1">{t}oui{/t}</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="with_subsampling" id="with_subsampling0" value="0" {if $data.with_subsampling == 0}checked{/if}>
                        <label class="form-check-label" for="with_subsampling0">{t}non{/t}</label>
                    </div>
                </div>
            </div>
            <div class="row">
                <label for="odk_version" class="form-label col-4"><span class="red">*</span> {t}Version du formulaire :{/t}</label>
                <div class="col-8">
                    <input id="odk_version" type="text" class="form-control" name="odk_version" value="{$data.odk_version}" required>
                </div>
            </div>
            <div class="row">
                <label for="odk_author" class="form-label col-4">{t}Créateur du formulaire :{/t}</label>
                <div class="col-8">
                    <input id="odk_author" type="text" class="form-control" name="odk_author" value="{$data.odk_author}" readonly>
                </div>
            </div>
            <div class="row d-inline">
                <span class="messagebas"><span class="red">*</span>&nbsp;{t}Donnée obligatoire{/t}</span>
            </div>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
                {if $data.odk_id > 0 }
                <div class="col-auto">
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                </div>
                {/if}
            </div>
            {$csrf}
        </form>
    </div>
</div>