{* Mouvements > Entrée/sortie par lots > *}
<script>

	$(document).ready(function () {
		$("#movementBatchForm").submit(function (event) {
			var valeur = $("#reads").val();
			/*
			 * Traitement des caracteres parasites de ean128
			 */
			valeur = valeur.replace(/]C1/g, "");

			valeur = valeur.replace(/\[/g, String.fromCharCode(123));
			valeur = valeur.replace(/\]/g, String.fromCharCode(125));
			$("#reads").val(valeur);
			//event.preventDefault();
		});

	});
</script>
<div class="container">
	<h2>{t}Entrer ou déplacer / Sortir par lots{/t}</h2>

	<form class="form-horizontal " id="movementBatchForm" method="post" action="movementBatchRead">
		<input type="hidden" name="moduleBase" value="movementBatch">
		<div class="bg-info">
			{t}Pour entrer ou déplacer des objets dans un contenant, commencez toujours par scanner/saisir le contenant puis les objets.{/t}
		</div>
		<div class="row">
			<label for="reads" class="form-label col-4"><span class="red">*</span> {t}Données à traiter :{/t}</label>
			<div class="col-8">
				<textarea id="reads" name="reads" class="form-control" rows="20" required autofocus placeholder="{t}Placer le curseur dans cette zone avant de scanner un QR Code ou de décharger la scannette{/t}"></textarea>
			</div>
		</div>

		<div class="row d-flex justify-content-center">
			<div class="col-auto">
				<button type="submit" class="btn btn-primary">{t}Suivant{/t}</button>
			</div>
		</div>

		{$csrf}
	</form>
	<div class="row col-12 d-inline">
		<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
	</div>
</div>