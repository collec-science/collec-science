<script type="text/javascript">
	var locale = '{$LANG["date"]["locale"]}';
	var formatDate = '{$LANG["date"]["formatdate"]}';
</script>

{include file="gestion/metadataForm.tpl"}
<script type="text/javascript">

	var identifier_fn = "";
	var is_scan = false;
	var sampling_place_init = "{$data.sampling_place_id}";
	var sample_type_init = "{$data.sample_type_id}";
	var parent_uid = "{$parent_sample.uid}";
	function testScan() {
		if (is_scan) {
			return false;
		} else {
			return true;
		}
	}

	$(document).ready(function () {

		var tabHover = 0;
		try {
			tabHover = myStorage.getItem("tabHover");
		} catch (Exception) {
			console.log(Exception);
		}
		if (tabHover == 1) {
			$("#tabHoverSelect").prop("checked", true);
		}
		$("#tabHoverSelect").change(function () {
			if ($(this).is(":checked")) {
				tabHover = 1;
			} else {
				tabHover = 0;
			}
			myStorage.setItem("tabHover", tabHover);
		});
		/* Management of tabs */
		var activeTab = "{$activeTab}";
		if (activeTab.length == 0) {
			try {
				activeTab = myStorage.getItem("sampleChangeTab");
			} catch (Exception) {
				activeTab = "";
			}
		}
		try {
			if (activeTab.length > 0) {
				$("#" + activeTab).tab('show');
			}
		} catch (Exception) { }
		$('.nav-tabs > li > a').hover(function () {
			if (tabHover == 1) {
				$(this).tab('show');
			}
		});
		$('a[data-toggle="tab"]').on('shown.bs.tab', function () {
			myStorage.setItem("sampleChangeTab", $(this).attr("id"));
		});
		$('a[data-toggle="tab"]').on("click", function () {
			tabHover = 0;
		});

		$("#latitude").change(function () {
			var value = $(this).val();
			if (value.length > 0) {
				if ($("input[name='degreType']:checked").val() == 1) {
					value = convertGPSDecimalToDD(value);
				} else {
					value = convertGPSSecondeToDD(value);
				}
				$("#wgs84_y").val(value);
				setLocalisation();
			}
		});
		$("#longitude").change(function () {
			var value = $(this).val();
			if (value.length > 0) {
				if ($("input[name='degreType']:checked").val() == 1) {
					value = convertGPSDecimalToDD(value);
				} else {
					value = convertGPSSecondeToDD(value);
				}
				$("#wgs84_x").val(value);
				setLocalisation();
			}
		});

		$("#scan_label").focus(function () {
			is_scan = true;
		});
		$("#scan_label").blur(function () {
			is_scan = false;
		});

		$('#tab-location').on('shown.bs.tab', function () {
			// Trigger Leaflet to recalculate dimensions
			map.invalidateSize();
		});

		$("#sample_type_id").change(function () {
			getMetadata();
			getGenerator();
		});

		$("#collection_id").change(function () {
			getSamplingPlace();
			setVisibility();
			getSampletype();
		});

		$("#sampling_place_id").change(function () {
			getCoordinatesFromLocalisation();
		});

		$('#sampleForm').submit(function (event) {
			verifyRequired();
			if ($("#sampleForm").attr("action") == "sampleWrite") {
				var error = false;
				var sample_type_id = $("#sample_type_id").val();
				if (sample_type_id) {
					if (sample_type_id.length == 0) {
						error = true;
					}
				} else {
					error = true;
				}
				var collection_id = $("#collection_id").val();
				if (collection_id) {
					if (collection_id.length == 0) {
						error = true;
					}
				} else {
					error = true;
				}
				if (error) {
					event.preventDefault();
				}
			}
		});
		$("#reinit").click(function () {
			$("#wgs84_x").val("");
			$("#wgs84_y").val("");
			$("#sampling_date").val("");
			$("#collection_id").val("");
			$("#sample_type_id").val("");
			$("#sampling_place_id").val("");
			$("#multiple_value").val("");
			$("#metadataField").val("");
			$("#metadata").html("");
			point.setCoordinates([]);

		});
		$("#identifier_generate").click(function () {
			if (identifier_fn.length > 0) {
				$("#identifier").val(eval(identifier_fn).trim());
			}
		});

		$("#scan_label_action").click(function () {
			var contenu = $("#scan_label").val();
			if (contenu.length > 0) {
				try {
					var data = JSON.parse(contenu);
					/*
					 * Traitement de chaque cle
					 */
					for (var key in data) {
						switch (key) {
							case "uid":
								$("#dbuid_origin").val(data["db"] + ":" + data["uid"]);
								break;
							case "id":
								$("#identifier").val(data["id"]);
								break;
							case "prj":
								$('#collection_id option[value]="' + data["prj"] + '"]').attr("selected", "selected");
								break;
							case "col":
								$('#collection_id option[value]="' + data["col"] + '"]').attr("selected", "selected");
								break;
							case "x":
								$("#wgs84_x").val(data["x"]);
								break;
							case "y":
								$("#wgs84_y").val(data["y"]);
								break;
							case "loc":
								$('#sampling_place_id option[value]="' + data["loc"] + '"]').attr("selected", "selected");
								break;
							case "sd":
								$("#sampling_date").val(data["sd"]);
								break;
							case "cd":
								$("#sample_creation_date").val(data["cd"]);
								break;
							case "ed":
								$("#expiration_date").val(data["ed"]);
								break;
							default:
								$('input[name=' + key + ']').val(data[key]);
								break;
						}
					}
				} catch (e) {
					console.error("Parsing Json error:", e);
				}
			}

		});
		/*
		* call to parent
		*/
		$("#parent_display").on("click keyup", function () {
			if (parent_uid.length > 0) {
				window.location.href = "sampleDisplay?uid=" + parent_uid;
			}
		});
		/*
		* Search from parent
		*/
		$("#parent_search").on("focusout", function () {
			var chaine = $("#parent_search").val();
			if (chaine.length > 0) {
				var url = "sampleSearchAjax";
				var is_container = 2;
				var sample_id = $("#sample_id").val();
				var collection = "";
				var type = "";
				$.ajax({
					url: url, method: "GET", data: { name: chaine, uidsearch: chaine }, success: function (djs) {
						var options = "";
						try {
							var data = JSON.parse(djs);
							for (var i = 0; i < data.length; i++) {
								if (sample_id != data[i].sample_id) {
									options += '<option value="' + data[i].sample_id + '">' + data[i].uid + "-" + data[i].identifier + "</option>";
									if (i == 0) {
										collection = data[0].collection_name;
										type = data[0].sample_type_name;
										parent_uid = data[0].uid;
									}
								}
							}
						} catch (error) { }
						$("#parent_sample_id").html(options);
						$("#parent_collection").val(collection);
						$("#parent_type").val(type);
						$("#parent_sample_id").change();
					}
				});
			}
		});
		/*
		* Delete parent
		*/
		$("#parent_erase").on("click keyup", function () {
			$("#parent_sample_id").html("");
			$("#parent_collection").val("");
			$("#parent_type").val("");
			parent_uid = "";
		});
		/*
		 * update parent attributes
		 */
		$("#parent_sample_id").change(function () {
			var id = $(this).val();
			var sample_id = $("#sample_id").val();
			if (id != null && sample_id == 0) {
				$.ajax({
					url: "", method: "GET", data: { module: "sampleGetFromIdAjax", sample_id: id },
					success: function (djs) {
						var collection = "";
						var type = "";
						var uid = "";
						try {
							var data = JSON.parse(djs);
							collection = data["collection_name"];
							type = data["sample_type_name"];
							uid = data["uid"];
						} catch (error) { }
						$("#parent_collection").val(collection);
						$("#parent_type").val(type);
						parent_uid = uid;
						/*
						 * set values of parent to the child
						 */
						$("#collection_id").val(data["collection_id"]);
						$("#wgs84_x").val(data["wgs84_x"]);
						$("#wgs84_y").val(data["wgs84_y"]);
						$("#location_accuracy").val(data["location_accuracy"]);
						$("#sampling_place_id").val(data["sampling_place_id"]);
						$("#referent_id").val(data["referentId"]);
						$("#identifier").val(data["identifier"]);
						$("#campaign_id").val(data["campaign_id"]);
						$("#country_id").val(data["country_id"]);
						$("#country_origin_id").val(data["country_origin_id"]);
						$("#metadataField").val(data["metadata"]);
						getMetadata();
						setLocalisation();
					}
				});
			}
		});

		$("#verifyRequired").on("click enter", function () {
			verifyRequired();
		})
		/**
		 * Add icone when a required field is empty
		 */
		function verifyRequired() {
			$(".tab-pane").each(function () {
				var ok = true;
				var id = $(this).attr("id");
				$("#" + id + " :input").each(function () {
					if ($(this).prop('required') && $(this).val().length == 0) {
						ok = false;
					}
				});
				var icone = $(this).data("error");
				if (!ok) {
					$("#" + icone).show();
				} else {
					$("#" + icone).hide();
				}
			});
		}
		verifyRequired();
		$(":input").change(function () {
			verifyRequired();
		});
		/*
		 * Lecture initiale
		 */
		getSamplingPlace();
		setVisibility();
		getSampletype();
		getGenerator(sample_type_init);
		/**
		 * Functions
		 */
		function convertGPSSecondeToDD(valeur) {
			var parts = valeur.split(/[^\d]+/);
			var dd = parseFloat(parts[0]) + parseFloat(parseFloat(parts[1]) / 60) + parseFloat(parseFloat(parts[2]) / 3600);
			//dd = parseFloat(dd);
			var lastChar = valeur.substr(-1).toUpperCase();
			dd = Math.round(dd * 1000000) / 1000000;
			if (lastChar == "S" || lastChar == "W" || lastChar == "O") {
				dd *= -1;
			};
			return dd;
		}

		function convertGPSDecimalToDD(valeur) {
			var parts = valeur.split(/[^\d]+/);
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
		function getMetadata() {
			/*
			 * Recuperation du modele de metadonnees rattache au type d'echantillon
			 */
			var dataParse = $("#metadataField").val();
			dataParse = dataParse.replace(/&quot;/g, '"');
			dataParse = dataParse.replace(/\n/g, "\\n");
			if (dataParse.length > 2) {
				dataParse = JSON.parse(dataParse);
			}
			var schema;
			var sti = $("#sample_type_id").val();
			if (sti) {
				$.ajax({
					url: "sampleTypeMetadata",
					data: { "sample_type_id": sti }
				})
					.done(function (value) {
						if (value) {
							var schema = value.replace(/&quot;/g, '"');
							generateMetadataForm(JSON.parse(schema), dataParse);
							$("#tab-metadata").removeClass("disabled");
							$("#identifier").change();
						} else {
							$("#tab-metadata").addClass("disabled");
							document.getElementById('metadata').innerHTML = "";
							$("#metadata-error").hide();
						}
					})
					;
			}
		}

		function getSamplingPlace() {
			/*
			 * Recuperation de la liste des lieux de prelevement rattaches a la collection
			 */
			var colid = $("#collection_id").val();
			var url = "samplingPlaceGetFromCollection";
			var data = { "collection_id": colid };
			$.ajax({ url: url, data: data })
				.done(function (d) {
					if (d) {
						d = JSON.parse(d);
						options = '<option value="">{t}Choisissez...{/t}</option>';
						for (var i = 0; i < d.length; i++) {
							options += '<option value="' + d[i].sampling_place_id + '"';
							if (d[i].sampling_place_id == sampling_place_init) {
								options += ' selected ';
							}
							options += '>';
							if (d[i].sampling_place_code) {
								options += d[i].sampling_place_code;
							} else {
								options += d[i].sampling_place_name;
							}
							options += '</option>';
						};
						$("#sampling_place_id").html(options);
					}
				});
		}

		function getCoordinatesFromLocalisation() {
			/*
			 * Recuperation des coordonnees geographiques a partir du lieu de prelevement
			 */
			var locid = $("#sampling_place_id").val();
			if (locid > 0) {
				var x = $("#wgs84_x").val();
				var y = $("#wgs84_y").val();
				if (x.length == 0 && y.length == 0) {
					var url = "samplingPlaceGetCoordinate";
					var data = { "sampling_place_id": locid };
					$.ajax({ url: url, data: data })
						.done(function (data) {
							data = JSON.parse(data);
							if (data["sampling_place_x"].length > 0 && data["sampling_place_y"].length > 0) {
								$("#wgs84_x").val(data["sampling_place_x"]);
								$("#wgs84_y").val(data["sampling_place_y"]);
								$("#wgs84_x").trigger("change");
							}
						});
				}
			}
		}

		function getGenerator(sti) {
			/*
			 * Recuperation du script utilisable pour generer l'identifiant metier
			 */
			if (!sti) {
				var sti = $("#sample_type_id").val();
			}
			if (sti) {
				$.ajax({
					url: "sampleTypeGenerator",
					data: { "sample_type_id": sti }
				})
					.done(function (value) {
						if (value.length > 0) {
							identifier_fn = value;
							$("#identifier_generate").prop("disabled", false);
						} else {
							$("#identifier_generate").prop("disabled", true);
						}
					})
			}
		}

		function setVisibility() {
			var collection_id = $("#collection_id").val();
			$.ajax({
				url: "collectionGet",
				data: { "collection_id": collection_id }
			})
				.done(function (value) {
					value = JSON.parse(value);
					if (value.no_localization == 't') {
						$("#tab-location").addClass('disabled');
					} else {
						$("#tab-location").removeClass('disabled');
					}
				})
				;
		}

		function getSampletype() {
			var collection_id = $("#collection_id").val();
			$.ajax({
				url: "sampleTypeGetListAjax",
				data: { "collection_id": collection_id }
			})
				.done(function (value) {
					d = JSON.parse(value);
					var options = '';
					for (var i = 0; i < d.length; i++) {
						options += '<option value="' + d[i].sample_type_id + '"';
						if (d[i].sample_type_id == sample_type_init) {
							options += ' selected ';
						}
						options += '>' + d[i].sample_type_name;
						if (d[i].multiple_type_id > 0) {
							options += ' / ' + d[i].multiple_type_name + ' : ' + d[i].multiple_unit;
						}
						options += '</option>';
					};
					$("#sample_type_id").html(options);
					getMetadata();
				});
		}

		function setLocalisation() {
			var lon = $("#wgs84_x").val();
			var lat = $("#wgs84_y").val();
			if (lon.length > 0 && lat.length > 0) {
				setPosition(lat, lon);
			}
		}
	});
</script>

<h2>{t}Création - modification d'un échantillon{/t}</h2>
<form id="sampleForm" method="post" action="sampleWrite" onsubmit="return(testScan());">
	<input type="hidden" id="sample_id" name="sample_id" value="{$data.sample_id}">
	<input type="hidden" name="moduleBase" value="sample">
	<input type="hidden" name="metadata" id="metadataField" value="{$data.metadata}">
	<div class="row">
		<div class="col-md-12">
			<a href="{$moduleListe}">
				<img src="display/images/list.png" height="25">
				{t}Retour à la liste des échantillons{/t}
			</a>
			{if $data.uid > 0}
			<a href="sampleDisplay?uid={$data.uid}">
				<img src="display/images/box.png" height="25">{t}Retour au détail{/t}
			</a>
			{elseif $sample_parent_uid > 0}
			<a href="sampleDisplay?uid={$sample_parent_uid}">
				<img src="display/images/box.png" height="25">{t}Retour au détail{/t}
			</a>
			{/if}
			&nbsp;
			<button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
			{if $data.sample_id > 0 }
			&nbsp;
			<button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
			{/if}
			{if $data.sample_id == 0}
			&nbsp;
			<button type="button" class="btn btn-warning" id="reinit">{t}Réinitialiser les champs{/t}</button>
			{/if}
			&nbsp;
			<button type="button" class="btn btn-info" id="verifyRequired">
				<img src="display/images/cross.png" height="15">
				{t}Vérifier{/t}
			</button>
		</div>
	</div>




	<!-- boite d'onglets -->
	<div class="row">
		<ul class="nav nav-tabs" id="changeTab" role="tablist">
			<li class="nav-item active">
				<a class="nav-link" id="tab-general" data-toggle="tab" role="tab" aria-controls="nav-general"
					aria-selected="true" href="#nav-general">
					<img src="display/images/zoom.png" height="25">
					{t}Données générales{/t}
					<img src="display/images/cross.png" id="general-error" height="25" hidden>
				</a>
			</li>
			<li class="nav-item  ">
				<a class="nav-link" id="tab-location" href="#nav-location" data-toggle="tab" role="tab"
					aria-controls="nav-location" aria-selected="false">
					<img src="display/images/gps.png" height="25">
					{t}Localisation{/t}
					<img src="display/images/cross.png" id="location-error" height="25" hidden>
				</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" id="tab-metadata" href="#nav-metadata" data-toggle="tab" role="tab"
					aria-controls="nav-metadata" aria-selected="false">
					<img src="display/images/display-red.png" height="25">
					{t}Métadonnées{/t}
					<img src="display/images/cross.png" height="25" id="metadata-error" hidden>
				</a>
			</li>
		</ul>
		<div class="tab-content" id="nav-tabContent">
			<div class="tab-pane active in" id="nav-general" role="tabpanel" aria-labelledby="tab-general"
				data-error="general-error">
				<div class="col-md-6 form-horizontal">
					<fieldset>
						<legend>{t}Échantillon parent{/t}</legend>
						<div class="form-group">
							<label for="parent_sample_id" class="control-label col-md-4"> {t}Parent :{/t}</label>
							<div class="col-md-2">
								<input id="parent_search" class="form-control" placeholder="{t}UID ou identifiant{/t}">
							</div>
							<div class="col-md-4">
								<select id="parent_sample_id" name="parent_sample_id" class="form-control">
									{if $data.parent_sample_id > 0}
									<option value="{$data.parent_sample_id}">
										{$parent_sample.uid} {$parent_sample.identifier}
									</option>
									{/if}
								</select>
							</div>
							<div id="parent_display" class="col-md-1">
								<img src="display/images/zoom.png" height="25" title="{t}Afficher le parent{/t}">
							</div>
							<div id="parent_erase" class="col-md-1">
								<img src="display/images/eraser.png" height="25" title="{t}Supprimer le parent{/t}">
							</div>
						</div>
						<div class="form-group">
							<label for="parent_collection" class="control-label col-md-4">
								{t}Collection :{/t}
							</label>
							<div class="col-md-8">
								<input id="parent_collection" class="form-control" readonly
									value="{$parent_sample.collection_name}">
							</div>
						</div>
						<div class="form-group">
							<label for="parent_type" class="control-label col-md-4">{t}Type :{/t}</label>
							<div class="col-md-8">
								<input id="parent_type" class="form-control" readonly
									value="{$parent_sample.sample_type_name}">
							</div>
						</div>
					</fieldset>
					<fieldset>
						<legend>{t}Données générales{/t}</legend>
						<div class="form-group">
							<label for="scan_label" class="control-label col-md-4">
								{t}Scannez l'étiquette existante :{/t}</label>
							<div class="col-md-5">
								<input id="scan_label" class="form-control"
									placeholder="{t}Placez le curseur dans cette zone et scannez l'étiquette{/t}">
							</div>
							<div class="col-md-3">
								<button class="btn btn-info" type="button" id="scan_label_action">
									{t}Mettre à jour les champs{/t}
								</button>
							</div>
						</div>
						<div class="form-group">
							<label for="uid" class="control-label col-md-4">{t}UID :{/t}</label>
							<div class="col-md-8">
								<input id="uid" name="uid" value="{$data.uid}" readonly class="form-control"
									title="{t}identifiant unique dans la base de données{/t}">
							</div>
						</div>
						<div class="form-group">
							<label for="identifier" class="control-label col-md-4"><span class="red">*</span>
								{t}Identifiant ou nom :{/t}
							</label>
							<div class="col-md-6">
								<input id="identifier" type="text" name="identifier" class="form-control"
									value="{$data.identifier}" autofocus required>
							</div>
							<div class="col-md-2">
								<button class="btn btn-info" type="button" id="identifier_generate" disabled
									title="{t}Générez l'identifiant à partir des informations saisies{/t}">{t}Générer{/t}</button>
							</div>
						</div>
						<div class="form-group">
							<label for="object_status_id" class="control-label col-md-4"><span class="red">*</span>
								{t}Statut :{/t}
							</label>
							<div class="col-md-8">
								<select id="object_status_id" name="object_status_id" class="form-control">
									{section name=lst loop=$objectStatus}
									<option value="{$objectStatus[lst].object_status_id}" {if
										$objectStatus[lst].object_status_id==$data.object_status_id}selected{/if}>
										{$objectStatus[lst].object_status_name}
									</option>
									{/section}
								</select>
							</div>
						</div>
						<div class="form-group">
							<label for="collection_id" class="control-label col-md-4"><span class="red">*</span>
								{t}Collection :{/t}
							</label>
							<div class="col-md-8">
								<select id="collection_id" name="collection_id" class="form-control" autofocus>
									{foreach $collections as $collection}
									<option value="{$collection.collection_id}" {if
										$data.collection_id==$collection.collection_id}selected{/if}>
										{$collection.collection_name}
									</option>
									{/foreach}
								</select>
							</div>
						</div>
						<div class="form-group">
							<label for="referentId" class="control-label col-md-4">
								{t}Référent de l'échantillon :{/t}
							</label>
							<div class="col-md-8">
								<select id="referentId" name="referent_id" class="form-control">
									<option value="" {if $data.referent_id=="" }selected{/if}>Choisissez...</option>
									{foreach $referents as $referent}
									<option value="{$referent.referent_id}" {if
										$data.referent_id==$referent.referent_id}selected{/if}>
										{$referent.referent_name}
									</option>
									{/foreach}
								</select>
							</div>
						</div>
						<div class="form-group">
							<label for="sample_type_id" class="control-label col-md-4"><span class="red">*</span>
								{t}Type :{/t}
							</label>
							<div class="col-md-8">
								<select id="sample_type_id" name="sample_type_id" class="form-control">
								</select>
							</div>
						</div>
						<div class="form-group ">
							<label for="campaign_id" class="control-label col-md-4">
								{t}Campagne de prélèvement :{/t}
							</label>
							<div class="col-md-8">
								<select id="campaign_id" name="campaign_id" class="form-control">
									<option value="" {if $data.campaign_id=="" }selected{/if}>{t}Choisissez...{/t}
									</option>
									{foreach $campaigns as $campaign}
									<option value="{$campaign.campaign_id}" {if
										$data.campaign_id==$campaign.campaign_id}selected{/if}>
										{$campaign.campaign_name}
									</option>
									{/foreach}
								</select>
							</div>
						</div>
						<div class="form-group">
							<label for="dbuid_origin" class="control-label col-md-4">
								{t}Base de données et UID d'origine :{/t}
							</label>
							<div class="col-md-8">
								<input id="dbuid_origin" class="form-control" name="dbuid_origin"
									value="{$data.dbuid_origin}" placeholder="{t}db:uid. Exemple: col:125{/t}">
							</div>
						</div>
						<div class="form-group">
							<label for="sampling_date" class="control-label col-md-4">
								{t}Date de création/échantillonnage de l'échantillon :{/t}
							</label>
							<div class="col-md-8">
								<input id="sampling_date" class="form-control datetimepicker" name="sampling_date"
									value="{$data.sampling_date}">
							</div>
						</div>
						<div class="form-group">
							<label for="sample_creation_date" class="control-label col-md-4">
								{t}Date d'import dans la base de données :{/t}
							</label>
							<div class="col-md-8">
								<input id="sample_creation_date" class="form-control" name="sample_creation_date"
									readonly value="{$data.sample_creation_date}">
							</div>
						</div>
						<div class="form-group">
							<label for="expiration_date" class="control-label col-md-4">
								{t}Date d'expiration de l'échantillon :{/t}
							</label>
							<div class="col-md-8">
								<input id="expiration_date" class="form-control datepicker" name="expiration_date"
									value="{$data.expiration_date}">
							</div>
						</div>
						<div class="form-group">
							<label for="object_comment" class="control-label col-md-4">{t}Commentaire :{/t}</label>
							<div class="col-md-8">
								<textarea class="form-control" rows="3" id="object_comment"
									name="object_comment">{$data.object_comment}</textarea>
							</div>
						</div>
					</fieldset>
					<fieldset>
						<legend>{t}Sous-échantillonnage (si le type le permet){/t}</legend>
						<div class="form-group">
							<label for="multiple_value" class="control-label col-md-4">
								{t 1=$data.multiple_type_name 2=$data.multiple_unit}Quantité initiale de sous-échantillons (%1:%2) :{/t}</label>
							<div class="col-md-8">
								<input id="multiple_value" class="form-control taux" name="multiple_value"
									value="{$data.multiple_value}">
							</div>
						</div>
						{if $data.parent_sample_id > 0 && $data.sample_id == 0}
						<script>
							$(document).ready(function () {
								$("#multiple_value").change(function () {
									$("#subsample_quantity").val($("#multiple_value").val());
								});
							});
						</script>
						<!-- record quantity extracted from parent-->
						<div class="form-group">
							<label for="subsample_quantity" class="control-label col-md-4">
								{t 1=$data.multiple_type_name 2=$data.multiple_unit}Quantité retirée au parent (%1:%2) :{/t}</label>
							<div class="col-md-8">
								<input id="subsample_quantity" class="form-control taux" name="subsample_quantity">
							</div>
						</div>
						{/if}
					</fieldset>
					<fieldset>
						<legend>{t}Informations diverses{/t}</legend>
						<div class="form-group">
							<label for="uuid" class="control-label col-md-4">{t}UID universel (UUID) :{/t}</label>
							<div class="col-md-8">
								<input id="expiration_date" class="form-control uuid" name="uuid" value="{$data.uuid}">
							</div>
						</div>
						{if $data.sample_id > 0}
						<div class="form-group">
							<label for="trashed" class="col-md-4 control-label">
								{t}Échantillon en attente de suppression (mis à la corbeille) :{/t}
							</label>
							<div class="col-md-8" id="trashed">
								<div class="radio-inline">
									<label>
										<input type="radio" name="trashed" id="trashed1" value="1" {if
											$data.trashed=='t' }checked{/if}>
										{t}oui{/t}
									</label>
								</div>
								<div class="radio-inline">
									<label>
										<input type="radio" name="trashed" id="trashed0" value="0" {if $data.trashed
											!='t' }checked{/if}>
										{t}non{/t}
									</label>
								</div>
							</div>
						</div>
						{/if}
					</fieldset>
				</div>
			</div>
			<div class="tab-pane fade" id="nav-location" role="tabpanel" aria-labelledby="tab-location">
				<div class="col-md-6 form-horizontal">
					<div class="form-group ">
						<label for="country_id" class="control-label col-md-4 lexical" data-lexical="country">
							{t}Pays de collecte :{/t}
						</label>
						<div class="col-md-8">
							<select id="country_id" name="country_id" class="form-control">
								<option value="" {if $data.country_id=="" }selected{/if}>{t}Choisissez...{/t}
								</option>
								{foreach $countries as $country}
								<option value="{$country.country_id}" {if
									$data.country_id==$country.country_id}selected{/if}>
									{$country.country_name}
								</option>
								{/foreach}
							</select>
						</div>
					</div>
					<div class="form-group ">
						<label for="country_origin_id" class="control-label col-md-4 lexical"
							data-lexical="country_origin">
							{t}Pays de provenance :{/t}
						</label>
						<div class="col-md-8">
							<select id="country_origin_id" name="country_origin_id" class="form-control">
								<option value="" {if $data.country_origin_id=="" }selected{/if}>{t}Choisissez...{/t}
								</option>
								{foreach $countries as $country}
								<option value="{$country.country_id}" {if
									$data.country_origin_id==$country.country_id}selected{/if}>
									{$country.country_name}
								</option>
								{/foreach}
							</select>
						</div>
					</div>
					<div class="form-group ">
						<label for="sampling_place_id" class="control-label col-md-4">
							{t}Lieu de prélèvement :{/t}
						</label>
						<div class="col-md-8">
							<select id="sampling_place_id" name="sampling_place_id" class="form-control ">
							</select>
						</div>
					</div>
					<div class="form-group">
						<label for="" class="control-label col-sm-4">
							{t}Mode de calcul des coordonnées GPS :{/t}
						</label>
						<div class="col-sm-8">
							<table>
								<tr>
									<td>
										{t}Données initiales en degrés/minutes décimales{/t}
									</td>
									<td>
										<input name="degreType" type="radio" checked value="1">
									</td>
								</tr>
								<tr>
									<td>
										{t}Données initiales en degrés/minutes/secondes{/t}
									</td>
									<td>
										<input name="degreType" type="radio" value="0">
									</td>
								</tr>
							</table>
						</div>
					</div>
					<div class="form-group ">
						<label for="wy" class="control-label col-md-4">{t}Latitude :{/t}</label>
						<div class="col-md-8" id="wy">
							{t}Format sexagesimal (45°01,234N) :{/t}
							<input id="latitude" placeholder="45°01,234N" autocomplete="off" class="form-control">
							{t}Format décimal (45.081667) :{/t}
							<input id="wgs84_y" name="wgs84_y" placeholder="45.081667" autocomplete="off"
								class="form-control taux position" value="{$data.wgs84_y}">
						</div>
					</div>
					<div class="form-group ">
						<label for="wx" class="control-label col-md-4">{t}Longitude :{/t}</label>
						<div class="col-md-8" id="wx">
							{t}Format sexagesimal (0°01,234W) :{/t}
							<input id="longitude" placeholder="0°01,234W" autocomplete="off" class="form-control">
							{t}Format décimal (-0.081667) :{/t}
							<input id="wgs84_x" name="wgs84_x" placeholder="-0.081667" autocomplete="off"
								class="form-control taux position" value="{$data.wgs84_x}">
						</div>
					</div>
					<div class="form-group ">
						<label for="location_accuracy" class="control-label col-md-4 lexical"
							data-lexical="accuracy">{t}Précision de la localisation (en mètres) :{/t}</label>
						<div class="col-md-8">
							<input id="sampling_date" class="form-control taux" name="location_accuracy"
								value="{$data.location_accuracy}">
						</div>
					</div>
				</div>
				<div class="col-md-6 ">
					{include file="gestion/objectMapDisplay.tpl"}
				</div>
			</div>
			<div class="tab-pane fade" id="nav-metadata" role="tabpanel" aria-labelledby="tab-metadata"
				data-error="metadata-error">
				<div class="form-group form-horizontal">
					<div class="col-md-6 form-horizontal">
						<div id="metadata"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	{$csrf}
</form>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>