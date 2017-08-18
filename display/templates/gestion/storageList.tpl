<!-- Liste des mouvements -->
<table id="storageList" class="table table-bordered table-hover datatable" >
<thead>
<tr>
<th>Date</th>
<th>Sens</th>
<th>Conteneur</th>
<th>Emplacement</th>
<th>Commentaire</th>
<th>Utilisateur</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$storages}
<tr>
<td>
{$storages[lst].storage_date}
</td>
<td>
{if $storages[lst].movement_type_id == 1}
<span class="green">Entrée</span>{else}
<span class="red">Sortie</span>
{/if}
</td>
<td>
{if $storages[lst].parent_uid > 0}
<a href="index.php?module=containerDisplay&uid={$storages[lst].parent_uid}">
{$storages[lst].parent_uid} {$storages[lst].parent_identifier}
</a>
{/if}
</td>
<td>
{$storages[lst].storage_location}
{if strlen($storages[lst].column_number) > 0}C{$storages[lst].column_number}{/if}
{if strlen($storages[lst].line_number) > 0}L{$storages[lst].line_number}{/if}
</td>
<td>
{$storages[lst].storage_reason_name}
{if strlen($storages[lst].storage_reason_name) > 0}<br>{/if}
<span class="textareaDisplay">{$storages[lst].storage_comment}</span>
</td>
<td>
{$storages[lst].login}
</td>
</tr>
{/section}
</tbody>
</table>

<script>
$(document).ready(function() {
if ( $.fn.dataTable.isDataTable( '#storageList' ) ) {
console.log("storageList is datatable");
var storageList = $("#storageList").DataTable() ;
	storageList.order([]).draw();
	} else {
	console.log ("storageList non trouvé comme datatable");
	}
});
</script>