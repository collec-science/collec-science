<script>
$(document).ready(function() { 
	$('.image-popup-no-margins').magnificPopup( {
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
	});
	var documentChangeShow = 0;
	$('#documentChange').hide("") ;
	$('#documentChangeActivate').click(function () {
		if (documentChangeShow == 0) {
			$('#documentChange').show("");
			documentChangeShow = 1 ;
			 $("html, body").animate({ scrollTop: $(document).height() }, 1000);
		} else {
			$('#documentChange').hide("");
			documentChangeShow = 0 ;
		}
	});
} ) ;
</script>
{if $droits["gestion"] == 1 && $modifiable == 1 } 
<a href="#" id="documentChangeActivate">Saisir un nouveau document...</a>
<div id="documentChange" hidden="true">
{include file="gestion/documentChange.tpl"}
</div>
{/if}
<table id="documentList" class="table table-bordered table-hover datatable" data-order='[[5, "desc"], [4, "desc"]]'>
<thead>
<tr>
<th>Vignette</th>
<th>Nom du document</th>
<th>Description</th>
<th>Taille</th>
<th>Date<br>d'import</th>
<th>Date<br>de création</th>
{if $droits["gestion"] == 1}
<th>Supprimer</th>
{/if}
</tr>
</thead>
<tbody>
{section name=lst loop=$dataDoc}
<tr>
<td class="center">
{if in_array($dataDoc[lst].mime_type_id, array(4, 5, 6)) }
<a class="image-popup-no-margins" href="index.php?module=documentGet&document_id={$dataDoc[lst].document_id}&document_name={$dataDoc[lst].photo_preview}&attached=0&phototype=1" title="aperçu de la photo : {substr($dataDoc[lst].photo_name, strrpos($dataDoc[lst].photo_name, '/') + 1)}">
<img src="index.php?module=documentGet&document_id={$dataDoc[lst].document_id}&document_name={$dataDoc[lst].thumbnail_name}&attached=0&phototype=2" height="30">
</a>
{elseif  $dataDoc[lst].mime_type_id == 1}
<a class="image-popup-no-margins" href="index.php?module=documentGet&document_id={$dataDoc[lst].document_id}&&document_name={$dataDoc[lst].thumbnail_name}&attached=0&phototype=2" title="aperçu du document : {substr($dataDoc[lst].thumbnail_name, strrpos($dataDoc[lst].thumbnail_name, '/') + 1)}">
<img src="index.php?module=documentGet&document_id={$dataDoc[lst].document_id}&document_name={$dataDoc[lst].thumbnail_name}&attached=0&phototype=2" height="30">
</a>
{/if}
<td>
<a href="index.php?module=documentGet&document_id={$dataDoc[lst].document_id}&attached=1&phototype=0" title="document original">
{$dataDoc[lst].document_name}
</a>
</td>
<td>{$dataDoc[lst].document_description}</td>
<td>{$dataDoc[lst].size}</td>
<td>{$dataDoc[lst].document_import_date}</td>
<td>{$dataDoc[lst].document_creation_date}</td>
{if $droits["gestion"] == 1}
<td>
<div class="center">
<a href="index.php?module={$moduleParent}documentDelete&document_id={$dataDoc[lst].document_id}&uid={$data.uid}" onclick="return confirm('Confirmez-vous la suppression ?');">
<img src="/display/images/corbeille.png" height="20">
</a>
</div>
</td>
{/if}
</tr>
{/section}
</tbody>
</table>
