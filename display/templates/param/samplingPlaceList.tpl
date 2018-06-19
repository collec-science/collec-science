{* Paramètres > Lieux de prélèvement > *}
<h2>{t}Lieux de prélèvement{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=samplingPlaceChange&sampling_place_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="samplingPlaceList" class="table table-bordered table-hover datatable-export-paging " >
<thead>
<tr>
<th>{t}Id{/t}</th>
<th>{t}Nom{/t}</th>
<th>{t}Code métier{/t}</th>
<th>{t}Collection{/t}</th>
<th>{t}Longitude{/t}</th>
<th>{t}Latitude{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>{$data[lst].sampling_place_id}</td>
<td>
{if $droits.param == 1}
<a href="index.php?module=samplingPlaceChange&sampling_place_id={$data[lst].sampling_place_id}">
{$data[lst].sampling_place_name}
</a>
{else}
{$data[lst].sampling_place_name}
{/if}
</td>
<td>{$data[lst].sampling_place_code}</td>
<td>{$data[lst].collection_name}</td>
<td>{$data[lst].sampling_place_x}</td>
<td>{$data[lst].sampling_place_y}</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>

{if $droits["param"] == 1}
<div class="row col-md-6">
<fieldset>
<legend>{t}Importer des emplacements depuis un fichier CSV{/t}</legend>
<form class="form-horizontal protoform" id="metadataImport" method="post" action="index.php" enctype="multipart/form-data">

<input type="hidden" name="module" value="samplingPlaceImport">
<div class="form-group">
<label for="upfile" class="control-label col-md-4"><span class="red">*</span> {t}Nom du fichier à importer (CSV) :{/t}</label>
<div class="col-md-8">
<input type="file" name="upfile" required>
</div>
</div>
<div class="form-group">
<label for="separator" class="control-label col-md-4"><span class="red">*</span> {t}Séparateur :{/t}</label>
<div class="col-md-8">
<select id="separator" class="form-control" name="separator">
<option value=";">{t}Point-virgule{/t}</option>
<option value=",">{t}Virgule{/t}</option>
<option value="t">{t}Tabulation{/t}</option>
</select>
</div>
</div>

<div class="form-group">
<label for="collection_id" class="control-label col-md-4">{t}Collection éventuelle de rattachement :{/t}</label>
<div class="col-md-8">
<select id="collection_id" name="collection_id" class="form-control">
<option value="" {if $data["collection_id"] == ""} selected{/if}>{t}Choisissez...{/t}</option>
{foreach $collections as $collection}
<option value="{$collection.collection_id}" {if $collection.collection_id == $data.collection_id} selected {/if}>
{$collection.collection_name}
</option>
{/foreach}
</select>
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary">{t}Importer les localisations{/t}</button>
</div>
<div class="bg-info">
{t}Description du fichier :{/t}
<ul>
<li>{t}name : nom du lieu de prélèvement (obligatoire){/t}</li>
<li>{t}code : code métier du lieu de prélèvement{/t}</li>
<li>{t}x : longitude du point en projection WGS84, sous forme numérique (séparateur : point){/t}</li>
<li>{t}y : latitude du point{/t}</li>
</ul>
</div>
</form>
</fieldset>
</div>
{/if}
