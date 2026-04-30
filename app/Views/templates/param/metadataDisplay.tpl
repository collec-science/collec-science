<script src="display/node_modules/datatables.net-rowreorder/js/dataTables.rowReorder.min.js"></script>

<script>
    $(document).ready(function () {
        var myStorage = window.localStorage;
        var pageLength = myStorage.getItem("pageLength");
        if (!pageLength) {
            pageLength = 10;
        }
        var lengthMenu = [10, 25, 50, 100, 500, { label: 'all', value: -1 }];
        let table = $("#metadataList").DataTable({
            "language": dataTableLanguage,
            "searching": false,
            //dom: 'Bfrtip',
            layout: {
                topStart: {
                    buttons: ['pageLength']
                }
            },
            "pageLength": pageLength,
            "lengthMenu": lengthMenu,
            fixedHeader: {
                header: true,
                footer: true
            },
            rowReorder: true
        });
        table.on('row-reorder', function (e, details, edit) {
            var from = details[0].oldData - 1;
            var to = details[0].newData - 1;
            const a = document.createElement('a');
            a.href = 'metadataFieldMove?metadata_id={$data.metadata_id}&from=' + from + '&to=' + to;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        });

    });

</script>

<div class="container-fluid">
    <h2>{t}Détail du modèle de métadonnées{/t} <i>{$data.metadata_name}</i></h2>
    <div class="row">
        <div class="col-auto">
            <a href="metadataList">
                <img src="display/images/list.png" height="25">
                {t}Retour à la liste{/t}
            </a>
        </div>
    </div>
</div>
{if $rights.collection == 1}
<div class="container">
    <div class="row">
        <form id="metadataNameChange" class="form-horizontal" method="post" action="metadataNameWrite">
            <input type="hidden" name="moduleBase" value="metadata">
            <input type="hidden" name="metadata_id" value="{$data.metadata_id}">
            <div class="row">
                <label for="metadata_name" class="form-label col-4"><span class="red">*</span>
                    {t}Nom du modèle :{/t}
                </label>
                <div class="col-8">
                    <input id="metadata_name" class="form-control" name="metadata_name" value="{$data.metadata_name}" required>
                </div>
                <div class="row d-flex justify-content-center">
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                    </div>
                    {if $data.metadata_id > 0 }
                    <div class="col-auto">
                        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                    </div>
                    {/if}
                </div>
            </div>
            {$csrf}
        </form>
    </div>
</div>
{/if}
<div class="container-fluid">
    {if $rights.collection == 1}
    <div class="row">
        <div class="col-auto">
            <a href="metadataFieldChange?metadata_id={$data.metadata_id}&name=">
                <img src="display/images/new.png" height="25">
                {t}Nouveau champ{/t}
            </a>
        </div>
    </div>
    {/if}
    {if $data.metadata_id > 0}
    <div class="row">
        <table id="metadataList" class="table table-bordered table-hover display" {if $rights.collection==1}data-order='[[0,"asc"]]' {/if}>
            <thead>
                <tr>
                    <th>{t}N° d'ordre{/t}</th>
                    <th>{t}Nom du champ{/t}</th>
                    <th>{t}Type{/t}</th>
                    <th>{t}Description{/t}</th>
                    <th>{t}Obligatoire ?{/t}</th>
                    <th>{t}Sélection multiple possible ?{/t}</th>
                    <th>{t}Valeur par défaut{/t}</th>
                    <th>{t}Unité de mesure{/t}</th>
                    <th>{t}Message d'aide{/t}</th>
                    <th>{t}Utilisable pour les recherches ?{/t}</th>
                    {if $rights.collection == 1}
                    <th><img src="display/images/edit.gif" height="25"></th>
                    <th><img src="display/images/up.png" height="25" title="{t}Remonter le champ dans la liste{/t}"></th>
                    <th><img src="display/images/down.png" height="25" title="{t}Descendre le champ dans la liste{/t}"></th>
                    <th><img src="display/images/remove-red-24.png" height="25"></th>
                    {/if}
                </tr>
            </thead>
            <tbody>
                {foreach $metadata as $row}
                <tr>
                    <td class="center move">{$row@iteration}</td>
                    <td>{$row.name}</td>
                    <td>{$row.type}</td>
                    <td>{$row.description}</td>
                    <td class="center">{if $row.required == "true"}{t}oui{/t}{/if}</td>
                    <td class="center">{if $row.multiple == "yes"}{t}oui{/t}{/if}</td>
                    <td>{$row.defaultValue}</td>
                    <td>{$row.measureUnit}</td>
                    <td>{$row.helper}</td>
                    <td class="center">{if $row.isSearchable == "yes"}{t}oui{/t}{/if}</td>
                    {if $rights.collection == 1}
                    <td class="center">
                        <a href="metadataFieldChange?metadata_id={$data.metadata_id}&name={$row.name}">
                            <img src="display/images/edit.gif" height="25">
                        </a>
                    </td>
                    <td class="center">
                        {if $row@iteration > 1}
                        <a href="metadataFieldMove?metadata_id={$data.metadata_id}&name={$row.name}&from={$row@index}&to={$row@index - 1}">
                            <img src="display/images/up.png" height="25">
                        </a>
                        {/if}
                    </td>
                    <td class="center">
                        {if $row@last != true}
                        <a href="metadataFieldMove?metadata_id={$data.metadata_id}&name={$row.name}&from={$row@index}&to={$row@index + 1}">
                            <img src="display/images/down.png" height="25">
                        </a>
                        {/if}
                    </td>
                    <td class="center">
                        <a href="metadataFieldDelete?metadata_id={$data.metadata_id}&name={$row.name}" class="confirm" title="{t}Supprimer le champ{/t}">
                            <img src="display/images/remove-red-24.png" height="25">
                        </a>
                    </td>
                    {/if}
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
    <div class="row">
        <div class="bg-info offset-3 col-6 center">
            {t}Vous pouvez également modifier l'ordre des champs en cliquant-déplaçant avec la souris sur la première colonne{/t}
        </div>
    </div>
    {/if}
</div>