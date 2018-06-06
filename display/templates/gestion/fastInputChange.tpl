{* Mouvements > Entrer un échantillon > *}
<!-- Ajout rapide d'un échantillon dans un container -->
{include file="gestion/qrcode_read.tpl"}

<h2>{t}Déplacer dans un contenant{/t}</h2>
<div class="row">
	<div class="col-md-6">
		<form class="form-horizontal protoform fastform" id="fastInputForm"
			method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="fastInput"> <input
				type="hidden" name="action" value="Write"> <input
				type="hidden" name="movement_id" value="0"> <input
				type="hidden" id="read_optical" name="read_optical"
				value="{$read_optical}">


			<div class="form-group">
				<label for="container_uid" class="control-label col-sm-4">
				<img id="arrow-container" src="{$display}/images/right-arrow.png" height="25">
				<span class="red">*</span> {t}UID du contenant :{/t}
				</label>
				<div class="col-sm-8" id="container_groupe">
					<div class="col-sm-3">
						<input id="container_uid" type="text" name="container_uid"
							required value="{$container_uid}" class="form-control"
							autocomplete="off" >
					</div>
					<div class="col-sm-3 col-sm-offset-1">
						<button type="button" id="container_search"
							class="btn btn-default">{t}Chercher...{/t}</button>
					</div>
				</div>
				<div class="col-sm-8 col-sm-offset-4 ">
					<input id="container_detail" type="text" class="form-control"
						disabled>
				</div>
			</div>

			<div class="form-group">
				<label for="object_uid" class="control-label col-sm-4">
				<img id="arrow-object" src="{$display}/images/right-arrow.png" height="25">
				<span class="red">*</span>  {t}UID de l'objet :{/t}
				</label>
				<div class="col-sm-8" id="object_groupe">
					<div class="col-sm-3">
						<input id="object_uid" type="text" name="object_uid" required
							value="" class="form-control" autofocus autocomplete="off" >
					</div>
					<div class="col-sm-3 col-sm-offset-1">
						<button type="button" id="object_search" class="btn btn-default">{t}Chercher...{/t}</button>
					</div>
				</div>
				<div class="col-sm-8 col-sm-offset-4 ">
					<input id="object_detail" type="text" class="form-control" disabled>
				</div>
			</div>

			<div class="form-group">
				<label for="storage_location" class="control-label col-sm-4">{t}Emplacement dans le contenant
(format libre) :{/t}</label>
				<div class="col-sm-8">
					<input id="storage_location" name="storage_location"
						value="{$data.storage_location}" class="form-control">
				</div>
			</div>
			<div class="form-group">
				<label for="line_number" class="control-label col-sm-4">{t}N° de ligne :{/t}</label>
				<div class="col-sm-8">
					<input id="line_number" name="line_number"
						value="{$data.line_number}" class="form-control nombre" title="{t}N° de la ligne de rangement dans le container{/t}">
				</div>
			</div>
			<div class="form-group">
				<label for="column_number" class="control-label col-sm-4">{t}N° de colonne :{/t}</label>
				<div class="col-sm-8">
					<input id="column_number" name="column_number"
						value="{$data.column_number}" class="form-control nombre" title="{t}N° de la colonne de rangement dans le container{/t}">
				</div>
			</div>
			
			

			<div class="form-group">
				<label for="movement_date" class="control-label col-sm-4"><span class="red">*</span> {t}Date/heure :{/t}</label>
				<div class="col-sm-8">
					<input id="movement_date" name="movement_date" required
						value="{$data.movement_date}" class="form-control datetimepicker">
				</div>
			</div>

			<div class="form-group">
				<label for="movement_comment" class="control-label col-sm-4">{t}Commentaire :{/t}</label>
				<div class="col-sm-8">
					<textarea class="form-control" id="movement_comment"
						name="movement_comment" rows="3"></textarea>
				</div>
			</div>

			<div class="form-group center">
				<button type="submit" class="btn btn-primary button-valid">{t}Déplacer dans le contenant{/t}</button>
			</div>

		</form>
		<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
	</div>
</div>
<!-- Lecture par douchette -->
<div class="row">
	<fieldset>
		<legend>{t}Lecture optique par douchette{/t}</legend>

		<div class="col-md-6">
			<div class="form-horizontal protoform">
				<div class="form-group center">
					<button id="destObject" class="btn btn-success">{t}Lecture de l'objet à déplacer{/t}</button>
					<button id="destContainer" class="btn btn-success">{t}Lecture du contenant{/t}</button>
				</div>

				<div class="form-group">
					<label for="valeur-scan" class="control-label col-sm-4">{t}Valeur lue :{/t}</label>
					<div class="col-sm-8">
						<input id="valeur-scan" type="text" class="form-control"
							placeholder="{t}Placez le curseur dans cette zone et scannez l'étiquette{/t}">
					</div>
				</div>
			</div>
		</div>
	</fieldset>
</div>

<!-- Rajout pour la lecture optique -->
<div class="row" id="optical">
	<fieldset>
		<legend>{t}Lecture par la caméra de l'ordinateur ou du smartphone (utiliser Firefox){/t}</legend>
		<div class="col-md-6">
			<div class="form-horizontal protoform">
				<div class="form-group center">
					<button id="start" class="btn btn-success">{t}Lecture du contenant{/t}</button>
					<button id="start2" class="btn btn-success">{t}Lecture de l'objet à déplacer{/t}</button>
					<button id="stop" class="btn btn-danger">{t}Arrêter la lecture{/t}</button>
				</div>
			</div>
		</div>
		<div class="col-md-6 center">
			<video id="reader" autoplay width="320" height="240" poster="{$display}/images/webcam.png"></video>
		</div>
		
	</fieldset>
</div>

