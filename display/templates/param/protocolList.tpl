<h2>Protocoles</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<a href="index.php?module=protocolChange&protocol_id=0">
{$LANG["appli"][0]}
</a>
{/if}
<table id="protocolList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>Nom du protocole</th>
<th>Version</th>
<th>Année</th>
<th>Projet de<br>rattachement</th>
<th>Fichier joint</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.projet == 1}
<a href="index.php?module=protocolChange&protocol_id={$data[lst].protocol_id}">
{$data[lst].protocol_name}
</a>
{else}
{$data[lst].protocol_name}
{/if}
</td>
<td class="center">{$data[lst].protocol_version}</td>
<td class="center">{$data[lst].protocol_year}</td>
<td class="center">{$data[lst].project_name}</td>
<td class="center">
{if $data[lst].has_file == 1}
<a href="index.php?module=protocolFile&protocol_id={$data[lst].protocol_id}">
<img src="/display/images/pdf.png" height="25">
</a>
{/if}
</td>
</tr>
{/section}
</tbody>
</table>
</div>
</div>