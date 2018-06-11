{* Paramètres > Sous-échantillonnage > *}
<h2>{t}Types de sous-échantillonnage{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=multipleTypeChange&multiple_type_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="multipleTypeList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>{t}Nom{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=multipleTypeChange&multiple_type_id={$data[lst].multiple_type_id}">
{$data[lst].multiple_type_name}
</a>
{else}
{$data[lst].multiple_type_name}
{/if}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>