<!-- Liste des événements -->
<script>
    $(document).ready(function () {
        var myStorage = window.localStorage;
        var eventDueDelay;
        try {
            eventDueDelay = myStorage.getItem("eventDueDelay");
        } catch (Exception) {
        }
        if (!eventDueDelay) {
            eventDueDelay = 365;
        }
        $("#eventDueDelay").val(eventDueDelay);
        $("#eventDueDelay").change(function () {
            eventDueDelay = $(this).val();
            myStorage.setItem("eventDueDelay", eventDueDelay);
        });
        $(".duplicate").on("click", function () {
            var eventId = $(this).data("eventid");
            var uid = $(this).data("uid");
            if (confirm("{t}Confirmez-vous la reprogrammation de cet événement ?{/t}")) {
                window.location.href = "{$moduleParent}eventDuplicate?event_id=" + eventId + "&uid=" + uid + "&eventDueDelay=" + eventDueDelay;
            }
        });
    });
</script>
{if $rights.manage == 1}
<a href="{$moduleParent}eventChange?event_id=0&uid={$data.uid}">
    <img src="display/images/new.png" height="25">{t}Nouveau...{/t}
    </a>
    &nbsp;
    {t}Délai pour reprogrammer un événement :{/t}
    <input type="number" id="eventDueDelay" name="eventDueDelay" value="365">
{/if}
<table id="eventList" class="table table-bordered table-hover datatable display" data-order='[[1,"desc"],[3,"desc"]]'>
    <thead>
        <tr>
            <th class="center">{t}Détail{/t}</th>
            {if $rights.manage == 1}
            <th class="center">
                {t}Modifier...{/t}
            </th>
            {/if}
            <th>{t}Date{/t}</th>
            <th>{t}Type{/t}</th>
            <th>{t}Date prévue{/t}</th>
            <th>{t}Reste disponible (échantillons){/t}</th>
            <th>{t}Commentaire{/t}</th>
            {if $rights.manage == 1}
            <th class="center">
                <img src="display/images/copy.png" height="25" title="{t}Reprogrammer{/t}">
            </th>
            {/if}
        </tr>
    </thead>
    <tbody>
        {section name=lst loop=$events}
        <tr>
            <td class="center">
                <a href="{$moduleParent}eventDisplay?event_id={$events[lst].event_id}&uid={$events[lst].uid}">
                    <img src="display/images/events.png" height="25">
                </a>
            </td>
            {if $rights.manage == 1}
            <td class="center" title="{t}Modifier...{/t}">
                <a href="{$moduleParent}eventChange?event_id={$events[lst].event_id}&uid={$events[lst].uid}">
                    <img src="display/images/edit.gif" height="25">
                </a>
            </td>
            {/if}
            <td>
                {$events[lst].event_date}
            </td>
            <td>
                {$events[lst].event_type_name}
            </td>
            <td>
                {$events[lst].due_date}
            </td>
            <td>
                {$events[lst].still_available}
            </td>
            <td>
                <span class="textareaDisplay">{$events[lst].event_comment}</span>
                {if $rights.manage == 1}
            <td class="center">
                <img class="duplicate" src="display/images/copy.png" height="25" title="{t}Reprogrammer{/t}"
                    data-eventid="{$events[lst].event_id}" data-uid="{$events[lst].uid}">
            </td>
            {/if}
            </td>
        </tr>
        {/section}
    </tbody>
</table>