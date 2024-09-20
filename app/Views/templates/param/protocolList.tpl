<h2>{t}Protocoles{/t}</h2>
<div class="row">
	<div class="col-md-6">
		{if $rights.param == 1}
		<a href="protocolChange?protocol_id=0">
			{t}Nouveau...{/t}
		</a>
		{/if}
		<table id="protocolList" class="table table-bordered table-hover datatable ">
			<thead>
				<tr>
					<th>{t}Nom du protocole{/t}</th>
					<th>{t}Version{/t}</th>
					<th>{t}Année{/t}</th>
					<th>{t}Collection de rattachement{/t}</th>
					<th>{t}N° de l'autorisation de prélèvement{/t}</th>
					<th>{t}Date de l'autorisation de prélèvement{/t}</th>
					<th>{t}Fichier joint{/t}</th>
				</tr>
			</thead>
			<tbody>
				{section name=lst loop=$data}
				<tr>
					<td>
						{if $rights.collection == 1}
						<a href="protocolChange?protocol_id={$data[lst].protocol_id}">
							{$data[lst].protocol_name}
						</a>
						{else}
						{$data[lst].protocol_name}
						{/if}
					</td>
					<td class="center">{$data[lst].protocol_version}</td>
					<td class="center">{$data[lst].protocol_year}</td>
					<td class="center">{$data[lst].collection_name}</td>
					<td class="center">{$data[lst].authorization_number}</td>
					<td class="center">{$data[lst].authorization_date}</td>
					<td class="center">
						{if $data[lst].has_file == 1}
						<a href="protocolFile?protocol_id={$data[lst].protocol_id}">
							<img src="display/images/pdf.png" height="25">
						</a>
						{/if}
					</td>
				</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>