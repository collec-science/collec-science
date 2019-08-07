<h2>{t}Détail du modèle de métadonnées{/t} {$data.metadata_name}</h2>
<div class="row">
    <a href="index.php?module=metadataList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    {if $droits.collection == 1}
    &nbsp;
    <a href="index.php?module=metadataChange&metadata_id={$data.metadata_id}">
        <img src="display/images/edit.gif" height="25">
        {t}Modifier{/t}
    </a>
    {/if}
</div>
<div class="row">
    <table id="metadataList" class="table table-bordered table-hover datatable " >
        <thead>
            <tr>
                <th>{t}Nom du champ{/t}</th>
                <th>{t}Type{/t}</th>
                <th>{t}Description{/t}</th>
                <th>{t}Obligatoire ?{/t}</th>
                <th>{t}Unité de mesure{/t}</th>
                <th>{t}Utilisable pour les recherches ?{/t}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $metadata as $row}
                <tr>
                    <td>{$row.name}</td>
                    <td>{$row.type}</td>
                    <td>{$row.description}</td>
                    <td class="center">{if $row.required == "true"}{t}oui{/t}</td>
                    <td>{$row.measureUnit}</td>
                    <td class="center">{if $row.isSearchable == "yes"}{t}oui{/t}</td>
                </tr>
            {/foreach}
        </tbody>

</div>

