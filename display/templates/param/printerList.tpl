{* Paramètres > Imprimantes > *}
<h2>{t}Imprimantes{/t}</h2>
<div class="row">
    <div class="col-md-6">
        {if $droits.param == 1}
        <a href="index.php?module=printerChange&printer_id=0">
        {t}Nouveau...{/t}
        </a>
        {/if}
        <table id="printerList" class="table table-bordered table-hover datatable " >
        <thead>
        <tr>
        <th>{t}Nom usuel{/t}</th>
        <th>{t}Nom de la
file d'impression{/t}</th>
        <th>{t}Serveur{/t}</th>
        <th>{t}Utilisateur{/t}</th>
        <th>{t}Commentaire{/t}</th>
        </tr>
        </thead>
        <tbody>
        {section name=lst loop=$data}
        <tr>
        <td>
        {if $droits.param == 1}
        <a href="index.php?module=printerChange&printer_id={$data[lst].printer_id}">
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
</div>