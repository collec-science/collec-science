<script>
	$(document).ready(function() {
		$(".date").datepicker({
			dateFormat : "dd/mm/yy"
		});
		$(".num3").attr("pattern", "[0-9]+(\.[0-9]+)?");
	});
</script>
<h2>Modification EXEMPLE</h2>

<a href="index.php?module=exampleList">Retour à la liste</a>
{if $data.idExample > 0}
<a href="index.php?module=exampleDisplay&idExample={$data.idExample}">Retour
	au détail</a>
{/if}
<div class="formSaisie">
	<fieldset>
		<legend>Masque de saisie</legend>
		<div>

			<form method="post" action="index.php?module=exampleWrite">
				<input type="hidden" name="idExample" value="{$data.idExample}">
				<input type="hidden" name="idParent" value="{$data.idParent}">

				<dl>
					<dt>
						Date <span class="red">*</span> :
					</dt>
					<dd>
						<input class="date" id="dateExample" name="dateExample" required
							value="{$data.dateExample}">
					</dd>
				</dl>
				<dl>
					<dt>
						Commentaire <span class="red">*</span> :
					</dt>
					<dd>
						<input id="comment" name="comment" value="{$data.comment}"
							required maxlength="255" size="45">
					</dd>
				</dl>
				<div class="formBouton">
					<input class="submit" type="submit" value="Enregistrer">
				</div>
			</form>
			{if $data.idExample>0&&$droits["admin"] == 1}
			<div class="formBouton">
				<form action="index.php" method="post"
					onSubmit='return confirmSuppression("Confirmez-vous la suppression ?")'>
					<input type="hidden" name="idExample" value="{$data.idExample}">
					<input type="hidden" name="idParent" value="{$data.idParent}">
					<input type="hidden" name="module" value="exampleDelete"> <input
						class="submit" type="submit" value="Supprimer">
				</form>
			</div>
			{/if}
		</div>
	</fieldset>
</div>

<span class="red">*</span>
<span class="messagebas">Champ obligatoire</span>