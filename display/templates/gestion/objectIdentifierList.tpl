<!-- Liste des identifiants complémentaires -->
{if $droits.gestion == 1}
<a href="index.php?module={$moduleParent}objectIdentifierChange&object_identifier_id=0&uid={$data.uid}">
<img src="display/images/new.png" height="25">Nouvel identifiant...
</a>
{/if}
<table id="objectIdentifierList" class="table table-bordered table-hover datatable-nopaging " data-order='[[ 0, "asc" ],[1,"asc"]]' >
<thead>
<tr>
<th>Type</th>
<th>Numéro</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$objectIdentifiers}
<tr>
<td>
{if $droits.gestion == 1}
<a href="index.php?module={$moduleParent}objectIdentifierChange&object_identifier_id={$objectIdentifiers[lst].object_identifier_id}&uid={$objectIdentifiers[lst].uid}">
{$objectIdentifiers[lst].identifier_type_name} 
({$objectIdentifiers[lst].identifier_type_code})
{else}
{$objectIdentifiers[lst].identifier_type_name} 
({$objectIdentifiers[lst].identifier_type_code})
{/if}
</td>
<td>
{$objectIdentifiers[lst].object_identifier_value}
</td>
</tr>
{/section}
</tbody>
</table>