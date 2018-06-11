{* Paramètres > Statuts des objets > *}
<h2>{t}Liste des statuts utilisables pour les objets{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=objectStatusChange&object_status_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="objectStatusList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>{t}Nom{/t}</th>
<th>{t}Id{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=objectStatusChange&object_status_id={$data[lst].object_status_id}">
{$data[lst].object_status_name}
{else}
{$data[lst].object_status_name}
{/if}
</td>
<td class="center">{$data[lst].object_status_id}</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>