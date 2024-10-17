{* Paramètres > Familles de contenants > *}
<h2>{t}Familles de contenants{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $rights.param == 1}
<a href="containerFamilyChange?container_family_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="containerFamilyList" class="table table-bordered table-hover datatable display" >
<thead>
<tr>
<th>{t}Nom{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $rights.param == 1}
<a href="containerFamilyChange?container_family_id={$data[lst].container_family_id}">
{$data[lst].container_family_name}
{else}
{$data[lst].container_family_name}
{/if}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>