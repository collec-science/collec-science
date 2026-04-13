<div class="container">
<h2>{t}Modification d'un statut d'objets{/t}</h2>
<div class="row">
    <div class="col-6">
        <a href="objectStatusList">{t}Retour à la liste{/t}</a>

        <form class="form-horizontal " id="objectStatusForm" method="post" action="objectStatusWrite">
            <input type="hidden" name="moduleBase" value="objectStatus">
            <input type="hidden" name="object_status_id" value="{$data.object_status_id}">
            <div class="row mb-6">
                <label for="objectStatusName" class="form-label col-4"><span class="red">*</span>
                    {t}Nom:{/t}
                </label>
                <div class="col-8">
                    <input id="objectStatusName" type="text" class="form-control" name="object_status_name"
                        value="{$data.object_status_name}" autofocus required>
                </div>
            </div>
            <div class="row mb-6 center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
            </div>
        {$csrf}</form>
    </div>
</div>

	<div class="row col-12 d-inline">
		<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
	</div>
<div class="row">
    <div class="col-6 bg-info">
        {t}Ne modifiez pas le sens général des libellés, certains statuts sont attribués automatiquement par l'application !{/t}
    </div>
</div>