<!-- Sortie rapide d'un échantillon du stock -->
<script>
$(document).ready(function() { 
	function getDetail(uid, champ) {
		/*
		 * Retourne le detail d'un objet, par interrogation ajax
		 */
		var url = "index.php";
		var chaine ;
		var is_container = 0;
		if (champ == "container") {
			is_container = 1;
		}
		console.log("uid : "+uid);
		$.getJSON ( url, { "module":"objectGetDetail", "uid":uid, "is_container":is_container } , function( data ) {
			if (data != null) {
				if (data.length > 0) {
					chaine = data[0].identifier + " (" + data[0].type_name +")";
					console.log("Retour objectGetDetail : " + chaine);
					$("#"+champ+"_detail").val(chaine);
				} else {
					$("#"+champ+"_uid").val("");
					$("#"+champ+"_detail").val("");
				}
			}
		});
	}
	
	$("#object_uid").focusout(function () {
		getDetail($("#object_uid").val(), "object");
	});
	$("#object_search").click(function () {
		getDetail($("#object_uid").val(), "object");
	});
});
</script>
<h2>{$LANG["menu"].75}</h2>

<div class="row">
<div class="col-md-6">
<form class="form-horizontal protoform" id="fastOutputForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="fastOutput">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="storage_id" value="0">

<div class="form-group">
<label for="object_uid" class="control-label col-md-4">UID de l'objet<span class="red">*</span> :</label>
<div class="col-md-8" id="object_groupe">
<div class="col-md-3">
<input id="object_uid" type="text" name="object_uid"  value="" class="form-control" autofocus autocomplete="off" >
</div>
<div class="col-md-3 col-md-offset-1">
<button type="button" id="object_search" class="btn btn-default">Chercher...</button>
</div>
</div>
<div class="col-md-8 col-md-offset-4 ">
<input id="object_detail" type="text" class="form-control" disabled>
</div>
</div>

<div class="form-group">
<label for="storage_date" class="control-label col-md-4">Date/heure<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="storage_date" name="storage_date" required value="{$data.storage_date}" class="form-control datetimepicker" >
</div>
</div>

<div class="form-group">
<label for="storage_comment" class="control-label col-md-4">Commentaire :</label>
<div class="col-md-8">
<textarea class="form-control" id="storage_comment" name="storage_comment" rows="3"></textarea>
</div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
 </div>

</form>
</div> 
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>
