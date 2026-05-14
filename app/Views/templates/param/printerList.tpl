<div class="container">
    <h2>{t}Imprimantes{/t}</h2>
    <div class="row">
        {if $rights.param == 1}
        <a href="printerChange?printer_id=0">
            <img src="display/images/new.png" height="25">
            {t}Nouveau...{/t}
        </a>
        {/if}
        <table id="printerList" class="table table-bordered table-hover datatable display">
            <thead>
                <tr>
                    <th>{t}Nom usuel{/t}</th>
                    <th>{t}Nom de la file d'impression{/t}</th>
                    <th>{t}Serveur{/t}</th>
                    <th>{t}Utilisateur{/t}</th>
                    <th>{t}Commentaire{/t}</th>
                </tr>
            </thead>
            <tbody>
                {section name=lst loop=$data}
                <tr>
                    <td>
                        {if $rights.param == 1}
                        <a href="printerChange?printer_id={$data[lst].printer_id}">
                            {$data[lst].printer_name}
                        </a>
                        {else}
                        {$data[lst].printer_name}
                        {/if}
                    </td>
                    <td>
                        {$data[lst].printer_queue}
                    </td>
                    <td>
                        {$data[lst].printer_server}
                    </td>
                    <td>
                        {$data[lst].printer_user}
                    </td>
                    <td class="textareaDisplay">{$data[lst].printer_comment}</td>
                </tr>
                {/section}
            </tbody>
        </table>
    </div>
    <div class="row bg-info">
        {t}Ce module permet de déclarer des imprimantes qui sont pilotées directement par le serveur, et non connectées au PC de l'utilisateur.{/t}
        <br>
        {t}Le nom de la file d'impression est celui qui est déclaré dans le module CUPS du serveur.{/t}
        <br>
        {t}Si vous souhaitez utiliser cette fonctionnalité, vous devrez demander à un administrateur système de positionner la variable app.print_direct_enabled à la valeur 1 dans le fichier .env, qui contient les paramètres systèmes de l'application.{/t}
    </div>
</div>