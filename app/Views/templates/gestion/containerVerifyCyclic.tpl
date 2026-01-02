<h2>{t}Vérification de l'emplacement des contenants pour repérer les situations incohérentes{/t}</h2>
<div class="row">
    <div class="bg-info col-md-6">
        {t}Si un contenant a été placé dans un contenant qu'il contient lui-même, au premier niveau ou dans la hiérarchie des contenants, certaines requêtes peuvent tourner indéfiniment.{/t}
        <br>
        {t}En cas de détection d'un problème de ce type, vous devrez créer un mouvement de sortie pour l'un des deux contenants, sans jamais chercher à ouvrir son détail. Passez par le menu : {/t}
        <br>
        <a href="fastOutputChange">{t}Mouvement>sortir du stock.{/t}</a> 
        <br>
        {t}Attention : la recherche peut être longue !{/t}
    </div>
</div>
<br>
<div class="row">
    <div class="col-md-6">
        <form class="form-horizontal" method="post" action="containerVerifyCyclicExec">
            <div class="center">
                <button type="submit" class="button btn-primary">{t}Déclencher la recherche{/t}</button>
            </div>
            {$csrf}
        </form>
    </div>
</div>

{if $exec == 1}
<div class="row">
    <div class="col-md-6">
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
</div>

{/if}