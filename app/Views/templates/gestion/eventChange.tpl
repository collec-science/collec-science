<script>
    $( document ).ready( function () {
        var current_due_date = $( "#due_date" ).val();
        $( "#due_date" ).change( function () {
            if ( current_due_date.length == 0 ) {
                $( "#event_date" ).val( "" );
            }
            current_due_val = $( this ).val();
        } );
        $("#{$moduleParent}Form").submit(function (e) {
            console.log("test");
            if (!$("#due_date").val() && !$("#event_date").val()) {
                alert(
                    "{t}La date prévisionnelle ou la date de réalisation doit être renseignée{/t}"
                    );
                e.preventDefault();
            }
        });
    } );
</script>
<h2>{t}Création - modification d'un événement{/t}</h2>

<div class="row">
    <div class="col-md-6">
        <a href="{$moduleListe}">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
        <a href="{$moduleParent}Display?uid={$object.uid}&activeTab={$activeTab}">
            <img src="display/images/edit.gif" height="25">
            {t}Retour au détail{/t} ({$object.uid} {$object.identifier})
        </a>
        <form class="form-horizontal" id="{$moduleParent}Form" method="post" action="index.php">
            <input type="hidden" name="event_id" value="{$data.event_id}">
            <input type="hidden" name="moduleBase" value="{$moduleParent}event">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="uid" value="{$object.uid}">
            <input type="hidden" name="activeTab" value="{$activeTab}">

            <div class="form-group">
                <label for="event_date" class="control-label col-md-4">{t}Date :{/t}</label>
                <div class="col-md-8">
                    <input id="event_date" name="event_date" value="{$data.event_date}" class="form-control datepicker">
                </div>
            </div>


            <div class="form-group">
                <label for="container_status_id" class="control-label col-md-4"><span class="red">*</span> 
                    {t}Type d'évenement :{/t}
                </label>
                <div class="col-md-8">
                    <select id="event_type_id" name="event_type_id" class="form-control">
                        {section name=lst loop=$eventType}
                        <option value="{$eventType[lst].event_type_id}" {if
                            $eventType[lst].event_type_id==$data.event_type_id}selected{/if}>
                            {$eventType[lst].event_type_name}
                        </option>
                        {/section}
                    </select>
                </div>
            </div>
            {if $moduleParent == "sample"}
            <div class="form-group">
                <label for="still_available" class="control-label col-md-4">{t}Reste disponible :{/t}</label>
                <div class="col-md-8">
                    <input id="still_available" type="text" name="still_available" value="{$data.still_available}"
                        class="form-control">
                </div>
            </div>
            {/if}

            <div class="form-group">
                <label for="due_date" class="control-label col-md-4">{t}Date d'échéance :{/t}</label>
                <div class="col-md-8">
                    <input id="due_date" name="due_date" value="{$data.due_date}" class="form-control datepicker">
                </div>
            </div>

            <div class="form-group">
                <label for="event_comment" class="control-label col-md-4">{t}Commentaire :{/t}</label>
                <div class="col-md-8">
                    <textarea id="event_comment" name="event_comment" class="form-control"
                        rows="3">{$data.event_comment}</textarea>
                </div>
            </div>

            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.event_id > 0 }
                <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        {$csrf}</form>
    </div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>