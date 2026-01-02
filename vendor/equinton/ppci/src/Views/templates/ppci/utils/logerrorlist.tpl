<h2>{t}Liste des fichiers d'erreur{/t}</h2>
<div class="col-md-8">
    <table class="datatable-nopaging table table-bordered table-hover " data-order='[[0,"desc"]]'>
        <thead>
            <tr>
                <th>{t}Fichier{/t}</th>
                <th>{t}Taille{/t}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $logfiles as $name => $size}
            <tr>
                <td>
                    <a href="getLogContent?logfile={$name}">
                        {$name}
                    </a>
                </td>
                <td class="right">{$size}</td>
            </tr>
            {/foreach}
        </tbody>
    </table>
</div>