
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
<input type="submit" class="col-sm-2 col-sm-offset-1 btn btn-success" value="{t}Rechercher{/t}">
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
<td>
{$events[lst].event_type_name}
</td>
<td>
{$events[lst].due_date}
</td>
<td>
  {if $events[lst].is_sample == 1}
    <a href="index.php?module=sampleDisplay&uid={$events[lst].uid}">
  {else}
    <a href="index.php?module=containerDisplay&uid={$events[lst].uid}">
  {/if}
  {$events[lst].uid} {$events[lst].identifier}
  </a>
</td>
<td >
{$events[lst].still_available}
</td>
<td>
<span class="textareaDisplay">{$events[lst].event_comment}</span>
</td>
</tr>
{/section}
</tbody>
</table>
{/if}
