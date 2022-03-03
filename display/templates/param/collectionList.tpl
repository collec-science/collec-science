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
	<th colspan="6"></th>
	<th colspan="3" class="center">{t}Flux externes autorisés{/t}</th>
	<th colspan="4"></th>
</tr>
<tr>
	<th>{t}Nom de la collection{/t}</th>
	<th>{t}Id{/t}</th>
	<th>{t}Nom public{/t}</th>
	<th>{t}Mots clés{/t}</th>
	<th>{t}Référent{/t}</th>
	<th>{t}Groupes de login autorisés{/t}</th>
	<th>{t}Flux de mise à jour{/t}</th>
	<th>{t}Flux de consultation{/t}</th>
	<th>{t}Collection publique{/t}</th>
	<th>{t}Licence de diffusion{/t}</th>
	<th>{t}Collection sans gestion de la localisation des échantillons{/t}</th>
	<th>{t}Stockage des documents hors base de données ?{/t}</th>
	<th>{t}Chemin d'accès{/t}</th>
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
<td>{$data[lst].collection_displayname}</td>
<td>{$data[lst].collection_keywords}</td>
<td>{$data[lst].referent_name}</td>
<td>
{$data[lst].groupe}
</td>
<td class="center">
	{if $data[lst].allowed_import_flow == 1}
		{t}oui{/t}
	{/if}
</td>
<td class="center">
	{if $data[lst].allowed_export_flow == 1}
		{t}oui{/t}
	{/if}
</td>
<td class="center">
	{if $data[lst].public_collection == 1}
		{t}oui{/t}
	{/if}
</td>
<td>{$data[lst].license_name}</td>
<td class="center">{if $data[lst].no_localization == 1}{t}oui{/t}{/if}</td>
<td class="center">{if $data[lst].external_storage_enabled == 1}{t}oui{/t}{/if}</td>
<td>{$data[lst].external_storage_root}</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>
