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
<div class="col-md-8">
<input id="identifier" type="text" name="identifier" class="form-control" value="{$data.identifier}" autofocus >
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

<div class="form-group">
<label for="wy" class="control-label col-md-4">Latitude :</label>
<div class="col-md-8" id="wy">
<input id="latitude" placeholder="45°01,234N" autocomplete="off" class="form-control">
<input id="wgs84_y" name="wgs84_y" placeholder="45.01300" autocomplete="off" class="form-control taux" value="{$data.wgs84_y}">
</div>
</div>

<div class="form-group">
<label for="wx" class="control-label col-md-4">Longitude :</label>
<div class="col-md-8" id="wx">
<input id="longitude" placeholder="0°01,234W" autocomplete="off" class="form-control">
<input id="wgs84_x" name="wgs84_x" placeholder="-0.0156" autocomplete="off" class="form-control taux" value="{$data.wgs84_x}">
</div>
</div>