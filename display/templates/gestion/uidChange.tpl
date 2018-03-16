<script>
$(document).ready(function() {
	function convertGPStoDD(valeur) {
		var parts = valeur.trim().split(/[^\d]+/);
		var dd = parseFloat(parts[0])
				+ parseFloat((parts[1] + "." + parts[2]) / 60);
		var lastChar = valeur.substr(-1).toUpperCase();
		dd = Math.round(dd * 1000000) / 1000000;
		if (lastChar == "S" || lastChar == "W" || lastChar == "O") {
			dd *= -1;
		}
		;
		return dd;
	}
	$("#latitude").change( function () {
		var value = $(this).val();
		if (value.length > 0) {
			$("#wgs84_y").val( convertGPStoDD(value));
		}
	});
	$("#longitude").change( function () {
		var value = $(this).val();
		if (value.length > 0) {
			$("#wgs84_x").val( convertGPStoDD(value));
		}
	});
});
</script>
<div class="form-group">
<label for="uid" class="control-label col-md-4">UID :</label>
<div class="col-md-8">
<input id="uid" name="uid" value="{$data.uid}" readonly class="form-control" title="identifiant unique dans la base de données">
</div>
</div>

<div class="form-group">
<label for="appli" class="control-label col-md-4">Identifiant ou nom :</label>
<div class="col-md-6">
<input id="identifier" type="text" name="identifier" class="form-control" value="{$data.identifier}" autofocus >
</div>
<div class="col-md-2">
<button class="btn btn-info" type="button" id="identifier_generate" disabled
title="Générez l'identifiant à partir des informations saisies (échantillon uniquement)">Générer</button>

</div>
</div>

<div class="form-group">
<label for="object_status_id" class="control-label col-md-4">Statut<span class="red">*</span> :</label>
<div class="col-md-8">
<select id="object_status_id" name="object_status_id" class="form-control">
{section name=lst loop=$objectStatus}
<option value="{$objectStatus[lst].object_status_id}" {if $objectStatus[lst].object_status_id == $data.object_status_id}selected{/if}>
{$objectStatus[lst].object_status_name}
</option>
{/section}
</select>
</div>
</div>
