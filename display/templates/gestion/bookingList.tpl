{* Objets > échantillons > Rechercher > UID d'un échantillon > section Réservations *}
<!-- Liste des réservations -->
{if $droits.gestion == 1}
<a href="index.php?module={$moduleParent}bookingChange&booking_id=0&uid={$data.uid}">
<img src="display/images/crossed-calendar.png" height="25">{t}Nouveau...{/t}
</a>
{/if}
<table id="bookingList" class="table table-bordered table-hover datatable " data-order='[0,"desc"]' >
<thead>
<tr>
<th>{t}Du{/t}</th>
<th>{t}Au{/t}</th>
<th>{t}Commentaire{/t}</th>
<th>{t}Réservé par{/t}</th>
<th>{t}Le{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$bookings}
<tr>
<td>
<a href="index.php?module={$moduleParent}bookingChange&booking_id={$bookings[lst].booking_id}&uid={$bookings[lst].uid}">
{$bookings[lst].date_from}</a>
</td>
<td><a href="index.php?module={$moduleParent}bookingChange&booking_id={$bookings[lst].booking_id}&uid={$bookings[lst].uid}">
{$bookings[lst].date_to}
</a>
</td>
<td>
<span class="textareaDisplay">{$bookings[lst].booking_comment}</span>
</td>
<td>
{$bookings[lst].booking_login}
</td>
<td>
{$bookings[lst].booking_date}
</td>
</tr>
{/section}
</tbody>
</table>