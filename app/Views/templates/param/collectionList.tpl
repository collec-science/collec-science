<div class="container-fluid">
	<h2>{t}Collections{/t}</h2>
	<div class="row">
		<div class="col-12">
			{if $rights.param == 1}
			<a href="collectionChange?collection_id=0">
				<img src="display/images/new.png" height="25">
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
	<div class="row">
        <fieldset>
            <legend>{t}Importer une liste de collections à partir d'un fichier CSV{/t}</legend>
            <form class="form-horizontal" id="collectionImport" method="post" action="collectionImport" enctype="multipart/form-data">
                <div class="row">
                    <label for="upfile" class="form-label col-4"><span class="red">*</span>
                        {t}Nom du fichier à importer :{/t}
                    </label>
                    <div class="col-8">
                        <input type="file" name="upfile" class="form-control" required>
                    </div>
                </div>
                <div class="row">
                    <label for="separator" class="form-label col-4">{t}Séparateur utilisé :{/t}</label>
                    <div class="col-8">
                        <select id="separator" name="separator" class="form-select">
                            <option value=",">{t}Virgule{/t}</option>
                            <option value=";">{t}Point-virgule{/t}</option>
                            <option value="tab">{t}Tabulation{/t}</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <label for="encoding" class="form-label col-4">{t}Encodage du fichier :{/t}</label>
                    <div class="col-8">
                        <select id="encoding" name="utf8_encode" class="form-select">
                            <option value="0">UTF-8</option>
                            <option value="1">ISO-8859-x</option>
                        </select>
                    </div>
                </div>
                <div class="row d-flex justify-content-center">
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary">{t}Importer les nouvelles collections{/t}</button>
                    </div>
                </div>

                <div class="bg-info">
                    {t}Description du fichier :{/t}
                    <ul>
                        <li>{t}collection_name : nom de la collection (obligatoire){/t}</li>
                        <li>{t}referent_name : nom du responsable de la collection. S'il n'existe pas dans la liste des référents, il sera créé{/t}</li>
                        <li>{t}referent_firstname : prénom du responsable de la collection{/t}</li>
                        <li>{t}collection_description : description textuelle de la collection{/t}</li>
						<li>{t}collection_keywords : liste des mots clés, séparés par une virgule{/t}</li>
						<li>{t}collection_displayname : nom affiché pour les collections publiques{/t}</li>
						<li>{t}sample_name_unique : si à 1, le nom des échantillons doit être unique dans la collection{/t}</li>
						<li>{t}no_localization : si à 1, les échantillons de la collections n'ont pas de coordonnées géographiques{/t}</li>
						<li>{t}notification_enabled : si à 1, l'application enverra des notifications avant que les échantillons ou les événements programmés soient échus{/t}</li>
						<li>{t}notification_mails : liste des emails des destinataires, séparés par une virgule{/t}</li>
						<li>{t}expiration_delay : nombre de jours pris en compte dans l'envoi des emails avant l'échéance des échantillons{/t}</li>
						<li>{t}event_due_delay : nombre de jours pris en compte dans l'envoi des emails avant la date d'échéance des événements{/t}</li>
						<li>{t}allowed_import_flow : si à 1, les API de mise à jour de la collection sont autorisés{/t}</li>
						<li>{t}allowed_export_flow : si à 1, les API d'interrogation de la collection sont autorisés{/t}</li>
						<li>{t}public_collection : si à 1, la collection est publique et peut être interrogée par API sans identification{/t}</li>
						<li>{t}sample_types : liste des types d'échantillons attachés à la collection, séparés par une virgule{/t}</li>
						<li>{t}groupes : liste des groupes autorisés à modifier les échantillons de la collection, séparés par une virgule{/t}</li>
						<li>{t}event_types : liste des types d'événements rattachés à la collection, séparés par une virgule{/t}</li>
						
                    </ul>
                </div>
                {$csrf}
            </form>
        </fieldset>
    </div>
</div>