{* Objets > échantillons > Rechercher > UID d'un échantillon > section Sous-échantillons *}
<!-- Liste des sous-échantillonnages réalisés -->
{if $droits.gestion == 1}
<a href="index.php?module=subsampleChange&subsample_id=0&sample_id={$data.sample_id}&uid={$data.uid}">
<img src="display/images/new.png" height="25">{t}Nouveau...{/t}
</a>
{/if}
<!-- Calcul du reste disponible -->
{$total = $data.multiple_value}
<table id="subsampleList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>{t}Date{/t}</th>
<th>{t}Mouvement{/t}</th>
<th>{t}Quantité{/t}</th>
<th>{t}Emprunteur{/t}</th>
<th>{t}Commentaire{/t}</th>
<th>{t}Réalisé par{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$subsample}
{if $subsample[lst].movement_type_id == 1}
{$total = $total + $subsample[lst].subsample_quantity}
{else}
{$total = $total - $subsample[lst].subsample_quantity}
{/if}
<tr>
<td>
<a href="index.php?module=subsampleChange&subsample_id={$subsample[lst].subsample_id}&sample_id={$subsample[lst].sample_id}&uid={$data.uid}">
{$subsample[lst].subsample_date}
</td>
<td>
{if $subsample[lst].movement_type_id == 1}
<span class="green">{t}Déplacement{/t}</span>{else}
<span class="red">{t}Sortie du stock{/t}</span>
{/if}
</td>
<td >
{$subsample[lst].subsample_quantity}
</td>
<td>
	<a href="index.php?module=borrowerDisplay&borrower_id={$subsample[lst].borrower_id}">
	{$subsample[lst].borrower_name}
	</a>
</td>
<td>
<span class="textareaDisplay">{$subsample[lst].subsample_comment}</span>
</td>
<td>{$subsample[lst].subsample_login}</td>
</tr>
{/section}
</tbody>
<tfoot>
<tr><td colspan="6">{t 1=$total}Quantité restante : %1{/t}</td></tr>
</table>
<script>
$(document).ready(function() {
	var subsample = $("#subsampleList").DataTable();
	subsample.order([[0, 'desc']]).draw();
});
</script>
