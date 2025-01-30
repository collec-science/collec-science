<script>
    $(document).ready(function () {
        $("#type").change(function () {
            var val = $("#type").val();
            if (val == "select") {
                $("#multipleGroup").show();
            } else {
                $("#multipleGroup").hide();
            }
            if (val == "select" || val == "radio") {
                $("#choiceListGroup").show();
            } else {
                $("#choiceListGroup").hide();
            }
        });
        $(".choiceList").change(function () {
            for (let i = 99; i > -1; i--) {
                if ($("#choiceList" + i).length) {
                    var val = $("#choiceList" + i).val();
                    if (val.length > 0) {
                        $("#choiceList" + i).after('<input type="text" name="choiceList[]" class="form-control choiceList" id="choiceList' + (i + 1) + '">');
                    }
                }
            }
        });
        $(".helperChoice").change(function () {
            if ($("#helperChoice1").prop("checked")) {
                $("#helperGroup").show();
                $("#helper").prop("required", true);
            } else {
                $("#helperGroup").hide();
                $("#helper").prop("required", false);
            }
        });
        /**
         * Operations when loading page
         */
        var val = "{$data.type}";
        if (val == "select") {
            $("#multipleGroup").show();
        } else {
            $("#multipleGroup").hide();
        }
        if (val == "select" || val == "radio") {
            $("#choiceListGroup").show();
        } else {
            $("#choiceListGroup").hide();
        }
        var helperChoice = "{$data.helperChoice}";
        if (helperChoice == "true") {
            $("#helperGroup").show();
            $("#helper").prop("required", true);
        } else {
            $("#helperGroup").hide();
            $("#helper").prop("required", false);
        }
    });

</script>

<h2>{t}Modification du modèle de métadonnées{/t} <i>{$data.metadata_name}</i> - {t}champ{/t} <i>{$data.name}</i></h2>
<div class="row">
    <a href="metadataList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    <a href="metadataDisplay?metadata_id={$data.metadata_id}">
        <img src="display/images/zoom.png" height="25">
        {t}Retour au détail des métadonnées{/t}
    </a>
