<!-- Ajout rapide d'un échantillon dans un container -->
<script>
$(document).ready(function() { 
	function getDetail(uid) {
		/*
		 * Retourne le detail d'un objet, par interrogation ajax
		 */
		var url = "index.php";
		var chaine ;
		$.getJSON ( url, { "module":"objectGetDetail", "uid":uid } , function( data ) {
			if (data != null) {
				chaine = data[0].identifier + " : " + data[0].type_name;
				return chaine;
			}
		}
	}
});
</script>

<div class="row">
<div class="col-md-6">
<form class="form-horizontal protoform" id="fastInputForm" method="post" action="index.php">
<input type="hidden" name="moduleBase" value="fastInput">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="storage_id" value="0">

<div class="form-group">
<label for="container_groupe" class="control-label col-md-4">UID du conteneur<span class="red">*</span> :</label>
<div class="col-md-8" id="container_groupe">
<div class="row">
<input id="container_uid" type="text" name="container_uid"  value="{$container_uid}" class=" col-md-2 form-control" >
<button type="button" id="container_search" class="btn btn-default col-md-2">Chercher...</button>
<input id="container_detail" type="text" class="col-md-8 form-control" disabled>
</div>

</div>
</div>

<div class="form-group">
<label for="object_uid" class="control-label col-md-4">UID de l'objet<span class="red">*</span> :</label>
<div class="col-md-8" id="object_groupe">
<div class="row">
<input id="object_uid" type="text" name="object_uid"  value="" class=" col-md-2 form-control" >
<button type="button" id="object_search" class="btn btn-default col-md-2">Chercher...</button>
<input id="object_detail" type="text" class="col-md-8 form-control" disabled>
</div>
</div>
</div>

<div class="form-group">
<label for="storage_date" class="control-label col-md-4">Date/heure<span class="red">*</span> :</label>
<input id="storage_date" name="storage_date" required value="{$data.storage_date}" class="col-md-8 form-control datetimepicker" >
</div>

<div class="form-group">
<label for="storage_comment" class="control-label col-md-4">Commentaire :</label>
<textarea class="form-control col-md-8" rows="3"></textarea>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
 </div>

</form>
</div> 
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>