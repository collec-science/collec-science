<script>
    $(document).ready(function () {
        var searchByColumn = 0;
        var myStorage = window.localStorage;
        try {
            searchByColumn = myStorage.getItem("eventSearchColumn");
            if (!searchByColumn) {
                searchByColumn = 0;
            }
        } catch (Exception) {
        }
        if (searchByColumn == 1) {
            $("#activateSearchByColumn").prop("checked", 1);
        }
        $("#activateSearchByColumn").change(function () {
            var asbc = 0;
            if (this.checked) {
                asbc = 1;
            }
            myStorage.setItem("eventSearchColumn", asbc);
        });
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
            myStorage.setItem("eventDueDelay", $(this).val());
        });
        scroll = "60vh";
        if (searchByColumn == 1) {
            var buttons = [
                {
                    extend: 'csv',
                    text: 'csv',
                    filename: 'events',
                    exportOptions: {
                        columns: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                    },
                    customize: function (csv) {
                        var split_csv = csv.split("\n");
                        //set headers
                        split_csv[0] = '"event_id","event_date","event_type_name","due_date","uid","identifier","object_type","still_available","event_comment"';
                        csv = split_csv.join("\n");
                        return csv;
                    }
                },
                {
                    extend: 'copy',
                    text: '{t}Copier{/t}',
                    customize: function (csv) {
                        var split_csv = csv.split("\n");
                        //set headers
                        split_csv.shift();
                        split_csv[0] = '\tevent_id\tevent_date\tevent_type_name\tdue_date\tuid\tidentifier\tobject_type\tstill_available\tremarks';
                        csv = split_csv.join("\n");
                        return csv;
                    }
                }
            ];
        } else {
            var buttons = [
                {
                    extend: 'csv',
                    text: 'csv',
                    filename: 'events',
                    exportOptions: {
                        columns: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                    },
                },
                {
                    extend: 'copy',
                    text: '{t}Copier{/t}',
                },
                {
                    extend: 'print',
                    text: '{t}Imprimer{/t}'
                },
                {
                    extend: 'pdfHtml5',
                    text: '{t}export PDF direct{/t}',
                    filename: 'events',
                    orientation: 'landscape',
                    title: '{t}Liste des événements{/t}',
                    exportOptions: {
                        columns: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                    },
                }
            ]
        }

        var tableList = $('#eventList').DataTable({
            //dom: 'Birtp',
            "language": dataTableLanguage,
            "paging": false,
            "searching": true,
            "stateSave": false,
            "stateDuration": 60 * 60 * 24 * 30,
            //"buttons": buttons,
            fixedHeader: {
                header: false,
                footer: false
            },
            layout: {
                topStart: {
                    buttons: buttons
                }
            }
        });
        if (searchByColumn == 1) {
            $('#eventList thead th').each(function () {
                var title = $(this).text();
                var size = title.trim().length;
                if (size > 0) {
                    $(this).html('<input type="text" placeholder="' + title + '" size="' + size + '" class="searchInput" title="' + title + '">');
                }
            });
            tableList.columns().every(function () {
                var that = this;
                if (that.index() > 0) {
                    $('input', this.header()).on('keyup change clear', function () {
                        if (that.search() !== this.value) {
                            that.search(this.value).draw();
                        }
                    });
                }
            });
            $(".searchInput").hover(function () {
                $(this).focus();
            });
        }
        $(".typeEventSearch").change(function () {
            var collection_id = $("#collection_id").val();
            var object_type = $("#object_type").val();
            var url = "eventTypeGetAjax";
            var data = { "collection_id": collection_id, "object_type": object_type };
            $.ajax({ url: url, data: data })
                .done(function (d) {
                    if (d) {
                        d = JSON.parse(d);
                        options = '<option value="0">{t}Indifférent{/t}</option>';
                        for (var i = 0; i < d.length; i++) {
                            options += '<option value="' + d[i].event_type_id + '">';
                            options += d[i].event_type_name;
                            options += '</option>';
                        };
                        $("#event_type_id").html(options);
                    }
                });
            if (object_type == 1) {
                url = "sampleTypeGetListAjax";
                var data = { "collection_id": collection_id };
                $.ajax({ url: url, data: data })
                    .done(function (d) {
                        if (d) {
                            d = JSON.parse(d);
                            options = '<option value="0">{t}Indifférent{/t}</option>';
                            for (var i = 0; i < d.length; i++) {
                                options += '<option value="' + d[i].sample_type_id + '">';
                                options += d[i].sample_type_name;
                                options += '</option>';
                            };
                            $("#object_type_id").html(options);
                        }
                    });
                $("#collection_id").prop("disabled", false);
                $("#object_type_id_label").html("{t}Type d'échantillon :{/t}");
            } else {
                url = "containerTypeGetListAjax";
                $.ajax({ url: url })
                    .done(function (d) {
                        if (d) {
                            d = JSON.parse(d);
                            options = '<option value="0">{t}Indifférent{/t}</option>';
                            for (var i = 0; i < d.length; i++) {
                                options += '<option value="' + d[i].container_type_id + '">';
                                options += d[i].container_type_name;
                                options += '</option>';
                            };
                            $("#object_type_id").html(options);
                        }
                    });
                $("#collection_id").prop("disabled", true);
                $("#object_type_id_label").html("{t}Type de contenant :{/t}");
            }
        });
        $("#events").change(function () {
            $(".events").prop("checked", $("#events").prop("checked"));
        });
        var actions = {
            "eventsChange": "eventsChange",
            "eventsDuplicate": "eventsDuplicate"
        };
        $("#checkedActionEvent").change(function () {
            var action = $(this).val();
            var actionClass = actions[action];
            var value;
            for (const key in actions) {
                if (actions.hasOwnProperty(key)) {
                    value = actions[key];
                    if (value == actionClass) {
                        $("." + value).show();
                    } else {
                        $("." + value).hide();
                    }
                }
            };
        });
        $("#checkedButtonEvent").on("keypress click", function (event) {
            var action = $("#checkedActionEvent").val();
            if (action.length > 0) {
                var conf = confirm("{t}Attention : cette opération est définitive. Est-ce bien ce que vous voulez faire ?{/t}");
                if (conf == true) {
                    $(this.form).attr("action", action);
                    $(this.form).prop('target', '_self').submit();
                } else {
                    event.preventDefault();
                }
            } else {
                event.preventDefault();
            }
        });
    });
