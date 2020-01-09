<h2>{t}Liste des requêtes SQL{/t}</h2>
<a href="index.php?module=requestChange&request_id=0">
    <img src="display/images/new.png" height="25">
    {t}Nouvelle requête...{/t}
</a>
<table id="crequestList" class="table table-bordered table-hover datatable" >
    <thead>
        <tr>
            <th>{t}Id{/t}</th>
            <th>{t}Description{/t}</th>
            <th>{t}Date de création{/t}</th>
            <th>{t}Date de dernière exécution{/t}</th>
            <th>{t}Créateur (login){/t}</th>
            <th class="center"><img src="display/images/exec.png" height="25"></th>
            <th class="center"><img src="display/images/copy.png" height="25"></th>
        </tr>
    </thead>
    <tbody>
        {section name=lst loop=$data}
            <tr>
                <td>{$data[lst].request_id}</td>
                <td>
                    <a href="index.php?module=requestChange&request_id={$data[lst].request_id}">
                    {$data[lst].title}
                    </a>
                </td>
                <td class="center">{$data[lst].create_date}</td>
                <td class="center">{$data[lst].last_exec}</td>
                <td>{$data[lst].login}</td>
                <td class="center">
                    <a href="index.php?module=requestExecList&request_id={$data[lst].request_id}" title="{t}Exécuter la requête{/t}">
                        <img src="display/images/exec.png" height="25">
                    </a>
                </td>
                <td class="center">
                    <a href="index.php?module=requestCopy&request_id={$data[lst].request_id}" title="{t}Créer une nouvelle requête{/t}">
                        <img src="display/images/copy.png" height="25">
                    </a>
                </td>
            </tr>
        {/section}
    </tbody>
</table>