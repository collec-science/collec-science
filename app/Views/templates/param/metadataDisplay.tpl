<h2>{t}Détail du modèle de métadonnées{/t} <i>{$data.metadata_name}</i></h2>
<div class="row">
    <a href="metadataList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    {if $rights.collection == 1}
    &nbsp;
    <a href="metadataChange?metadata_id={$data.metadata_id}">
        <img src="display/images/edit.gif" height="25">
        {t}Modifier{/t}
    </a>
    {/if}
</div>
<div class="row">
    <table id="metadataList" class="table table-bordered table-hover datatable display" {if
        $rights.collection==1}data-order='[[1,"asc"]]' {/if}>
        <thead>
            <tr>
                {if $rights.collection == 1}
                <th><img src="display/images/edit.gif" height="25"></th>
                {/if}
                <th>{t}N° d'ordre{/t}</th>
                <th>{t}Nom du champ{/t}</th>
                <th>{t}Type{/t}</th>
                <th>{t}Description{/t}</th>
                <th>{t}Obligatoire ?{/t}</th>
                <th>{t}Sélection multiple possible ?{/t}</th>
                <th>{t}Unité de mesure{/t}</th>
                <th>{t}Utilisable pour les recherches ?{/t}</th>
                {if $rights.collection == 1}
                <th><img src="display/images/up.png" height="25"></th>
                <th><img src="display/images/down.png" height="25"></th>
                <th><img src="display/images/eraser.png" height="25"></th>
                {/if}
            </tr>
        </thead>
        <tbody>
            {foreach $metadata as $row}
            <tr>
                {if $rights.collection == 1}
                <td class="center">
                    <a href="metadataFieldChange?metadata_id={$data.metadata_id}&name={$row.name}">
                        <img src="display/images/edit.gif" height="25">
                    </a>
                </td>
                {/if}
                <td class="center">{$row@iteration}</td>
                <td>{$row.name}</td>
                <td>{$row.type}</td>
                <td>{$row.description}</td>
                <td class="center">{if $row.required == true}{t}oui{/t}{/if}</td>
                <td class="center">{if $row.multiple == "yes"}{t}oui{/t}{/if}</td>
                <td>{$row.measureUnit}</td>
                <td class="center">{if $row.isSearchable == "yes"}{t}oui{/t}{/if}</td>
                {if $rights.collection == 1}
                <td class="center">
                    {if $row@iteration > 1}
                    <a href="metadataFieldMove?metadata_id={$data.metadata_id}&name={$row.name}&movement=up">
                        <img src="display/images/up.png" height="25">
                    </a>
                    {/if}
                </td>
                <td class="center">
                    {if $row@last != true}
                    <a href="metadataFieldMove?metadata_id={$data.metadata_id}&name={$row.name}&movement=down">
                        <img src="display/images/down.png" height="25">
                    </a>
                    {/if}
                </td>
                <td class="center">
                    <a href="metadataFieldDelete?metadata_id={$data.metadata_id}&name={$row.name}" class="confirm"
                    title="{t}Supprimer le champ{/t}">
                        <img src="display/images/eraser.png" height="25">
                    </a>
                </td>
                {/if}
            </tr>
            {/foreach}
        </tbody>
    </table>
</div>