</script>
<div class="row">
    <div class="col-md-12">
        <form class="form-horizontal " id="eventSearch" action="eventSearch" method="GET">
            <input type="hidden" name="isSearch" value="1">
            <div class="row">
                <label for="search_type" class="col-sm-2 control-label">{t}Recherche par :{/t}</label>
                <div class="col-sm-2">
                    <select class='form-control' name="search_type" id="search_type">
                        <option value="due_date" {if $eventSearch["search_type"]=="due_date" }selected{/if}>
                            {t}Date d'échéance{/t}
                        </option>
                        <option value="event_date" {if $eventSearch["search_type"]=="event_date" }selected{/if}>
                            {t}Date de l'événement{/t}
                        </option>
                        <option value="no_date" {if $eventSearch["search_type"]=="no_date" }selected{/if}>
                            {t}Pas de recherche par date{/t}
                        </option>
                    </select>
                </div>
                <label for="is_done" class="col-sm-2 control-label">{t}État de l'événement :{/t}</label>
                <div class="col-sm-2">
                    <select id="is_done" name="is_done" class="form-control">
                        <option value="-1" {if $eventSearch["is_done"]==-1}selected{/if}>{t}non réalisé{/t}</option>
                        <option value="0" {if $eventSearch["is_done"]==0}selected{/if}>{t}indifférent{/t}</option>
                        <option value="1" {if $eventSearch["is_done"]==1}selected{/if}>{t}réalisé{/t}</option>
                    </select>
                </div>
                <label id="object_type_id_label" for="object_type_id" class="col-sm-2 control-label">{if
                    $eventSearch.object_type == 1}{t}Type d'échantillon :{/t}{else}{t}Type de contenant
                    :{/t}{/if}</label>
                <div class="col-sm-2">
                    <select class="form-control" name="object_type_id" id="object_type_id">
                        <option value="0" {if $eventSearch["object_type_id"]==0}selected{/if}>{t}Indifférent{/t}
                        </option>
                        {foreach $objectTypes as $objecttype}
                        {if $eventSearch["object_type"] == 1}
                        <option value="{$objecttype.sample_type_id}" {if
                            $objecttype.sample_type_id==$eventSearch.object_type_id}selected{/if}>
                            {$objecttype.sample_type_name}
                        </option>
                        {else}
                        <option value="{$objecttype.container_type_id}" {if
                            $objecttype.container_type_id==$eventSearch.object_type_id}selected{/if}>
                            {$objecttype.container_type_name}
                        </option>
                        {/if}
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="row">
                <label for="date_from" class="col-sm-2 control-label">{t}Du :{/t}</label>
                <div class="col-sm-2">
                    <input class="datepicker form-control" id="date_from" name="date_from"
                        value="{$eventSearch.date_from}">
                </div>
                <label for="date_to" class="col-sm-2 control-label">{t}au :{/t}</label>
                <div class="col-sm-2">
                    <input class="datepicker form-control" id="date_to" name="date_to" value="{$eventSearch.date_to}">
                </div>
                <label for="object_type" class="col-sm-2 control-label">{t}Type d'objet :{/t}</label>
                <div class="col-sm-2">
                    <select id="object_type" name="object_type" class="form-control typeEventSearch">
                        <option value="1" {if $eventSearch["object_type"]==1}selected{/if}>{t}Échantillon{/t}</option>
                        <option value="2" {if $eventSearch["object_type"]==2}selected{/if}>{t}Contenant{/t}</option>
                    </select>
                </div>
            </div>
            <div class="row">
                <label for="event_type_id" class="col-sm-2 control-label">{t}Type d'événement{/t}</label>
                <div class="col-sm-2">
                    <select class="form-control" id="event_type_id" name="event_type_id">
                        <option value="0" {if $eventSearch.event_type_id==0}selected{/if}>{t}indifférent{/t}</option>
                        {foreach $eventTypes as $eventType}
                        <option value="{$eventType.event_type_id}" {if
                            $eventType.event_type_id==$eventSearch.event_type_id}selected{/if}>
                            {$eventType.event_type_name}
                        </option>
                        {/foreach}
                    </select>
                </div>
                <label for="collection_id" class="col-sm-2 control-label">{t}Collection :{/t}</label>
                <div class="col-sm-2">
                    <select class="typeEventSearch form-control" id="collection_id" name="collection_id" {if
                        $eventSearch.object_type==2}disabled{/if}>
                        <option value="0" {if $eventSearch.collection_id==0}selected{/if}>{t}indifférent{/t}</option>
                        {foreach $collections as $collection}
                        <option value="{$collection.collection_id}" {if
                            $collection.collection_id==$eventSearch.collection_id}selected{/if}>
                            {$collection.collection_name}</option>
                        {/foreach}
                    </select>
                </div>
                <label for="activateSearchByColumn" class="control-label col-sm-2">
                    {t}Activer la recherche par colonne :{/t}
                </label>
                <div class="col-sm-1">
                    <input type="checkbox" id="activateSearchByColumn" class="form-control">
                </div>

            </div>
            <div class="row">
                <input type="submit" class="col-sm-2 col-sm-offset-5 btn btn-success" value="{t}Rechercher{/t}">
            </div>
            {$csrf}
        </form>
    </div>
