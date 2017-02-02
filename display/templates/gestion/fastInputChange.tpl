<!-- Ajout rapide d'un échantillon dans un container -->
{include file="gestion/qrcode_read.tpl"}

<h2>Entrée rapide d'un échantillon dans le stock</h2>
<div class="row">
	<div class="col-md-6">
		<form class="form-horizontal protoform fastform" id="fastInputForm"
			method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="fastInput"> <input
				type="hidden" name="action" value="Write"> <input
				type="hidden" name="storage_id" value="0"> <input
				type="hidden" id="read_optical" name="read_optical"
				value="{$read_optical}">


			<div class="form-group">
				<label for="container_uid" class="control-label col-sm-4">
				<img id="arrow-container" src="display/images/right-arrow.png" height="25">
				UID	du conteneur<span class="red">*</span> :
				</label>
				<div class="col-sm-8" id="container_groupe">
					<div class="col-sm-3">
						<input id="container_uid" type="text" name="container_uid"
							required value="{$container_uid}" class="form-control"
							autocomplete="off" >
					</div>
					<div class="col-sm-3 col-sm-offset-1">
						<button type="button" id="container_search"
							class="btn btn-default">Chercher...</button>
					</div>
				</div>
				<div class="col-sm-8 col-sm-offset-4 ">
					<input id="container_detail" type="text" class="form-control"
						disabled>
				</div>
			</div>

			<div class="form-group">
				<label for="object_uid" class="control-label col-sm-4">
				<img id="arrow-object" src="display/images/right-arrow.png" height="25">
				UID de l'objet<span class="red">*</span> :
				</label>
				<div class="col-sm-8" id="object_groupe">
					<div class="col-sm-3">
						<input id="object_uid" type="text" name="object_uid" required
							value="" class="form-control" autofocus autocomplete="off" >
					</div>
					<div class="col-sm-3 col-sm-offset-1">
						<button type="button" id="object_search" class="btn btn-default">Chercher...</button>
					</div>
				</div>
				<div class="col-sm-8 col-sm-offset-4 ">
					<input id="object_detail" type="text" class="form-control" disabled>
				</div>
			</div>

			<div class="form-group">
				<label for="storage_range" class="control-label col-sm-4">Emplacement
					dans le container :</label>
				<div class="col-sm-8">
					<input id="storage_range" name="storage_range"
						value="{$data.storage_range}" class="form-control">
				</div>
			</div>

			<div class="form-group">
				<label for="storage_date" class="control-label col-sm-4">Date/heure<span
					class="red">*</span> :
				</label>
				<div class="col-sm-8">
					<input id="storage_date" name="storage_date" required
						value="{$data.storage_date}" class="form-control datetimepicker">
				</div>
			</div>

			<div class="form-group">
				<label for="storage_comment" class="control-label col-sm-4">Commentaire
					:</label>
				<div class="col-sm-8">
					<textarea class="form-control" id="storage_comment"
						name="storage_comment" rows="3"></textarea>
				</div>
			</div>

			<div class="form-group center">
				<button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
			</div>

		</form>
		<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>
	</div>
</div>
<!-- Lecture par douchette -->
<div class="row">
	<fieldset>
		<legend>Lecture optique par douchette</legend>

		<div class="col-md-6">
			<div class="form-horizontal protoform">
				<div class="form-group center">
					<button id="destObject" class="btn btn-success">Lecture de
						l'objet à entrer</button>
					<button id="destContainer" class="btn btn-success">Lecture
						du container</button>
				</div>

				<div class="form-group">
					<label for="valeur-scan" class="control-label col-sm-4">Valeur
						lue :</label>
					<div class="col-sm-8">
						<input id="valeur-scan" type="text" class="form-control"
							placeholder="Positionnez le curseur dans cette zone avant de lire l'étiquette">
					</div>
				</div>
			</div>
		</div>
	</fieldset>
</div>

<!-- Rajout pour la lecture optique -->
<div class="row">
	<fieldset>
		<legend>Lecture optique (QRCode uniquement)</legend>
		<div class="col-md-6">
			<div class="form-horizontal protoform">
				<div class="form-group center">
					<button id="start" class="btn btn-success">Lecture du
						container</button>
					<button id="start2" class="btn btn-success">Lecture de
						l'objet à entrer</button>
					<button id="stop" class="btn btn-danger">Arrêter la
						lecture</button>
				</div>
			</div>

		</div>
	</fieldset>
</div>
<div class="row">
	<div class="col-md-6">
		<div class="center">
			<div id="reader" style="width: 640px; height: 480px"></div>
		</div>

	</div>
</div>

