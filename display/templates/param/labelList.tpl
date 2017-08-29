<h2>Modèles d'étiquette</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.projet == 1}
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
<th>Nom du modèle de métadonnées rattaché</th>
{if $droits.projet == 1}
<th>Dupliquer</th>
{/if}
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.projet == 1}
<a href="index.php?module=labelChange&label_id={$data[lst].label_id}">
{$data[lst].label_name}
</a>
{else}
{$data[lst].label_name}
{/if}
</td>
<td class="center">{$data[lst].label_id}</td>
<td>{$data[lst].label_fields}</td>
<td>{$data[lst].metadata_name}</td>
{if $droits.projet == 1}
<td class="center">
<a href="index.php?module=labelCopy&label_id={$data[lst].label_id}" title="Dupliquer l'étiquette">
<img src="display/images/copy.png" height="25">
</a>
{/if}
</tr>
{/section}
</tbody>
</table>
</div>
</div>