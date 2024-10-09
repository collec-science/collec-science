<h2>{t}Liste des requêtes SQL{/t}</h2>
{if $rights.param == 1}
<a href="requestChange?request_id=0">
    <img src="display/images/new.png" height="25">
    {t}Nouvelle requête...{/t}
</a>
{/if}
<table id="crequestList" class="table table-bordered table-hover datatable display" >
    <thead>
        <tr>
            <th>{t}Id{/t}</th>
            <th>{t}Description{/t}</th>
            <th>{t}Collection concernée{/t}</th>
            <th>{t}Date de création{/t}</th>
            <th>{t}Date de dernière exécution{/t}</th>
            <th>{t}Créateur (login){/t}</th>
            <th class="center"><img src="display/images/exec.png" height="25"></th>
            {if $rights.param == 1}
                <th class="center"><img src="display/images/copy.png" height="25"></th>
            {/if}
        </tr>
    </thead>
    <tbody>
        {section name=lst loop=$data}
            <tr>
                <td>{$data[lst].request_id}</td>
                <td>
                    <a href="requestChange?request_id={$data[lst].request_id}">
                    {$data[lst].title}
                    </a>
                </td>
                <td>{$data[lst].collection_name}</td>
                <td class="center">{$data[lst].create_date}</td>
                <td class="center">{$data[lst].last_exec}</td>
                <td>{$data[lst].login}</td>
                <td class="center">
                    <a href="requestExecList?request_id={$data[lst].request_id}" title="{t}Exécuter la requête{/t}">
                        <img src="display/images/exec.png" height="25">
                    </a>
                </td>
                {if $rights.param == 1}
                    <td class="center">
                        <a href="requestCopy?request_id={$data[lst].request_id}" title="{t}Dupliquer la requête{/t}">
                            <img src="display/images/copy.png" height="25">
                        </a>
                    </td>
                {/if}
            </tr>
        {/section}
    </tbody>
</table>
