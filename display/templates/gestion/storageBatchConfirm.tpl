<script>
	$(document).ready(function() {
		$("#entree").on("click keypress", function() {
			$(".entree").prop("checked", true);
		});
		$("#sortie").on("click keypress", function() {
			$(".sortie").prop("checked", true);
		});
	});
</script>

<h2>Valider les lectures de la douchette</h2>
<div class="row">
	<div class="col-sm-12">

		<form id="storageConfirm" class="form-horizontal" method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="storageBatch">
			<input type="hidden" name="action" value="Write">
			<div class="form-group">
				<label for="storage_reason_id" class="control-label col-sm-4">Motif du déstockage :</label>
				<div class="col-sm-8">
					<select id="storage_reason_id" name="storage_reason_id">
					<option value="" {if $data.storage_reason_id == ""}selected{/if}>Sélectionnez...</option>
					{section name=lst loop=$storageReason}
					<option value="{$storageReason[lst].storage_reason_id}" {if $data.storage_reason_id == $storageReason[lst].storage_reason_id}selected{/if}>
					{$storageReason[lst].storage_reason_name}
					</option>	
					{/section}		
					</select>
				</div>
			</div>

			<div class="row">
				<div class="center">
					<button type="button" class="btn btn-warning" id="entree">Entrée
						des échantillons</button>
					<button type="button" class="btn btn-warning" id="sortie">Sortie
						des échantillons</button>
				</div>
			</div>
			<div class="row">
				<div class="center">
					<button type="submit" class="btn btn-primary">{$LANG["message"].19}</button>
				</div>
			</div>
			<div class="row col-sm-12">
			<table id="storageList"
				class="table table-bordered table-hover datatable-nopaging-nosort">
				<thead>
					<tr>
						<th>UID</th>
						<th>Identifiant</th>
						<th>Type</th>
						<th>Type détaillé</th>
						<th>Conteneur<br>(pour entrée)
						</th>
						<th>N° ligne<br>(entrée)</th>
						<th>N° colonne<br>(entrée)</th>
						<th>Entrée</th>
						<th>Sortie</th>
						<th>Ne rien faire</th>
					</tr>
				</thead>
				<tbody>
					{section name=lst loop=$data}
					<tr>
						<td class="center"><input type="hidden" name="uid[]"
							value="{$data[lst].uid}"> {$data[lst].uid}</td>
						<td>{$data[lst].identifier}</td>
						<td>{$data[lst].object_type}</td>
						<td>{$data[lst].type_name}</td>
						<td class="center"><input type="checkbox"
							name="container{$data[lst].uid}" value="1"
							{if $data[lst].object_type=="container"}checked{/if}></td>
						<td class="center">
						<input class="nombre" name="line{$data[lst].uid}" value="1" title="Valeur obligatoire pour les mouvements d'entrée" placeholder="obligatoire en entrée !">
						</td>
						<td class="center">
						<input class="nombre" name="column{$data[lst].uid}" value="1" title="Valeur obligatoire pour les mouvements d'entrée" placeholder="obligatoire en entrée !">
						</td>
						
						<td class="center"><input class="entree" type="radio"
							name="mvt{$data[lst].uid}" value="1"
							{if $data[lst].object_type=="sample"}checked{/if}></td>
						<td class="center"><input class="sortie" type="radio"
							name="mvt{$data[lst].uid}" value="2"></td>
						<td class="center"><input class="rien" type="radio"
							name="mvt{$data[lst].uid}" value="0"
							{if $data[lst].object_type=="container"}checked{/if}></td>
					</tr>
					{/section}
				</tbody>
			</table>
			</div>
			<div class="row">
				<div class="center">
					<button type="submit" class="btn btn-primary">{$LANG["message"].19}</button>
				</div>
			</div>
		</form>
	</div>
</div>