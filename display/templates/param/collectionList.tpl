{* Paramètres > Collections > *}
<h2>{t}Collections{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=collectionChange&collection_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="collectionList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>{t}Nom de la collection{/t}</th>
<th>{t}Id{/t}</th>
<th>{t}Référent{/t}</th>
<th>{t}Groupes de login autorisés{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=collectionChange&collection_id={$data[lst].collection_id}">
{$data[lst].collection_name}
</a>
{else}
{$data[lst].collection_name}
{/if}
</td>
<td class="center">{$data[lst].collection_id}</td>
<td>{$data[lst].referent_name}</td>
<td>
{$data[lst].groupe}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>