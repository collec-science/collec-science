<script>
  $(document).ready(function() {
    $(".typeEventSearch").change(function() {
      var collection_id = $("#collection_id").val();
      var object_type = $("#object_type").val();
      var url = "index.php";
      var data = { "module":"eventTypeGetAjax", "collection_id": collection_id, "object_type": object_type };
      $.ajax ( { url:url, data: { "module":"eventTypeGetAjax", "collection_id": collection_id, "object_type": object_type }})
      .done (function( d ) {
        if (d ) {
          d = JSON.parse(d);
          options = '<option value="0">{t}Indifférent{/t}</option>';
            for (var i = 0; i < d.length; i++) {
              options += '<option value="'+d[i].event_type_id + '">';
              options += d[i].event_type_name;
              options += '</option>';
            };
          $("#event_type_id").html(options);
        }
      });
      if(object_type == 1) {
        var data = { "module":"sampleTypeGetListAjax", "collection_id": collection_id };
        $.ajax ( { url:url, data: data})
        .done (function( d ) {
          if (d ) {
            d = JSON.parse(d);
            options = '<option value="0">{t}Indifférent{/t}</option>';
              for (var i = 0; i < d.length; i++) {
                options += '<option value="'+d[i].sample_type_id + '">';
                options += d[i].sample_type_name;
                options += '</option>';
              };
            $("#object_type_id").html(options);
          }
        });
        $("#collection_id").prop("disabled", false);
        $("#object_type_id_label").html("{t}Type d'échantillon :{/t}");
      } else {
        var data = { "module":"containerTypeGetListAjax"};
        $.ajax ( { url:url, data: data})
        .done (function( d ) {
          if (d ) {
            d = JSON.parse(d);
            options = '<option value="0">{t}Indifférent{/t}</option>';
              for (var i = 0; i < d.length; i++) {
                options += '<option value="'+d[i].container_type_id + '">';
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
  });
</script>
<div class="row col-md-12">
	<form class="form-horizontal protoform" id="eventSearch" action="index.php" method="GET">
    <input type="hidden" name="module" value="eventSearch">
    <input type="hidden" name="isSearch" value="1">
    <div class="row">
      <label for="search_type" class="col-sm-2 control-label">{t}Recherche par :{/t}</label>
      <div class="col-sm-2">
        <select class='form-control' name="search_type" id="search_type">
          <option value="due_date" {if $eventSearch["search_type"] == "due_date"}selected{/if}>
          {t}Date d'échéance{/t}
          </option>
          <option value="event_date" {if $eventSearch["search_type"] == "event_date"}selected{/if}>
          {t}Date de l'événement{/t}
          </option>
        </select>
      </div>
      <label for="is_done" class="col-sm-2 control-label">{t}État de l'événement :{/t}</label>
      <div class="col-sm-2">
        <select id="is_done" name="is_done" class="form-control">
          <option value="-1" {if $eventSearch["is_done"] == -1}selected{/if}>{t}non réalisé{/t}</option>
          <option value="0" {if $eventSearch["is_done"] == 0}selected{/if}>{t}indifférent{/t}</option>
          <option value="1" {if $eventSearch["is_done"] == 1}selected{/if}>{t}réalisé{/t}</option>
        </select>
      </div>
      <label id="object_type_id_label" for="object_type_id" class="col-sm-2 control-label">{if $eventSearch.object_type == 1}{t}Type d'échantillon :{/t}{else}{t}Type de contenant :{/t}{/if}</label>
      <div class="col-sm-2">
        <select class="form-control" name="object_type_id" id="object_type_id">
          <option value="0" {if $eventSearch["object_type_id"] == 0}selected{/if}>{t}Indifférent{/t}</option>
            {foreach $objectTypes as $objecttype}
              {if $eventSearch["object_type"] == 1}
              <option value="{$objecttype.sample_type_id}" {if $objecttype.sample_type_id == $eventSearch.object_type_id}selected{/if}>
                {$objecttype.sample_type_name}
              </option>
              {else}
                <option value="{$objecttype.container_type_id}" {if $objecttype.container_type_id == $eventSearch.object_type_id}selected{/if}>
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
          <input class="datepicker form-control" id="date_from" name="date_from" value="{$eventSearch.date_from}">
      </div>
      <label for="date_to" class="col-sm-2 control-label">{t}au :{/t}</label>
      <div class="col-sm-2">
        <input class="datepicker form-control" id="date_to" name="date_to" value="{$eventSearch.date_to}">
      </div>
      <label for="object_type" class="col-sm-2 control-label">{t}Type d'objet :{/t}</label>
      <div class="col-sm-2">
        <select id="object_type" name="object_type" class="form-control typeEventSearch">
          <option value="1" {if $eventSearch["object_type"] == 1}selected{/if}>{t}Échantillon{/t}</option>
          <option value="2" {if $eventSearch["object_type"] == 2}selected{/if}>{t}Contenant{/t}</option>
        </select>
      </div>
    </div>
    <div class="row">
      <label for="event_type_id" class="col-sm-2 control-label">{t}Type d'événement{/t}</label>
      <div class="col-sm-2">
        <select class="form-control" id="event_type_id" name="event_type_id">
          <option value="0" {if $eventSearch.event_type_id == 0}selected{/if}>{t}indifférent{/t}</option>
          {foreach $eventTypes as $eventType}
            <option value="{$eventType.event_type_id}" {if $eventType.event_type_id == $eventSearch.event_type_id}selected{/if}>{$eventType.event_type_name}</option>
          {/foreach}
        </select>
      </div>
      <label for="collection_id" class="col-sm-2 control-label">{t}Collection :{/t}</label>
      <div class="col-sm-2">
        <select class="typeEventSearch form-control" id="collection_id" name="collection_id" {if $eventSearch.object_type == 2}disabled{/if}>
          <option value="0" {if $eventSearch.collection_id == 0}selected{/if}>{t}indifférent{/t}</option>
          {foreach $collections as $collection}
            <option value="{$collection.collection_id}" {if $collection.collection_id == $eventSearch.collection_id}selected{/if}>{$collection.collection_name}</option>
          {/foreach}
        </select>
      </div>

    </div>
    <div class="row">
      <input type="submit" class="col-sm-2 col-sm-offset-5 btn btn-success" value="{t}Rechercher{/t}">
    </div>
  </form>
</div>

{if $isSearch == 1}
  <table id="eventList" class="table table-bordered table-hover datatable " >
    <thead>
      <tr>
        <th>{t}Date{/t}</th>
        <th>{t}Type{/t}</th>
        <th>{t}Date prévue{/t}</th>
        <th>{t}Objet concerné{/t}</th>
        <th id="object_type_label_in_array">{if $eventSearch.object_type == 1}{t}Type d'échantillon{/t}{else}{t}Type de contenant{/t}{/if}</th>
        <th>{t}Reste disponible (échantillons){/t}</th>
        <th>{t}Commentaire{/t}</th>
      </tr>
    </thead>
    <tbody>
    {section name=lst loop=$events}
      <tr>
        <td>
          <a href="index.php?module={$moduleParent}eventChange&event_id={$events[lst].event_id}&uid={$events[lst].uid}">
          {$events[lst].event_date}
        </td>
        <td>{$events[lst].event_type_name}</td>
        <td>{$events[lst].due_date}</td>
        <td>
          {if $eventSearch.object_type == 1}
            <a href="index.php?module=sampleDisplay&uid={$events[lst].uid}">
          {else}
            <a href="index.php?module=containerDisplay&uid={$events[lst].uid}">
          {/if}
          {$events[lst].uid} {$events[lst].identifier}
          </a>
        </td>
        <td>{$events[lst].sample_type_name}{$events[lst].container_type_name}</td>
        <td>{$events[lst].still_available}</td>
        <td>
          <span class="textareaDisplay">{$events[lst].event_comment}</span>
        </td>
      </tr>
    {/section}
    </tbody>
  </table>
{/if}
