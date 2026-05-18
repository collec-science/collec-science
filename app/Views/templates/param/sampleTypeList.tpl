<div class="container-fluid">
	<h2>{t}Types d'échantillons{/t}</h2>
	<div class="row">
		{if $rights.param == 1}
		<div class="col-auto">
			<a href="sampleTypeChange?sample_type_id=0">
				<img src="display/images/new.png" height="25">
				{t}Nouveau...{/t}
			</a>
		</div>
		{/if}
		<div class="col-auto">
			{$help}
		</div>
	</div>
</div>
<div class="row">
	<table id="sampleTypeList" class="table table-bordered table-hover datatable-export-paging display">
		<thead>
			<tr>
				<th>{t}Nom{/t}</th>
				<th>{t}Id{/t}</th>
				<th>{t}Code utilisé pour les échanges{/t}</th>
				<th>{t}Type de contenant{/t}</th>
				<th>{t}Produit utilisé{/t}</th>
				<th>{t}Risque{/t}</th>
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
				<td>{$data[lst].product_name}</td>
				<td>{$data[lst].risk_name}</td>
				<td>
					{if $data[lst].multiple_type_id > 0}
					{$data[lst].multiple_type_name} : {$data[lst].multiple_unit}
					{/if}
				</td>
				<td><a href="metadataDisplay?metadata_id={$data[lst].metadata_id}">{$data[lst].metadata_name}</a>
				</td>
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
</div>