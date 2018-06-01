{* Objets > échantillons > Rechercher > UID d'un échantillon > section Réservations > nouveau > *}
<script>
$(document).ready( function () {
	function verifyOverlaps() {
		var from = $("#date_from").val();
		var to = $("#date_to").val();
		var uid = parseInt($("#uid").val());
		var id = $("#booking_id").val();
		console.log("from : " + from);
		console.log("to : " + to);
		console.log("uid :" + uid );
		console.log("id : " + id);
		$("#overlaps").text("");
		if (from.length > 0 && to.length > 0 && uid > 0) {
			var url = "index.php";
			$.getJSON ( url, { 
				"module":"bookingVerifyInterval",
				"uid":uid,
				"booking_id":id,
				"date_from":from,
				"date_to":to
				} , function( data ) {
				if (data != null) {
					console.log("overlaps : "+data["overlaps"]);
					if (data["overlaps"] == 1) {
						$("#overlaps").text("{t}La période chevauche une réservation existante{/t}");
					}
				}
			});			
		}
	}
	$(".fromto").change( function () { 
		verifyOverlaps();
	});
	/*
	 * Declenchement au chargement de la page
	 */
	 {if $data.booking_id > 0}
	 verifyOverlaps();
	 {/if}
});
</script>

<h2>{t}Création - modification d'une réservation{/t}</h2>

<div class="row">
<div class="col-md-6">
<a href="index.php?module={$moduleListe}">
<img src="{$display}/images/list.png" height="25">
{t}Retour à la liste{/t}
</a>
<a href="index.php?module={$moduleParent}Display&uid={$object.uid}">
<img src="{$display}/images/edit.gif" height="25">
{t}Retour au détail{/t} ({$object.uid} {$object.identifier})
</a>
<div class="red" id="overlaps"></div>
<form class="form-horizontal protoform" id="{$moduleParent}Form" method="post" action="index.php">
<input type="hidden" id="booking_id" name="booking_id" value="{$data.booking_id}">
<input type="hidden" name="moduleBase" value="{$moduleParent}booking">
<input type="hidden" name="action" value="Write">
<input type="hidden" id="uid" name="uid" value="{$object.uid}">


<div class="form-group">
<label for="date_from" class="control-label col-md-4"><span class="red">*</span> {t}Du :{/t}</label>
<div class="col-md-8">
<input id="date_from" name="date_from" required value="{$data.date_from}" class="fromto form-control datetimepicker" >
</div>
</div>

<div class="form-group">
<label for="date_to" class="control-label col-md-4"><span class="red">*</span> {t}Au :{/t}</label>
<div class="col-md-8">
<input id="date_to" name="date_to" required value="{$data.date_to}" class="fromto form-control datetimepicker" >
</div>
</div>

<div class="form-group">
<label for="booking_date" class="control-label col-md-4">{t}Date de la réservation :{/t}</label>
<div class="col-md-8">
<input id="booking_date" name="booking_date" readonly value="{$data.booking_date}" class="form-control" >
</div>
</div>

<div class="form-group">
<label for="booking_login" class="control-label col-md-4">{t}Réservation effectuée par :{/t}</label>
<div class="col-md-8">
<input id="booking_date" name="booking_login" readonly value="{$data.booking_login}" class="form-control" >
</div>
</div>


<div class="form-group">
<label for="booking_comment" class="control-label col-md-4">{t}Commentaire :{/t}</label>
<div class="col-md-8">
<textarea id="booking_comment" name="booking_comment"  class="form-control" rows="3">{$data.booking_comment}</textarea>
</div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.booking_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
</form>
</div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>