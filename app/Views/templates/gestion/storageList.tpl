{* TODO vérifier que ce fichier est bien utilisé
   semble avoir été remplacé par movementList.tpl
*}
<!-- Liste des mouvements -->
<table id="movementList" class="table table-bordered table-hover datatable" >
<thead>
<tr>
<th>{t}Date{/t}</th>
<th>{t}Sens{/t}</th>
<th>{t}Contenant{/t}</th>
<th>{t}Emplacement{/t}</th>
<th>{t}Commentaire{/t}</th>
<th>{t}Utilisateur{/t}</th>
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
<span class="green">{t}Déplacement{/t}</span>{else}
<span class="red">{t}Sortie du stock{/t}</span>
{/if}
</td>
<td>
{if $movements[lst].parent_uid > 0}
<a href="containerDisplay?uid={$movements[lst].parent_uid}">
{$movements[lst].parent_uid} {$movements[lst].parent_identifier}
</a>
{/if}
</td>
<td>
{if $movements[lst].movement_type_id == 1}
{$movements[lst].storage_location}
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
	}
});
</script>
