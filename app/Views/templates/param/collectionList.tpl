<h2>{t}Collections{/t}</h2>
<div class="row">
	<div class="col-md-12">
		{if $rights.param == 1}
		<a href="collectionChange?collection_id=0">
			{t}Nouveau...{/t}
		</a>
		{/if}
		<table id="collectionList" class="table table-bordered table-hover datatable-searching display" data-order='[[{if $rights.param == 1}1{else}0{/if},"asc"]]'>
			<thead>
				<tr>
					{if $rights.param == 1}
					<th class="center">
						<img src="display/images/edit.gif" height="25">
					</th>
					{/if}
					<th>{t}Nom de la collection{/t}</th>
					<th>{t}Id{/t}</th>
					<th>{t}Nom public{/t}</th>
					<th>{t}Description{/t}</th>
					<th>{t}Référent{/t}</th>
					<th>{t}Types d'échantillons rattachés ?{/t}</th>
					<th>{t}Types d'événements rattachés ?{/t}</th>
					<th>{t}Identifiants des échantillons uniques ?{/t}</th>
					<th>{t}Collection publique ?{/t}</th>
					<th>{t}Collection sans gestion de la localisation des échantillons ?{/t}</th>
					<th>{t}API de mise à jour autorisée ?{/t}</th>
					<th>{t}Notifications activées ?{/t}</th>
				</tr>
			</thead>
			<tbody>
				{section name=lst loop=$data}
				<tr>
					{if $rights.param == 1}
					<td class="center">
						<a href="collectionChange?collection_id={$data[lst].collection_id}">
							<img src="display/images/edit.gif" height="25">
						</a>
					</td>
					{/if}
					<td>
						<a href="collectionDisplay?collection_id={$data[lst].collection_id}">
							{$data[lst].collection_name}
						</a>
					</td>
					<td class="center">{$data[lst].collection_id}</td>
					<td>{$data[lst].collection_displayname}</td>
					<td class="textareaDisplay">{$data[lst].collection_description}</td>
					<td>{$data[lst].referent_name}</td>
					<td class="center">{if strlen($data[lst].sampletypes) > 1}{t}oui{/t}{/if}</td>
					<td class="center">{if strlen($data[lst].eventtypes) > 1}{t}oui{/t}{/if}</td>
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
					<td class="center">{if $data[lst].no_localization == 't'}{t}oui{/t}{/if}</td>
					<td class="center">
						{if $data[lst].allowed_import_flow == 't'}
						{t}oui{/t}
						{/if}
					</td>
					<td class="center">{if $data[lst].notification_enabled == 't'}{t}oui{/t}{/if}</td>
				</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>