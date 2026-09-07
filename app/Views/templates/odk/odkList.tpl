<div class="container-fluid">
    <h2>{t}Modèles de formulaires de saisie ODK{/t}</h2>
    <div class="row">
        {if $rights.collection == 1}
        <a href="odkChange?odk_id=0">
            <img src="display/images/new.png" height="25">
            {t}Nouveau...{/t}
        </a>
        {/if}
        <table id="odkList" class="table table-bordered table-hover datatable display">
            <thead>
                <tr>
                    <th>{t}Nom{/t}</th>
                    <th>{t}Collection{/t}</th>
                    <th>{t}Campagne{/t}</th>
                    <th>{t}Sous-échantillonnage autorisé{/t}</th>
                    <th>{t}Projet ODK{/t}</th>
                    <th>{t}Description{/t}</th>
                    <th>{t}Version{/t}</th>
                    <th>{t}Auteur{/t}</th>
                    {if $rights.collection == 1}
                    <th>{t}Modifier{/t}</th>
                    {/if}
                </tr>
            </thead>
            <tbody>
                {foreach $data as $row}
                <tr>
                    <td>
                        <a href="odkDisplay?odk_id={$row.odk_id}"> {$row.odk_name} </a>
                    </td>
                    <td> {$row.collection_name} </td>
                    <td> {$row.campaign_name} </td>
                    <td class="center">{if $row.with_subsampling == 1}{t}oui{/t}{else}{t}non{/t}{/if}</td>
                    <td> {$row.odk_project} </td>
                    <td class="textareaDisplay">{$row.odk_description}</td>
                    <td> {$row.odk_version} </td>
                    <td> {$row.odk_author} </td>
                    {if $rights.collection == 1}
                    <td class="center">
                        <a href="odkChange?odk_id={$row.odk_id}">
                            <img src="display/images/edit.gif" height="25">
                        </a>
                    </td>
                    {/if}
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>