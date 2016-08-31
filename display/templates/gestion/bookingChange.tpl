<h2>Création - modification d'une réservation</h2>

<div class="row">
<div class="col-md-6">
<a href="index.php?module={$moduleParent}List">
<img src="display/images/list.png" height="25">
Retour à la liste
</a>
<a href="index.php?module={$moduleParent}Display&uid={$object.uid}">
<img src="display/images/edit.gif" height="25">
Retour au détail ({$object.uid} {$object.identifier})
</a>
<form class="form-horizontal protoform" id="{$moduleParent}Form" method="post" action="index.php">
<input type="hidden" name="booking_id" value="{$data.booking_id}">
<input type="hidden" name="moduleBase" value="{$moduleParent}booking">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="uid" value="{$object.uid}">


<div class="form-group">
<label for="date_from" class="control-label col-md-4">Du<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="date_from" name="date_from" required value="{$data.booking_date}" class="form-control datetimepicker" >
</div>
</div>

<div class="form-group">
<label for="date_to" class="control-label col-md-4">au<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="date_to" name="date_to" required value="{$data.booking_date}" class="form-control datetimepicker" >
</div>
</div>

<div class="form-group">
<label for="booking_date" class="control-label col-md-4">Date de la réservation :</label>
<div class="col-md-8">
<input id="booking_date" name="booking_date" readonly value="{$data.booking_date}" class="form-control" >
</div>
</div>

<div class="form-group">
<label for="booking_login" class="control-label col-md-4">Réservation effectuée par :</label>
<div class="col-md-8">
<input id="booking_date" name="booking_login" readonly value="{$data.booking_login}" class="form-control" >
</div>
</div>


<div class="form-group">
<label for="booking_comment" class="control-label col-md-4">Commentaire :</label>
<div class="col-md-8">
<textarea id="booking_comment" name="booking_comment"  class="form-control" rows="3">{$data.booking_comment}</textarea>
</div>
</div>

<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.booking_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>

<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>