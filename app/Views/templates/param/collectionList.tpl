<h2>{t}Collections{/t}</h2>
<div class="row">
	<div class="col-md-12">
		{if $rights.param == 1}
		<a href="collectionChange?collection_id=0">
			{t}Nouveau...{/t}
		</a>
		{/if}
		<table id="collectionList" class="table table-bordered table-hover datatable-searching display">
			<thead>
				<tr>
					<th colspan="14">{t}Informations générales{/t}</th>
					<th colspan="2" class="center">{t}Flux externes autorisés{/t}</th>
					<th colspan="4">{t}Notifications{/t}</th>
				</tr>
				<tr>
					<th>{t}Nom de la collection{/t}</th>
					<th>{t}Id{/t}</th>
					<th>{t}Nom public{/t}</th>
					<th>{t}Mots clés{/t}</th>
					<th>{t}Référent{/t}</th>
					<th>{t}Groupes de login autorisés{/t}</th>
					<th>{t}types d'échantillons rattachés{/t}</th>
					<th>{t}Types d'événements rattachés{/t}</th>
					<th>{t}Identifiants des échantillons uniques{/t}</th>
					<th>{t}Collection publique{/t}</th>
					<th>{t}Licence de diffusion{/t}</th>
					<th>{t}Collection sans gestion de la localisation des échantillons{/t}</th>
					<th>{t}Stockage des documents hors base de données ?{/t}</th>
					<th>{t}Chemin d'accès{/t}</th>
					<th>{t}Flux de mise à jour{/t}</th>
					<th>{t}Flux de consultation{/t}</th>
					<th>{t}Notifications activées ?{/t}</th>
					<th>{t}Mails de notification{/t}</th>
					<th>{t}Nbre de jours avant l'expiration des échantillons{/t}</th>
					<th>{t}Nbre de jours avant la date d'échéance des événements{/t}</th>

				</tr>
			</thead>
			<tbody>
				{section name=lst loop=$data}
				<tr>
					<td>
						{if $rights.param == 1}
						<a href="collectionChange?collection_id={$data[lst].collection_id}">
							{$data[lst].collection_name}
						</a>
						{else}
						{$data[lst].collection_name}
						{/if}
					</td>
					<td class="center">{$data[lst].collection_id}</td>
					<td>{$data[lst].collection_displayname}</td>
					<td>{$data[lst].collection_keywords}</td>
					<td>{$data[lst].referent_name}</td>
					<td>{$data[lst].groupe}</td>
					<td>{$data[lst].sampletypes}</td>
					<td>{$data[lst].eventtypes}</td>
					<td class="center">
						{if $data[lst].sample_name_unique == 't'}
						{t}oui{/t}
						{/if}
					</td>
					<td class="center">
						{if $data[lst].public_collection == 't'}
						{t}oui{/t}
						{/if}
					</td>
					<td>{$data[lst].license_name}</td>
					<td class="center">{if $data[lst].no_localization == 't'}{t}oui{/t}{/if}</td>
					<td class="center">{if $data[lst].external_storage_enabled == 't'}{t}oui{/t}{/if}</td>
					<td>{$data[lst].external_storage_root}</td>
					<td class="center">
						{if $data[lst].allowed_import_flow == 't'}
						{t}oui{/t}
						{/if}
					</td>
					<td class="center">
						{if $data[lst].allowed_export_flow == 't'}
						{t}oui{/t}
						{/if}
					</td>
					<td class="center">{if $data[lst].notification_enabled == 't'}{t}oui{/t}{/if}</td>
					<td>{$data[lst].notification_mails}</td>
					<td class="center">{$data[lst].expiration_delay}</td>
					<td class="center">{$data[lst].event_due_delay}</td>
				</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>