</div>

{if $isSearch == 1}
<form action="" method="post">
    <div class="row">
        <table id="eventList" class="table table-bordered table-hover display" data-order='[[1,"asc"]]'>
            <thead>
                <tr>
                    <th class="center">
                        <input id="events" type="checkbox" value="{$events[ls].event_id}">
                    </th>
                    <th>Id</th>
                    <th>{t}Date{/t}</th>
                    <th>{t}Type{/t}</th>
                    <th>{t}Date prévue{/t}</th>
                    <th>{t}UID de l'objet concerné{/t}</th>
                    <th>{t}Identifiant métier{/t}</th>
                    <th id="object_type_label_in_array">
                        {if $eventSearch.object_type == 1}{t}Type d'échantillon{/t}{else}{t}Type de contenant{/t}{/if}
                    </th>
                    <th>{t}Reste disponible (échantillons){/t}</th>
                    <th>{t}Commentaire{/t}</th>
                </tr>
            </thead>
            <tbody>
                {section name=lst loop=$events}
                <tr>
                    <td class="center">
                        <input type="checkbox" class="events" name="events[]" value="{$events[lst].event_id}">
                    </td>
                    <td>
                        <a
                            href="{$events[lst].object_type}eventChange?event_id={$events[lst].event_id}&uid={$events[lst].uid}">
                            {$events[lst].event_id}
                        </a>
                    </td>
                    <td>{$events[lst].event_date}</td>
                    <td>{$events[lst].event_type_name}</td>
                    <td>{$events[lst].due_date}</td>
                    <td>
                        {if $eventSearch.object_type == 1}
                        <a href="sampleDisplay?uid={$events[lst].uid}">
                            {else}
                            <a href="containerDisplay?uid={$events[lst].uid}">
                                {/if}
                                {$events[lst].uid}
                            </a>
                    </td>
                    <td>{$events[lst].identifier}</td>
                    <td>{$events[lst].sample_type_name}{$events[lst].container_type_name}</td>
                    <td>{$events[lst].still_available}</td>
                    <td>
                        <span class="textareaDisplay">{$events[lst].event_comment}</span>
                    </td>
                </tr>
                {/section}
            </tbody>
        </table>
    </div>
    {if $rights.import == 1 || $rights.collection == 1}
    <div class="row">
        <div class="col-md-6  form-horizontal">
            {t}Pour les éléments cochés :{/t}
            <input type="hidden" name="is_action" value="1">
            <select id="checkedActionEvent" class="form-control">
                <option value="" selected>{t}Choisissez{/t}</option>
                <option value="eventsChange">{t}Modifier les événements{/t}</option>
                <option value="eventsDelete">{t}Supprimer les événements{/t}</option>
                <option value="eventsDuplicate">{t}Reprogrammer les événements{/t}</option>
            </select>

            <div class="eventsChange" hidden>
                <div class="form-group">
                    <label for="event_date" class="control-label col-md-4">{t}Date :{/t}</label>
                    <div class="col-md-8">
                        <input id="event_date" name="event_date" value="{$data.event_date}"
                            class="form-control datepicker">
                    </div>
                </div>

                <div class="form-group">
                    <label for="container_status_id" class="control-label col-md-4">
                        {t}Type d'évenement :{/t}</label>
                    <div class="col-md-8">
                        <select class="form-control" id="event_type_id" name="event_type_id">
                            <option value="0" {if $eventSearch.event_type_id==0}selected{/if}>
                                {t}Choisissez{/t}
                            </option>
                            {foreach $eventTypes as $eventType}
                            <option value="{$eventType.event_type_id}" {if
                                $eventType.event_type_id==$eventSearch.event_type_id}selected{/if}>
                                {$eventType.event_type_name}
                            </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                {if $eventSearch.object_type == 1}
                <div class="form-group">
                    <label for="still_available" class="control-label col-md-4">
                        {t}Reste disponible :{/t}
                    </label>
                    <div class="col-md-8">
                        <input id="still_available" type="text" name="still_available" value="" class="form-control">
                    </div>
                </div>
                {/if}

                <div class="form-group">
                    <label for="due_date" class="control-label col-md-4">
                        {t}Date d'échéance :{/t}
                    </label>
                    <div class="col-md-8">
                        <input id="due_date" name="due_date" value="" class="form-control datepicker">
                    </div>
                </div>

                <div class="form-group">
                    <label for="event_comment" class="control-label col-md-4">{t}Commentaire :{/t}</label>
                    <div class="col-md-8">
                        <textarea id="event_comment" name="event_comment" class="form-control" rows="3"></textarea>
                    </div>
                </div>
                <div class="bg-info">
                    {t}Seules les données non vides seront mises à jour dans les événements !{/t}
                </div>
            </div>
            <div class="eventsDuplicate" hidden>
                <div class="form-group">
                    <label for="eventDueDelay" class="control-label col-md-4">
                        {t}Délai en jours pour reprogrammer les événements :{/t}
                    </label>
                    <div class="col-md-8">
                        <input type="number" id="eventDueDelay" name="eventDueDelay" class="form-control" value="365">
                    </div>
                </div>
                <div class="bg-info">
                    {t}Les événements sélectionnés vont être reprogrammés avec une date d'échéance recalculée à partir de la date de réalisation{/t}
                </div>
            </div>
            <div class="center">
                <button id="checkedButtonEvent" class="btn btn-danger">{t}Exécuter{/t}</button>
            </div>
        </div>
    </div>
    {$csrf}
</form>
{/if}
{/if}