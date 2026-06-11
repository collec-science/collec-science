<div class="container">
    <h2>{t}Création - Modification d'un type d'événement{/t}</h2>
    <div class="row">
        <a href="eventTypeList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
    </div>
    <div class="row">
        <form class="form-horizontal " id="eventTypeForm" method="post" action="eventTypeWrite">
            <input type="hidden" name="moduleBase" value="eventType">
            <input type="hidden" name="event_type_id" value="{$data.event_type_id}">
            <div class="row">
                <label for="eventTypeName" class="form-label col-4"><span class="red">*</span> {t}Nom :{/t}</label>
                <div class="col-8">
                    <input id="eventTypeName" type="text" class="form-control" name="event_type_name" value="{$data.event_type_name}" autofocus required>
                </div>
            </div>
            <div class="row">
                <label for="is_sample" class="form-label col-4">{t}Utilisable pour les échantillons :{/t}</label>
                <div id="is_sample" class="col-8">
                    <label class="radio-inline">
                        <input type="radio" name="is_sample" id="isSample1" value="t" {if $data.is_sample=='t' }checked {/if}>
                        {t}oui{/t}
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="is_sample" id="isSample2" value="f" {if $data.is_sample!="t" }checked {/if}>
                        {t}non{/t}
                    </label>
                </div>
            </div>
            <div class="row">
                <label for="is_container" class="form-label col-4">{t}Utilisable pour les contenants :{/t}</label>
                <div id="is_container" class="col-8">
                    <label class="radio-inline">
                        <input type="radio" name="is_container" id="isContainer1" value="t" {if $data.is_container=='t' }checked {/if}>
                        {t}oui{/t}
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="is_container" id="isContainer2" value="f" {if $data.is_container!="t" }checked {/if}> {t}non{/t}
                    </label>
                </div>
            </div>
            <div class="row d-inline">
                <span class="messagebas"><span class="red">*</span>&nbsp;{t}Donnée obligatoire{/t}</span>
            </div>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
                {if $data.event_type_id > 0 }
                <div class="col-auto">
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                </div>
                {/if}
            </div>
            {$csrf}
        </form>
    </div>
</div>