<h2>Modèles d'étiquette</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=labelChange&label_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="labelList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>Nom de l'étiquette</th>
<th>Id</th>
<th>Champs dans le QRCode</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=labelChange&label_id={$data[lst].label_id}{if $data[lst].operation_id>0}&operation_id={$data[lst].operation_id}{/if}">
{$data[lst].label_name}
</a>
{else}
{$data[lst].label_name}
{/if}
</td>
<td class="center">{$data[lst].label_id}</td>
<td>{$data[lst].label_fields}</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>