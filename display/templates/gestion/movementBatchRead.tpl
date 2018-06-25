{* Mouvements > Entrée/sortie par lots > *}
<script>

$(document).ready(function() { 
	$("#movementBatchForm").submit(function(event) { 
		var valeur = $("#reads").val();
		/*
		 * Traitement des caracteres parasites de ean128
		 */
		 valeur = valeur.replace ( /]C1/g, "");
		
		valeur = valeur.replace ( /\[/g,  String.fromCharCode(123));
		valeur = valeur.replace ( /\]/g, String.fromCharCode(125));
		console.log(valeur);
		$("#reads").val(valeur);
		//event.preventDefault();
	});

});
</script>
<h2>{t}Entrer ou déplacer / Sortir par lots{/t}</h2>
<div class="row">
	<div class="col-md-12">



		<form class="form-horizontal protoform" id="movementBatchForm"
			method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="movementBatch"> 
			<input	type="hidden" name="action" value="Read"> 
			<div class="bg-info">
{t}Pour entrer ou déplacer des objets dans un contenant, commencez toujours par scanner/saisir le contenant puis les objets.{/t}
</div>
			<div class="form-group">
<label for="reads"  class="control-label col-md-4"><span class="red">*</span> {t}Données à traiter :{/t}</label>
<div class="col-md-8">
<textarea id="reads" name="reads" class="form-control" rows="20" required autofocus 
placeholder="{t}Placer le curseur dans cette zone avant de scanner un QR Code ou de décharger la scannette{/t}"></textarea>
</div>
</div>
			
			<div class="form-group center">
				<button type="submit" class="btn btn-primary">{t}Suivant{/t}</button>
			</div>

		</form>
		<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
	</div>
</div>
