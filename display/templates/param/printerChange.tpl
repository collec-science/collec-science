<h2>Modification d'un type d'événement</h2>
<div class="row">
    <div class="col-md-6">
        <a href="index.php?module=printerList">{$LANG.appli.1}</a>

        <form class="form-horizontal protoform" id="printerForm" method="post" action="index.php">
        <input type="hidden" name="moduleBase" value="printer">
        <input type="hidden" name="action" value="Write">
        <input type="hidden" name="printer_id" value="{$data.printer_id}">
        <div class="form-group">
            <label for="printerName"  class="control-label col-md-4">Nom<span class="red">*</span> :</label>
            <div class="col-md-8">
                <input id="printerName" type="text" class="form-control" name="printer_name" value="{$data.printer_name}" autofocus required>
            </div>
        </div>
        <!-- Champ nécessaire pour l'impresion par ssh
        <div class="form-group">
            <label for="printer_local"  class="control-label col-md-4">Branchée en local : </label>
            <div id="printer_local"class="col-md-8" >
                <label class="radio-inline">
                <input type="radio" name="printer_local" id="isSample1" value="t" {if $data.printer_local == 1}checked {/if}> oui
                </label>
                <label class="radio-inline">
                <input type="radio" name="printer_local" id="isSample2" value="f" {if $data.printer_local == ""}checked {/if}> non
                </label>
            </div>
        </div>
        -->
        <div class="form-group">
            <label for="printerSite"  class="control-label col-md-4">Site :</label>
            <div class="col-md-8">
                <input id="printerSite" type="text" class="form-control" name="printer_site" value="{$data.printer_site}" autofocus>
            </div>
        </div>
        <div class="form-group">
            <label for="printerRoom"  class="control-label col-md-4">Pièce :</label>
            <div class="col-md-8">
                <input id="printerRoom" type="text" class="form-control" name="printer_room" value="{$data.printer_room}" autofocus>
            </div>
        </div>
        <!--Champs nécessaires pour l'impresion par ssh
        <div class="form-group">
            <label for="printerIp"  class="control-label col-md-4">Adresse IP :</label>
            <div class="col-md-8">
                <input id="printerIp" type="text" class="form-control" name="printer_ip" value="{$data.printer_ip}" autofocus>
            </div>
        </div>
        <div class="form-group">
            <label for="printerPort"  class="control-label col-md-4">Port :</label>
            <div class="col-md-8">
                <input id="printerPort" type="text" class="form-control" name="printer_port" value="{$data.printer_port}" autofocus>
            </div>
        </div>
        <div class="form-group">
            <label for="printerUser"  class="control-label col-md-4">Nom d'utilisateur :</label>
            <div class="col-md-8">
                <input id="printerUser" type="text" class="form-control" name="printer_user" value="{$data.printer_user}" autofocus>
            </div>
        </div>
        <div class="form-group">
            <label for="printerSshPath"  class="control-label col-md-4">Chemin d'accès aux clés ssh :</label>
            <div class ="col-md-8">
                <input id="printerSshPath" type="text" class="form-control" name="printer_ssh_path" value="{$data.printer_ssh_path}" autofocus>
            </div>
        </div>
        -->
        <div class="form-group">
            <label for="printerUsage"  class="control-label col-md-4">Description de l'utilisation :</label>
            <div class="col-md-8">
                <input id="printerUsage" type="text" class="form-control" name="printer_usage" value="{$data.printer_usage}" autofocus>
            </div>
        </div>
        <div class="form-group center">
              <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
              {if $data.printer_id > 0 }
              <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
              {/if}
        </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>