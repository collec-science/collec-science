{* Objets > échantillons > Rechercher > UID d'un échantillon > section Événements *}
<!-- Liste des événements -->
{if $droits.gestion == 1}
<a href="index.php?module={$moduleParent}eventChange&event_id=0&uid={$data.uid}">
<img src="display/images/new.png" height="25">{t}Nouveau...{/t}
</a>
{/if}
<table id="eventList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>{t}Date{/t}</th>
<th>{t}Type{/t}</th>
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