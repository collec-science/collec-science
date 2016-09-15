<!-- Liste des sous-échantillonnages réalisés -->
{if $droits.gestion == 1}
<a href="index.php?module=subsampleChange&subsample_id=0&sample_id={$data.sample_id}&uid={$data.uid}">
<img src="display/images/new.png" height="25">Nouveau...
</a>
{/if}
<!-- Calcul du reste disponible -->
{$total = $data.multiple_value}
<table id="subsampleList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>Date</th>
<th>Mouvement</th>
<th>Quantité</th>
<th>Commentaire</th>
<th>Réalisé par</th>
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
<a href="index.php?module=subsampleChange&subsample_id={$subsample[lst].subsample_id}&sample_id={$subsample[lst].sample_id}&uid={$data._uid}">
{$subsample[lst].subsample_date}
</td>
<td>
{if $subsample[lst].movement_type_id == 1}
<span class="green">Entrée</span>{else}
<span class="red">Sortie</span>
{/if}
</td>
<td >
{$subsample[lst].subsample_quantity}
</td>
<td>
<span class="textareaDisplay">{$subsample[lst].subsample_comment}</span>
</td>
<td>{$subsample[lst].subsample_login}</td>
</tr>
{/section}
</tbody>
<tfoot>
<tr><td colspan="5">Quantité restante : {$total}</td></tr>
</table>
<script>
$(document).ready(function() {
	var subsample = $("#subsampleList").DataTable();
	subsample.order([[0, 'desc']]).draw();
});
</script>