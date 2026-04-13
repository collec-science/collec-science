{* Paramètres > Imprimantes > Nouveau > *}
<div class="container">
<h2>{t}Création - Modification d'une imprimante{/t}</h2>
<div class="row">
    <div class="col-6">
        <a href="printerList">{t}Retour à la liste{/t}</a>

        <form class="form-horizontal " id="printerForm" method="post" action="printerWrite">
        <input type="hidden" name="moduleBase" value="printer">
        <input type="hidden" name="printer_id" value="{$data.printer_id}">
        <div class="row">
            <label for="printer_name"  class="form-label col-4"><span class="red">*</span> {t}Nom usuel :{/t}</label>
            <div class="col-8">
                <input id="printer_name" type="text" class="form-control" name="printer_name" value="{$data.printer_name}" autofocus required>
            </div>
        </div>
        <div class="row">
            <label for="printer_queue"  class="form-label col-4"><span class="red">*</span> {t}Nom de la file d'impression (nom technique) :{/t}</label>
            <div class="col-8">
                <input id="printer_queue" type="text" class="form-control" name="printer_queue" value="{$data.printer_queue}" required>
            </div>
        </div>
        <div class="row">
            <label for="printer_server"  class="form-label col-4">{t}Nom du serveur (si impression distante) :{/t}</label>
            <div class="col-8">
                <input id="printer_server" type="text" class="form-control" name="printer_server" value="{$data.printer_server}" >
            </div>
        </div>
        <div class="row">
            <label for="printer_user"  class="form-label col-4">{t}Nom de l'utilisateur pour l'identification (si requis) :{/t}</label>
            <div class="col-8">
                <input id="printer_user" type="text" class="form-control" name="printer_user" value="{$data.printer_user}" >
            </div>
        </div>
         <div class="row">
            <label for="printer_comment"  class="form-label col-4">{t}Commentaire :{/t}</label>
            <div class="col-8">
                <textarea  id="printer_comment" class="form-control" name="printer_comment" rows="5">{$data.printer_comment}</textarea>
            </div>
        </div>
        
        <div class="row center">
              <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
              {if $data.printer_id > 0 }
              <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
              {/if}
        </div>
        {$csrf}</form>
    </div>
</div>
	<div class="row col-12 d-inline">
		<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
	</div>