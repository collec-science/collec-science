<!-- Liste des mouvements -->
<table id="movementList" class="table table-bordered table-hover datatable" >
<thead>
<tr>
<th>Date</th>
<th>Sens</th>
<th>container</th>
<th>Emplacement</th>
<th>Commentaire</th>
<th>Utilisateur</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$movements}
<tr>
<td>
{$movements[lst].movement_date}
</td>
<td>
{if $movements[lst].movement_type_id == 1}
<span class="green">Entrée</span>{else}
<span class="red">Sortie</span>
{/if}
</td>
<td>
{if $movements[lst].parent_uid > 0}
<a href="index.php?module=containerDisplay&uid={$movements[lst].parent_uid}">
{$movements[lst].parent_uid} {$movements[lst].parent_identifier}
</a>
{/if}
</td>
<td>
{if $movements[lst].movement_type_id == 1}
{$movements[lst].movement_location}
{if strlen($movements[lst].column_number) > 0}C{$movements[lst].column_number}{/if}
{if strlen($movements[lst].line_number) > 0}L{$movements[lst].line_number}{/if}
{/if}
</td>
<td>
{$movements[lst].movement_reason_name}
{if strlen($movements[lst].movement_reason_name) > 0}<br>{/if}
<span class="textareaDisplay">{$movements[lst].movement_comment}</span>
</td>
<td>
{$movements[lst].login}
</td>
</tr>
{/section}
</tbody>
</table>

<script>
$(document).ready(function() {
if ( $.fn.dataTable.isDataTable( '#movementList' ) ) {
var movementList = $("#movementList").DataTable() ;
	movementList.order([]).draw();
	} else {
	console.log ("movementList non trouvé comme datatable");
	}
});
</script>