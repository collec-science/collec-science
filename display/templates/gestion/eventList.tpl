{* Objets > échantillons > Rechercher > UID d'un échantillon > section Événements *}
<!-- Liste des événements -->
{if $droits.gestion == 1}
<a href="index.php?module={$moduleParent}eventChange&event_id=0&uid={$data.uid}">
<img src="display/images/new.png" height="25">{t}Nouveau...{/t}
</a>
{/if}
<table id="eventList" class="table table-bordered table-hover datatable " data-order='[[1,"desc"],[3,"desc"]]'>
<thead>
<tr>
{if $droits.gestion == 1}
  <th class="center">
    {t}Modifier...{/t}
  </th>
{/if}
<th>{t}Date{/t}</th>
<th>{t}Type{/t}</th>
<th>{t}Date prévue{/t}</th>
<th>{t}Reste disponible (échantillons){/t}</th>
<th>{t}Commentaire{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$events}
<tr>
  {if $droits.gestion == 1}
    <td class="center" title="{t}Modifier...{/t}">
      <a href="index.php?module={$moduleParent}eventChange&event_id={$events[lst].event_id}&uid={$events[lst].uid}">
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
