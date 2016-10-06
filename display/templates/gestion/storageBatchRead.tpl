<div class="row">
	<div class="col-md-12">
		<form class="form-horizontal protoform" id="fastOutputForm"
			method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="storageBatch"> 
			<input	type="hidden" name="action" value="Read"> 
			<div class="form-group">
<label for="reads"  class="control-label col-md-4">Données scannées<span class="red">*</span> :</label>
<div class="col-md-8">
<textarea id="reads" name="reads" class="form-control" rows="20" required autofocus 
placeholder="Positionnez le curseur dans cette zone avant de décharger la douchette"></textarea>
</div>
</div>
			
			<div class="form-group center">
				<button type="submit" class="btn btn-primary">{$LANG["message"].19}</button>
			</div>

		</form>
		<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>
	</div>
</div>