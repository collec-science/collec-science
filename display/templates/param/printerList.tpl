<h2>Imprimantes</h2>
<div class="row">
    <div class="col-md-6">
        {if $droits.param == 1}
        <a href="index.php?module=printerChange&printer_id=0">
        {$LANG["appli"][0]}
        </a>
        {/if}
        <table id="printerList" class="table table-bordered table-hover datatable " >
        <thead>
        <tr>
        <th>Nom</th>
        <th>Site</th>
        <th>Salle</th>
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
        <td class="center">
        {$data[lst].printer_site}
        </td>
        <td class="center">
        {$data[lst].printer_room}
        </td>
        </tr>
        {/section}
        </tbody>
        </table>
    </div>
</div>