</div>
<form class="form-horizontal " id="metadataField" method="post" action="metadataFieldWrite">
    <input type="hidden" name="moduleBase" value="metadataField">
    <input type="hidden" name="metadata_id" value="{$data.metadata_id}" <div class="form-group">
    <input type="hidden" name="oldname" value="{$data.name}">
    <div class="form-group">
        <label for="name" class="control-label col-md-4"><span class="red">*</span>
            {t}Nom du champ (sans espace, sans accent, en minuscule){/t}
        </label>
        <div class="col-md-8">
            <input id="name" type="text" class="form-control" name="name" value="{$data.name}" autofocus
                required>
        </div>
    </div>
    <div class="form-group">
        <label for="type" class="control-label col-md-4"><span class="red">*</span>
            {t}Type du champ{/t}
        </label>
        <div class="col-md-8">
            <select class="form-control" id="type" name="type">
                <option value="string" {if $data.type=="string" || $data.type=="" }selected{/if}>
                    {t}Texte (une ligne){/t}
                </option>
                <option value="number" {if $data.type=="number" }selected{/if}>
                    {t}Nombre{/t}
                </option>
                <option value="date" {if $data.type=="date" }selected{/if}>
                    {t}Date{/t}
                </option>
                <option value="textarea" {if $data.type=="textarea" || $data.type=="" }selected{/if}>
                    {t}Texte (multi-ligne){/t}
                </option>
                <option value="checkbox" {if $data.type=="checkbox" }selected{/if}>
                    {t}Case à cocher{/t}
                </option>
                <option value="select" {if $data.type=="select" }selected{/if}>
                    {t}Liste à choix multiple{/t}
                </option>
                <option value="radio" {if $data.type=="radio" }selected{/if}>
                    {t}Boutons Radio{/t}
                </option>
                <option value="url" {if $data.type=="url" }selected{/if}>
                    {t}Lien vers un site externe (URL){/t}
                </option>
                <option value="array" {if $data.type=="array" }selected{/if}>
                    {t}Valeurs multiples{/t}
                </option>
        </div>
    </div>
    <div class="form-group" id="multipleGroup" hidden>
        <label for="multipleNo" class="control-label col-md-4"><span class="red">*</span>
            {t}Valeurs multiples{/t}
        </label>
        <div class="col-md-8">
            <input type="checkbox" name="multiple" id="multipleNo" {if $data.multiple !="yes" }checked{/if}
                value="no">{t}non{/t}
            <input type="checkbox" name="multiple" id="multipleYes" {if $data.multiple=="yes" }checked{/if}
                value="yes">{t}oui{/t}
        </div>
    </div>

    <div class="form-group" id="choiceListGroup" hidden>
        <label for="name" class="control-label col-md-4">
            {t}Valeurs{/t}
        </label>
        <div class="col-md-8">
            {foreach $data.choiceList as $choice}
            <input type="text" name="choiceList[]" class="form-control" value="{$choice}">
            {/foreach}
            <input type="text" name="choiceList[]" class="form-control choiceList" id="choiceList0">
        </div>
    </div>
    <div class="form-group">
        <label for="defaultValue" class="control-label col-md-4">
            {t}Valeur par défaut{/t}
        </label>
        <div class="col-md-8">
            <input id="defaultValue" type="text" class="form-control" name="defaultValue" value="{$data.defaultValue}">
        </div>
    </div>
    <div class="form-group">
        <label for="description" class="control-label col-md-4">
            <span class="red">*</span>
            {t}Description{/t}
        </label>
        <div class="col-md-8">
            <input id="name" type="text" class="form-control" name="name" value="{$data.description}" required>
        </div>
    </div>
    <div class="form-group">
        <label for="isSearchable0" class="control-label col-md-4"><span class="red">*</span>
            {t}Champ utilisé pour rechercher un échantillon ?{/t}
        </label>
        <div class="col-md-8">
            <input type="checkbox" name="isSearchable" id="isSearchable0" {if $data.isSearchable !="yes" }checked{/if}
                value="no">
            {t}non{/t}
            <input type="checkbox" name="isSearchable" id="isSearchable1" {if $data.isSearchable=="yes" }checked{/if}
                value="yes">{t}oui{/t}
        </div>
    </div>
    <div class="form-group">
        <label for="required0" class="control-label col-md-4"><span class="red">*</span>
            {t}Champ obligatoire ?{/t}
        </label>
        <div class="col-md-8">
            <input type="checkbox" name="required" id="required0" {if $data.required !="true" }checked{/if}
                value="false">
            {t}non{/t}
            <input type="checkbox" name="required" id="required1" {if $data.required=="true" }checked{/if}
                value="true">{t}oui{/t}
        </div>
    </div>
    <div class="form-group">
        <label for="measureUnit" class="control-label col-md-4">
            {t}Unité de mesure{/t}
        </label>
        <div class="col-md-8">
            <input id="measureUnit" type="text" class="form-control" name="measureUnit" value="{$data.measureUnit}">
        </div>
    </div>
    <div class="form-group">
        <label for="helperChoice" class="control-label col-md-4"><span class="red">*</span>
            {t}Affichage d'un message d'aide ?{/t}
        </label>
        <div class="col-md-8">
            <input type="checkbox" name="helperChoice" id="helperChoice0" {if $data.helperChoice !="true" }checked{/if}
                value="false" class="helperChoice">
            {t}non{/t}
            <input type="checkbox" name="helperChoice" id="helperChoice1" {if $data.helperChoice=="true" }checked{/if}
                value="true" class="helperChoice">{t}oui{/t}
        </div>
    </div>
    <div class="form-group" id="helperGroup" hidden>
        <label for="helper" class="control-label col-md-4"><span class="red">*</span>
            {t}Message d'aide - vous pouvez copier ici la description de l'unité de mesure, par exemple{/t}
        </label>
        <div class="col-md-8">
            <input id="helper" type="text" class="form-control" name="helper" value="{$data.helper}">
        </div>
    </div>
    {$csrf}
</form>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>