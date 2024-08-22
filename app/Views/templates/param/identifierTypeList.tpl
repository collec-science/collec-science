{* Paramètres > Types d'identifiants > *}
<h2>{t}Types d'identifiants{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $rights.param == 1}
<a href="identifierTypeChange?identifier_type_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="identifierTypeList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>{t}Nom{/t}</th>
<th>{t}Code{/t}</th>
<th>{t}Utilisé pour la recherche ?{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $rights.param == 1}
<a href="identifierTypeChange?identifier_type_id={$data[lst].identifier_type_id}">
{$data[lst].identifier_type_name}
</a>
{else}
{$data[lst].identifier_type_name}
{/if}
</td>
<td>
{$data[lst].identifier_type_code}
</td>
<td>
{if $data[lst].used_for_search == 't'}{t}oui{/t}{else}{t}non{/t}{/if}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>