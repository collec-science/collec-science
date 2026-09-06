<fieldset class="row">
    <legend>
        {t}Ajout ou modification{/t}
        {if $odksampletype.odk_sampletype_id > 0}
        <button class="btn btn-primary" onclick="window.location.href='odkDisplay?odk_id={$data.odk_id}&odk_sampletype_id=0'" ;>{t}Nouveau{/t}</button>
        {/if}
    </legend>
    <form class="form-horizontal " id="odkSampletypeForm" method="post">
        <input type="hidden" name="moduleBase" value="odkSampletype">
        <input type="hidden" name="action" value="Write">
        <input type="hidden" name="odk_id" value="{$data.odk_id}">
        <input type="hidden" name="odk_sampletype_id" value="{$odksampletype.odk_sampletype_id}">
        <div class="row">
            <label for="sample_type_id" class="form-label col-4"><span class="red">*</span>
                {t}Type d'échantillon cible :{/t}
            </label>
            <div class="col-8">
                <select id="sample_type_id" name="sample_type_id" class="form-select">
                    <option value="" {if $sampletypeCurrent=="0" }selected{/if}></option>
                    {foreach $sampletypes as $sampletype}
                    <option value="{$sampletype.sample_type_id}" {if $sampletype.sample_type_id==$odksampletype.sample_type_id}selected{/if}>
                        {$sampletype.sample_type_name}
                    </option>
                    {/foreach}
                </select>
            </div>
        </div>
        <div class="row">
            <label for="sampletype_order" class="form-label col-4"><span class="red">*</span>&nbsp;{t}Ordre de tri :{/t}</label>
            <div class="col-8">
                <input id="sampletype_order" type="number" class="form-control" name="sampletype_order" value="{if $odksampletype.odk_sampletype_id == 0}{$maxSortOrder + 10}{else}{$odksampletype.sampletype_order}{/if}" required>
            </div>
        </div>
        <div class="row">
            <label for="identifier_prefix" class="form-label col-4">{t}Préfixe utilisé pour générer l'identifiant métier :{/t}</label>
            <div class="col-8">
                <input id="identifier_prefix" name="identifier_prefix" class="form-control" value="{$odksampletype.identifier_prefix}">
            </div>
        </div>
        <div class="row">
            <label for="image_number" class="form-label col-4">{t}Nombre de photos (-1 : aucune, 0 : non défini) :{/t}</label>
            <div class="col-8">
                <input id="image_number" type="number" class="form-control" name="image_number" value="{$odksampletype.image_number}">
            </div>
        </div>
        <div class="row">
            <label for="video_number" class="form-label col-4">{t}Nombre de vidéos (-1 : aucune, 0 : non défini) :{/t}</label>
            <div class="col-8">
                <input id="video_number" type="number" class="form-control" name="video_number" value="{$odksampletype.video_number}">
            </div>
        </div>
        <div class="row">
            <label for="sound_number" class="form-label col-4">{t}Nombre d'enregistrements sonores (-1 : aucun, 0 : non défini) :{/t}</label>
            <div class="col-8">
                <input id="sound_number" type="number" class="form-control" name="sound_number" value="{$odksampletype.sound_number}">
            </div>
        </div>
        <div class="row d-inline">
            <span class="messagebas"><span class="red">*</span>&nbsp;{t}Donnée obligatoire{/t}</span>
        </div>
        <div class="row d-flex justify-content-center">
            <div class="col-auto">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
            </div>
            {if $odksampletype.odk_sampletype_id > 0 }
            <div class="col-auto">
                <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
            </div>
            {/if}
        </div>
        {$csrf}
    </form>
</fieldset>