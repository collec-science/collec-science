{* Paramètres > Types d'échantillons > *}
<h2>{t}Types d'échantillons{/t}</h2>
	<div class="row">
	<div class="col-md-12">
{if $rights.param == 1}
<a href="sampleTypeChange?sample_type_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="sampleTypeList" class="table table-bordered table-hover datatable-export-paging display" >
<thead>
<tr>
<th>{t}Nom{/t}</th>
<th>{t}Id{/t}</th>
<th>{t}Code utilisé pour les échanges{/t}</th>
<th>{t}Type de contenant{/t}</th>
<th>{t}Protocole / operation{/t}</th>
<th>{t}Sous-échantillonnage{/t}</th>
<th>{t}Modèle de métadonnées{/t}</th>
<th>{t}Description{/t}</th>
<th>{t}Génération automatique de l'identifiant métier ?{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $rights.param == 1}
<a href="sampleTypeChange?sample_type_id={$data[lst].sample_type_id}">
{$data[lst].sample_type_name}
</a>
{else}
{$data[lst].sample_type_name}
{/if}
</td>
<td class="center">{$data[lst].sample_type_id}</td>
<td>{$data[lst].sample_type_code}</td>
<td>{$data[lst].container_type_name}</td>
<td>
{$data[lst].protocol_year} {$data[lst].protocol_name} {$data[lst].protocol_version} {$data[lst].operation_name} {$data[lst].operation_version}
</td>
<td>
{if $data[lst].multiple_type_id > 0}
{$data[lst].multiple_type_name} : {$data[lst].multiple_unit}
{/if}
</td>
<td>{$data[lst].metadata_name}</td>
<td class="textareaDisplay">{$data[lst].sample_type_description}</td>
<td class="center">
{if strlen($data[lst].identifier_generator_js) > 0}
{t}oui{/t}
{/if}
</tr>
{/section}
</tbody>
</table>
</div>
</div>