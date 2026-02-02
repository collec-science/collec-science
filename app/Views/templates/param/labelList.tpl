<h2>{t}Modèles d'étiquette{/t}</h2>
<div class="row">
	<div class="col-md-6">
		{if $rights.collection == 1}
		<a href="labelChange?label_id=0">
			{t}Nouveau...{/t}
		</a>
		{/if}
		{$help}
		<table id="labelList" class="table table-bordered table-hover datatable display">
			<thead>
				<tr>
					<th>{t}Nom de l'étiquette{/t}</th>
					<th>{t}Id{/t}</th>
					<th>{t}Type du ou des codes optiques{/t}</th>
					<th>{t}Logo{/t}</th>
					<th>{t}Nom du modèle de métadonnées rattaché{/t}</th>
					{if $rights.collection == 1}
					<th>{t}Modifier{/t}</th>
					<th>{t}Dupliquer{/t}</th>
					{/if}
				</tr>
			</thead>
			<tbody>
				{section name=lst loop=$data}
				<tr>
					<td>
						{if $rights.collection == 1}
						<a href="labelChange?label_id={$data[lst].label_id}">
							{$data[lst].label_name}
						</a>
						{else}
						{$data[lst].label_name}
						{/if}
					</td>
					<td class="center">{$data[lst].label_id}</td>
					<td>{$data[lst].type_optical}</td>
					<td class="center">
						{if $data[lst].has_logo == 1}
						<img src="labelGetLogo?label_id={$data[lst].label_id}" height="30">
						{/if}
					</td>
					<td>{$data[lst].metadata_name}</td>
					{if $rights.collection == 1}
					<td class="center">
						<a href="labelChange?label_id={$data[lst].label_id}" title="{t}Modifier l'étiquette{/t}">
							<img src="display/images/edit.gif" height="25">
						</a>
					</td>
					<td class="center">
						<a href="labelCopy?label_id={$data[lst].label_id}" title="{t}Dupliquer l'étiquette{/t}">
							<img src="display/images/copy.png" height="25">
						</a>
						{/if}
				</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>