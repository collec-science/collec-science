<script>
	$( document ).ready( function () {
		$( '.image-popup-no-margins' ).magnificPopup( {
			type: 'image',
			closeOnContentClick: true,
			closeBtnInside: false,
			fixedContentPos: true,
			mainClass: 'mfp-no-margins mfp-with-zoom', // class to remove default margin from left and right side
			image: {
				verticalFit: false
			},
			zoom: {
				enabled: true,
				duration: 300 // don't foget to change the duration also in CSS
			}
		} );
		var documentChangeShow = 0;
		$( '#documentChange' ).hide( "" );
		$( '#documentChangeActivate' ).click( function () {
			if ( documentChangeShow == 0 ) {
				$( '#documentChange' ).show( "" );
				documentChangeShow = 1;
				//$("html, body").animate({ scrollTop: $(document).height() }, 1000);
			} else {
				$( '#documentChange' ).hide( "" );
				documentChangeShow = 0;
			}
		} );
	} );
</script>
{if $rights["manage"] == 1 && $modifiable == 1 }
<a href="#" id="documentChangeActivate">{t}Saisir un nouveau document...{/t}</a>
<div id="documentChange" hidden="true">
	{include file="gestion/documentChange.tpl"}
	{if $externalStorageEnabled == "t"}
		{include file="gestion/documentExternalAdd.tpl"}
	{/if}
</div>
{/if}
<table id="documentList" class="table table-bordered table-hover datatable display" data-order='[[5, "desc"], [4, "desc"]]'>
	<thead>
		<tr>
			<th>{t}Vignette{/t}</th>
			<th>{t}Nom du document{/t}</th>
			<th>{t}Description{/t}</th>
			<th>{t}Taille{/t}</th>
			<th>{t}Date d'import{/t}</th>
			<th>{t}Date de création{/t}</th>
			<th>{t}Événement concerné{/t}</th>
			<th>{t}UUID{/t}</th>
			{if $rights["manage"] == 1 && $modifiable == 1 }
			<th>{t}Supprimer{/t}</th>
			{/if}
		</tr>
	</thead>
	<tbody>
		{section name=lst loop=$dataDoc}
		<tr>
			<td class="center">
				{if in_array($dataDoc[lst].mime_type_id, array(4, 5, 6)) && $dataDoc[lst].external_storage != 't'}
				<a class="image-popup-no-margins"
					href="documentGet?document_id={$dataDoc[lst].document_id}&document_name={$dataDoc[lst].photo_preview}&attached=0&phototype=1"
					title="{t}aperçu de la photo :{/t} {substr($dataDoc[lst].photo_name, strrpos($dataDoc[lst].photo_name, '/') + 1)}">
					<img src="documentGet?document_id={$dataDoc[lst].document_id}&document_name={$dataDoc[lst].thumbnail_name}&attached=0&phototype=2"
						height="30">
				</a>
				{elseif $dataDoc[lst].mime_type_id == 1 && $dataDoc[lst].external_storage != 't'}
				<a class="image-popup-no-margins"
					href="documentGet?document_id={$dataDoc[lst].document_id}&&document_name={$dataDoc[lst].thumbnail_name}&attached=0&phototype=2"
					title="{t}aperçu du document :{/t} {substr($dataDoc[lst].thumbnail_name, strrpos($dataDoc[lst].thumbnail_name, '/') + 1)}">
					<img src="documentGet?document_id={$dataDoc[lst].document_id}&document_name={$dataDoc[lst].thumbnail_name}&attached=0&phototype=2"
						height="30">
				</a>
				{/if}
			<td>
				{if $dataDoc[lst].external_storage == 't'}
				<a href="documentGetExternal?document_id={$dataDoc[lst].document_id}"
					title="{t}Téléchargez le fichier{/t}">

					{else}
					<a href="documentGet?document_id={$dataDoc[lst].document_id}&attached=1&phototype=0"
						title="{t}document original{/t}">
						{/if}
						{if $dataDoc[lst].external_storage == 1}
						{$dataDoc[lst].external_storage_path}
						{else}
						{$dataDoc[lst].document_name}
						{/if}
					</a>
					{if $dataDoc[lst].external_storage == 1}
					&nbsp;{t}(stockage externe){/t}
					{/if}
			</td>
			<td>{$dataDoc[lst].document_description}</td>
			<td>{$dataDoc[lst].size}</td>
			<td class="nowrap">{$dataDoc[lst].document_import_date}</td>
			<td>{$dataDoc[lst].document_creation_date}</td>
			<td>
				{if $dataDoc[lst].event_id > 0}
				{$dataDoc[lst].event_type_name} {if !empty($dataDoc[lst].event_date)}{t}réalisé le{/t} {$dataDoc[lst].event_date}{else}{t}prévu le{/t}{$dataDoc[lst].due_date}{/if}
				{/if}
			</td>
			<td class="nowrap">{$dataDoc[lst].uuid}</td>
			{if $rights["manage"] == 1 && $modifiable == 1}
			<td>
				<div class="center">
					<a href="{$moduleParent}documentDelete?document_id={$dataDoc[lst].document_id}&uid={$data.uid}&campaign_id={$data.campaign_id}&event_id={$data.event_id}&collection_id={$data.collection_id}&activeTab=tab-document"
						onclick="return confirm('{t}Confirmez-vous la suppression ?{/t}');">
						<img src="display/images/corbeille.png" height="20">
					</a>
				</div>
			</td>
			{/if}
		</tr>
		{/section}
	</tbody>
</table>