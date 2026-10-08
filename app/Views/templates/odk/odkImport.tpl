<div class="container">
    <div class="row">
        <div class="col-auto">
            <h2>{t}Importer les échantillons saisis avec ODK{/t}</h2>
        </div>
        <div class="col-auto">
            {$help}
        </div>
    </div>
    <div class="row">
        <form class="form-horizontal " id="odkForm" method="post" action="odkImportExec" enctype="multipart/form-data">
            <div class="row">
                <label for="odk_id" class="form-label col-4"><span class="red">*</span>
                    {t}Formulaire utilisé :{/t}
                </label>
                <div class="col-8">
                    <select id="odk_id" name="odk_id" class="form-select" autofocus>
                        {foreach $odks as $odk}
                        <option value="{$odk.odk_id}">
                            {$odk.odk_name} {$odk.odk_version}
                        </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="row">
                <label for="odkfile" class="form-label col-4"><span class="red">*</span>
                    {t}Fichier zip à importer :{/t}
                </label>
                <div class="col-8">
                    <input type="file" name="odkfile" id="odkfile" required accept=".zip" class="form-control">
                </div>
            </div>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Importer les échantillons{/t}</button>
                </div>
            </div>
            {$csrf}
        </form>
    </div>
    <div class="row bg-info">
        {t}Le fichier doit avoir été généré depuis ODK Central avec les options suivantes :{/t}
        <ul>
            <li>{t}Toutes données et fichiers joints{/t}</li>
            <li>{t}La case "supprimer les noms de groupe" doit être cochée{/t}</li>
        </ul>
        <div class="row">
            <div class="col-auto">
                <img src="display/images/odkcentral-generatefile.png">
            </div>
            
        </div>
    </div>

</div>