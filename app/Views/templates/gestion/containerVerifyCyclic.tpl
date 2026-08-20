<div class="container">
    <div class="row">
        <div class="col-auto">
            <h2>{t}Vérification de l'emplacement des contenants pour repérer les situations incohérentes{/t}</h2>
        </div>
        <div class="col-auto">
            {$help}
        </div>
    </div>
    <div class="row bg-info">
        {t}Si un contenant a été placé dans un contenant qu'il contient lui-même, au premier niveau ou dans la hiérarchie des contenants, certaines requêtes peuvent tourner indéfiniment.{/t}
        <br>
        {t}En cas de détection d'un problème de ce type, vous devrez créer un mouvement de sortie pour l'un des deux contenants, sans jamais chercher à ouvrir son détail. Passez par le menu : {/t}
        <br>
        <a href="fastOutputChange">{t}Mouvement>sortir du stock.{/t}</a>
        <br>
        {t}Attention : la recherche peut être longue !{/t}
    </div>
    <br>
    <div class="row">
        <form class="form-horizontal" method="post" action="containerVerifyCyclicExec">
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary ">
                        {t}Déclencher la recherche{/t}
                    </button>
                </div>
            </div>
            {$csrf}
        </form>
    </div>

    {if $exec == 1}
    <div class="row">
        <table class="table table-bordered table-hover datatable display">
            <thead>
                <tr>
                    <th>{t}Premier UID{/t}</th>
                    <th>{t}Second UID{/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $data as $row}
                <tr>
                    <td class="center">{$row["first"]}</td>
                    <td class="center">{$row["second"]}</td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
    {/if}
</div>