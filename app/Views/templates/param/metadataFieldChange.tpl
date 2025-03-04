<script>
    $(document).ready(function () {
        $("#type").change(function () {
            var val = $("#type").val();
            if (val == "select") {
                $("#multipleGroup").show();
            } else {
                $("#multipleGroup").hide();
            }
            if (val == "select" || val == "radio" || val == "checkbox") {
                $("#choiceListGroup").show();
            } else {
                $("#choiceListGroup").hide();
            }
        });
        var numligne = 1;
        $(document).on("keyup", function (e) {
            var target = $(e.target);
            /**
             * Add a new line in multiple values
             */
            if (target.is('.choiceList') && $(target).val().length && $(target).data("ligne") == $("#multiples tr:last-child").data("ligne")) {
                var ligne = '<tr id="multiple' + numligne + '" data-ligne="' + numligne + '">';
                ligne += '<td><input type="text" name="choiceList[]" class="form-control choiceList"' + '" data-ligne="' + numligne + '"></td>';
                ligne += '<td class="center"><img class="removeMultiple" src="display/images/remove-red-24.png" height="25"data-ligne="' + numligne + '">';
                ligne += '</td></tr>';
                $("#multiples").last().append(ligne);
                numligne++;
            }
        });
        $(document).on("click", function (e) {
            var target = $(e.target);
            /**
             * Delete a multiple value
             */
            if (target.is('.removeMultiple') && $(target).data("ligne") != $("#multiples tr:last-child").data("ligne")) {
                $("#multiple" + $(target).data("ligne")).remove();
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
        if (val == "select" || val == "radio" || val == "checkbox") {
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
            {t}Nom du champ (minuscules, chiffres ou _, sans espace, sans tiret){/t}
        </label>
        <div class="col-md-8">
            <input id="name" type="text" class="form-control" name="name" value="{$data.name}" pattern="[a-z0-9_]*" 
            title="{t}Uniquement des minuscules, des chiffres, ou le caractère _{/t}"
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
                <option value="textarea" {if $data.type=="textarea" }selected{/if}>
                    {t}Texte (multi-ligne){/t}
                </option>
                <option value="checkbox" {if $data.type=="checkbox" }selected{/if}>
                    {t}Case à cocher{/t}
                </option>
                <option value="select" {if $data.type=="select" }selected{/if}>
                    {t}Liste de choix{/t}
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
            </select>
        </div>
    </div>
    <div class="form-group" id="multipleGroup">
        <label for="multipleNo" class="control-label col-md-4"><span class="red">*</span>
            {t}Valeurs multiples ?{/t}
        </label>
        <div class="col-md-8">
            <input class="multiple" type="radio" name="multiple" id="multipleNo" {if $data.multiple !='yes'
                }checked{/if} value="no">&nbsp;{t}non{/t}
            <input type="radio" class="multiple" name="multiple" id="multipleYes" {if $data.multiple=='yes'
                }checked{/if} value="yes">&nbsp;{t}oui{/t}
        </div>
    </div>
    <div class="form-group" id="choiceListGroup" hidden>
        <label for="name" class="control-label col-md-4">
            {t}Valeurs{/t}
        </label>
        <div class="col-md-8">
            <table id="multiples">
                {$numligne = 1000}
                {foreach $data.choiceList as $choice}
                <tr id="multiple{$numligne}" data-ligne="{$numligne}">
                    <td>
                        <input type="text" name="choiceList[]" class="form-control choiceList" value="{$choice}"
                            data-ligne="{$numligne}">
                    </td>
                    <td class="center">
                        <img class="removeMultiple" src="display/images/remove-red-24.png" height="25"
                            data-ligne="{$numligne}">
                    </td>
                </tr>
                {$numligne = $numligne + 1}
                {/foreach}
                <tr id="multiple{$numligne}" data-ligne="{$numligne}">
                    <td>
                        <input type="text" name="choiceList[]" class="form-control choiceList" value=""
                            data-ligne="{$numligne}">
                    </td>
                    <td class="center">
                        <img class="removeMultiple" src="display/images/remove-red-24.png" height="25"
                            data-ligne="{$numligne}">
                    </td>
                </tr>
            </table>

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
            <input id="description" type="text" class="form-control" name="description" value="{$data.description}" required>
        </div>
    </div>
    <div class="form-group">
        <label for="isSearchable0" class="control-label col-md-4"><span class="red">*</span>
            {t}Champ utilisé pour rechercher un échantillon ?{/t}
        </label>
        <div class="col-md-8">
            <input type="radio" name="isSearchable" id="isSearchable0" {if $data.isSearchable !="yes" }checked{/if}
                value="no">
            {t}non{/t}
            <input type="radio" name="isSearchable" id="isSearchable1" {if $data.isSearchable=="yes" }checked{/if}
                value="yes">&nbsp;{t}oui{/t}
        </div>
    </div>
    <div class="form-group">
        <label for="required0" class="control-label col-md-4"><span class="red">*</span>
            {t}Champ obligatoire ?{/t}
        </label>
        <div class="col-md-8">
            <input type="radio" name="required" id="required0" {if $data.required !="true" }checked{/if}
                value="false">&nbsp;
            {t}non{/t}
            <input type="radio" name="required" id="required1" {if $data.required=="true" }checked{/if}
                value="true">&nbsp;{t}oui{/t}
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
            <input type="radio" name="helperChoice" id="helperChoice0" {if $data.helperChoice !="true" }checked{/if}
                value="false" class="helperChoice">&nbsp;
            {t}non{/t}
            <input type="radio" name="helperChoice" id="helperChoice1" {if $data.helperChoice=="true" }checked{/if}
                value="true" class="helperChoice">&nbsp;{t}oui{/t}
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
    <div class="form-group center">
        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
    </div>
    {$csrf}
</form>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>