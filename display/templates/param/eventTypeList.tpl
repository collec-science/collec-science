{* Paramètres > Types d'événement > *}
<h2>{t}Types d'événement{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=eventTypeChange&event_type_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="eventTypeList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>{t}Nom{/t}</th>
<th>{t}Valide pour les échantillons ?{/t}</th>
<th>{t}Valide pour les contenants ?{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=eventTypeChange&event_type_id={$data[lst].event_type_id}">
{$data[lst].event_type_name}
</a>
{else}
{$data[lst].event_type_name}
{/if}
</td>
<td class="center">
{if $data[lst].is_sample == 1}{t}oui{/t}{else}{t}non{/t}{/if}
</td>
<td class="center">
{if $data[lst].is_container == 1}{t}oui{/t}{else}{t}non{/t}{/if}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>