{* Objets > échantillons > Rechercher > UID d'un échantillon > en dessous des metadata *}
<!-- Liste des identifiants complémentaires -->
{if $droits.gestion == 1}
<a href="index.php?module={$moduleParent}objectIdentifierChange&object_identifier_id=0&uid={$data.uid}">
<img src="display/images/new.png" height="25">{t}Nouvel identifiant...{/t}
</a>
{/if}
<br>
<div class="col-md-6">
<table id="objectIdentifierList" class="table table-bordered table-hover datatable " data-order='[[ 0, "asc" ],[1,"asc"]]' >
<thead>
<tr>
<th>{t}Type{/t}</th>
<th>{t}Numéro{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$objectIdentifiers}
<tr>
<td>
{if $droits.gestion == 1}
<a href="index.php?module={$moduleParent}objectIdentifierChange&object_identifier_id={$objectIdentifiers[lst].object_identifier_id}&uid={$objectIdentifiers[lst].uid}">
{$objectIdentifiers[lst].identifier_type_name}
{if !empty({$objectIdentifiers[lst].identifier_type_code})}
({$objectIdentifiers[lst].identifier_type_code})
{/if}
{else}
{$objectIdentifiers[lst].identifier_type_name}
{if !empty({$objectIdentifiers[lst].identifier_type_code})}
({$objectIdentifiers[lst].identifier_type_code})
{/if}
{/if}
</td>
<td>
{$objectIdentifiers[lst].object_identifier_value}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
