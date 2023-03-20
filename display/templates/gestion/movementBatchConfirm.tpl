{* Mouvements > Entrée/sortie par lots > Valider > *}
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

<h2>{t}Entrer ou déplacer dans des contenants ou sortir du stock{/t}</h2>
<div class="row">
	<div class="col-sm-12">

		<form id="movementConfirm" class="form-horizontal" method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="movementBatch">
			<input type="hidden" name="action" value="Write">
			<div class="form-group">
				<label for="movement_reason_id" class="control-label col-sm-4">{t}Motif du déstockage :{/t}</label>
				<div class="col-sm-8">
					<select id="movement_reason_id" name="movement_reason_id">
					<option value="" {if empty($data.movement_reason_id)}selected{/if}>{t}Choisissez...{/t}</option>
					{section name=lst loop=$movementReason}
					<option value="{$movementReason[lst].movement_reason_id}" {if !empty($data.movement_reason_id) && $data.movement_reason_id == $movementReason[lst].movement_reason_id}selected{/if}>
					{$movementReason[lst].movement_reason_name}
					</option>	
					{/section}		
					</select>
				</div>
			</div>

			<div class="row">
				<div class="center">
					<button type="button" class="btn btn-warning" id="entree">{t}Tout entrer ou déplacer...{/t}</button>
					<button type="button" class="btn btn-warning" id="sortie">{t}Tout sortir du stock...{/t}</button>
				</div>
			</div>
			<div class="row">
				<div class="center">
					<button type="submit" class="btn btn-primary">{t}Valider{/t}</button>
				</div>
			</div>
			<div class="row col-sm-12">
			<table id="movementList"
				class="table table-bordered table-hover datatable-nopaging-nosort">
				<thead>
					<tr>
						<th>{t}UID{/t}</th>
						<th>{t}Identifiant{/t}</th>
						<th>{t}Type{/t}</th>
						<th>{t}Type détaillé{/t}</th>
						<th>{t}Est un contenant de destination{/t}
						</th>
						<th>{t}N° ligne{/t}</th>
						<th>{t}N° colonne{/t}</th>
						<th>{t}Entrer ou déplacer{/t}</th>
						<th>{t}Sortir du stock{/t}</th>
						<th>{t}Ne rien faire{/t}</th>
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
							name="container{$smarty.section.lst.index}:{$data[lst].uid}" value="1"
							{if $data[lst].object_type=="container"}checked{/if}></td>
						<td class="center">
						<input class="nombre" name="line{$data[lst].uid}" value="1" title="{t}Valeur obligatoire pour les mouvements d'entrée{/t}" placeholder="{t}obligatoire en entrée !{/t}">
						</td>
						<td class="center">
						<input class="nombre" name="column{$data[lst].uid}" value="1" title="{t}Valeur obligatoire pour les mouvements d'entrée{/t}" placeholder="{t}obligatoire en entrée !{/t}">
						</td>
						
						<td class="center"><input class="entree" type="radio"
							name="mvt{$smarty.section.lst.index}:{$data[lst].uid}" value="1"
							{if $data[lst].object_type=="sample"}checked{/if}></td>
						<td class="center"><input class="sortie" type="radio"
							name="mvt{$smarty.section.lst.index}:{$data[lst].uid}" value="2"></td>
						<td class="center"><input class="rien" type="radio"
							name="mvt{$smarty.section.lst.index}:{$data[lst].uid}" value="0"
							{if $data[lst].object_type=="container"}checked{/if}></td>
					</tr>
					{/section}
				</tbody>
			</table>
			</div>
			<div class="row">
				<div class="center">
					<button type="submit" class="btn btn-primary">{t}Valider{/t}</button>
				</div>
			</div>
		</form>
	</div>
</div>