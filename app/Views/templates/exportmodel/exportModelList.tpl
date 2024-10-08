<script>
    $(document).ready(function () {
        $(".checkSelect").change(function () {
            $('.check').prop('checked', this.checked);
        });
        $("#documentSpinner").hide();
        $("#importForm").submit(function (event) {
            if (confirm("{t}Confirmez-vous cette importation ?{/t}")) {
                $(this.form).submit();
                $("#documentSpinner").show();
            } else {
                return false;
            }
        });
    });
</script>

<h2>{t}Liste des modèles d'exportation des données{/t}</h2>

<form id="exportForm" method="post" action="exportModelExec">
    <div class="row">
        <div class="col-md-6">
            {if $rights.param == 1}
            <a href="exportModelChange?export_model_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
            {/if}
            <input type="hidden" name="moduleBase" value="exportModel">
            <input type="hidden" name="export_model_name" value="export_model">
            <input type="hidden" name="returnko" value="exportModelList">
            <table id="paramList" class="table table-bordered table-hover datatable-nopaging display"
                data-order='[["1","asc"]]'>
                <thead>
                    <tr>
                        <th>{t}Id{/t}</th>
                        <th>{t}Nom{/t}</th>
                        {if $rights.param == 1}
                        <th>{t}Modifier{/t}</th>
                        <th>{t}Dupliquer{/t}</th>
                        <th class="center">
                            <input type="checkbox" id="export" class="checkSelect" checked>
                        </th>
                        {/if}
                    </tr>
                </thead>
                <tbody>
                    {foreach $data as $row}
                    <tr>
                        <td class="center">{$row["export_model_id"]}</td>
                        <td>
                            {if $rights.param == 1}
                            <a href="exportModelDisplay?export_model_id={$row.export_model_id}">
                                {$row["export_model_name"]}
                                {else}
                                {$row["export_model_name"]}
                                {/if}
                        </td>
                        {if $rights.param == 1}
                        <td class="center">
                            <a href="exportModelChange?export_model_id={$row.export_model_id}">
                                <img src="display/images/edit.gif" height="25">
                            </a>
                        </td>
                        <td class="center">
                            <a href="exportModelDuplicate?export_model_id={$row.export_model_id}">
                                <img src="display/images/copy.png" height="25">
                            </a </td>
                        <td class="center">
                            <input type="checkbox" id="export{$row.export_model_id}" name="keys[]"
                                value={$row.export_model_id} class="check" checked>
                        </td>
                        {/if}
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6 center">
            <button id="exportButton" type="submit" class="btn btn-info">
                {t}Exporter les modèles sélectionnés{/t}</button>
        </div>
    </div>
    {$csrf}
</form>

<div class="row">
    <fieldset class="col-md-6">
        <legend>{t}Importer des modèles depuis un fichier JSON{/t}</legend>
        <form id="importForm" class="form-horizontal " method="post" action="exportModelImportExec"
            enctype="multipart/form-data">
            <input type="hidden" name="export_model_name" value="export_model">
            <div class="form-group">
                <label for="filename" class="control-label col-md-4">
                    {t}Fichier JSON à importer :{/t}
                </label>
                <div class="col-md-8">
                    <input id="filename" type="file" class="form-control" name="filename" required>
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-danger">{t}Importer le fichier{/t}</button>
                <img id="documentSpinner" src="display/images/spinner.gif" height="25">
            </div>
        {$csrf}</form>
    </fieldset>
</div>