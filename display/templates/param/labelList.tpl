{* Paramètres > Étiquettes > *}
<h2>{t}Modèles d'étiquette{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.collection == 1}
<a href="index.php?module=labelChange&label_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="labelList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>{t}Nom de l'étiquette{/t}</th>
<th>{t}Id{/t}</th>
<th>{t}Type de code-barre{/t}</th>
<th>{t}Code simple
(un seul identifiant métier){/t}</th>
<th>{t}Champs dans le code-barre{/t}</th>
<th>{t}Nom du modèle de métadonnées rattaché{/t}</th>
{if $droits.collection == 1}
<th>{t}Modifier{/t}</th>
<th>{t}Dupliquer{/t}</th>
{/if}
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.collection == 1}
<a href="index.php?module=labelChange&label_id={$data[lst].label_id}">
{$data[lst].label_name}
</a>
{else}
{$data[lst].label_name}
{/if}
</td>
<td class="center">{$data[lst].label_id}</td>
<td class="center">{$data[lst].barcode_name}</td>
<td class="center">
{if $data[lst].identifier_only == 1}{t}oui{/t}{else}{t}non{/t}{/if}
</td>
<td>{$data[lst].label_fields}</td>
<td>{$data[lst].metadata_name}</td>
{if $droits.collection == 1}
<td class="center">
<a href="index.php?module=labelChange&label_id={$data[lst].label_id}" title="{t}Modifier l'étiquette{/t}">
<img src="display/images/edit.gif" height="25">
</a>
</td>
<td class="center">
<a href="index.php?module=labelCopy&label_id={$data[lst].label_id}" title="{t}Dupliquer l'étiquette{/t}">
<img src="display/images/copy.png" height="25">
</a>
{/if}
</tr>
{/section}
</tbody>
</table>
</div>
</div>
