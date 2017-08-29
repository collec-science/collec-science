<h2>Modèles de métadonnées</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.projet == 1}
<a href="index.php?module=metadataChange&metadata_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="metadataList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>Nom du modèle</th>
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
<a href="index.php?module=metadataChange&metadata_id={$data[lst].metadata_id}">
{$data[lst].metadata_name}
</a>
{else}
{$data[lst].metadata_name}
{/if}
</td>
{if $droits.projet == 1}
<td class="center">
<a href="index.php?module=metadataCopy&metadata_id={$data[lst].metadata_id}" title="Dupliquer le modèle de métadonnées">
<img src="display/images/copy.png" height="25">
</a>
</td>
{/if}
</tr>
{/section}
</tbody>
</table>
</div>
</div>