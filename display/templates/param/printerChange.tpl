<h2>Modification d'un type d'événement</h2>
<div class="row">
    <div class="col-md-6">
        <a href="index.php?module=printerList">{$LANG.appli.1}</a>

        <form class="form-horizontal protoform" id="printerForm" method="post" action="index.php">
        <input type="hidden" name="moduleBase" value="printer">
        <input type="hidden" name="action" value="Write">
        <input type="hidden" name="printer_id" value="{$data.printer_id}">
        <div class="form-group">
            <label for="printer_name"  class="control-label col-md-4">Nom courant<span class="red">*</span> :</label>
            <div class="col-md-8">
                <input id="printer_name" type="text" class="form-control" name="printer_name" value="{$data.printer_name}" autofocus required>
            </div>
        </div>
        <div class="form-group">
            <label for="printer_queue"  class="control-label col-md-4">Nom de la file d'impression (nom technique)<span class="red">*</span>  :</label>
            <div class="col-md-8">
                <input id="printer_queue" type="text" class="form-control" name="printer_queue" value="{$data.printer_queue}" required>
            </div>
        </div>
        <div class="form-group">
            <label for="printer_server"  class="control-label col-md-4">Nom du serveur (si impression distante) :</label>
            <div class="col-md-8">
                <input id="printer_server" type="text" class="form-control" name="printer_server" value="{$data.printer_server}" >
            </div>
        </div>
        <div class="form-group">
            <label for="printer_user"  class="control-label col-md-4">Nom de l'utilisateur pour l'identification (si requis) :</label>
            <div class="col-md-8">
                <input id="printer_user" type="text" class="form-control" name="printer_user" value="{$data.printer_user}" >
            </div>
        </div>
         <div class="form-group">
            <label for="printer_comment"  class="control-label col-md-4">Commentaire :</label>
            <div class="col-md-8">
                <textarea  id="printer_comment" class="form-control" name="printer_comment" rows="5">{$data.printer_comment}</textarea>
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