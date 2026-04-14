<div class="container">
    <div class="row">
        <h2>{t}Contenu du fichier {/t}{$filename}</h2>
    </div>

    <div class="row">
        <a href="getLogFiles">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
    </div>
    <br>
    <div class="row border border-2">
        <table class="table-hover">
            <tbody>
                {foreach $logs as $log}
                <tr>
                    <td>{$log}</td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>