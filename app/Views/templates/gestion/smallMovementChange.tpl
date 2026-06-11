<script>
	$(document).ready(function () {

		var mouvements = {};
		var objets = {};
		var timer;
		var timer_duration = 500;
		var db = "{$db}";

		$("#cam-qr-result").change(function () {
			var value = $(this).val();
			$("#" + destination).val(value);
			$("#" + destination).change();
		});
		/*
		 * Traitement des recherches
		 */
		$("#object_search").on('keyup change', function () {
			clearTimeout(timer);
			timer = setTimeout(object_search, timer_duration);
		});

		function object_search() {
			var val = getVal($("#object_search").val());
			if (val) {
				search("objectGetDetail", "object_uid", val, 0);
			}
		}

		function container_search() {
			var val = getVal($("#container_search").val());
			if (val) {
				search("objectGetDetail", "container_uid", val, 1);
			}
		}
		$("#container_search").on('keyup change', function () {
			clearTimeout(timer);
			timer = setTimeout(container_search, timer_duration);
		});
		$("#object_search,#container_search").focus(function () {
			is_scan = true;
		});
		$("#object_search,#container_search").blur(function () {
			is_scan = false;
		});
		$('#start').click(function () {
			$("#video-container").show();
			destination = "container_search";
			scanner.start().then(() => {
				updateFlashAvailability();
				searchCamera();
			});

		});
		$('#start2').click(function () {
			destination = "object_search";
			$("#video-container").show();
			scanner.start().then(() => {
				updateFlashAvailability();
				searchCamera();
			});
		});
		$('#stop').click(function () {
			$("#video-container").hide();
			scanner.stop();
		});
		$("#object_uid").on("change", function () {
			var uid = $("#object_uid").val();
			var position = "";
			if (objets[uid]) {
				if (objets[uid]["position"]) {
					if (objets[uid]["position"] == 1) {
						position = "{t}Dans le stock{/t}";
					} else {
						position = "{t}Hors du stock{/t}";
					}
				}
				$("#position_stock").val(position);
			}
			search("objectGetLastEntry", "container_uid", $("#object_uid").val(), false);
		});


		function getVal(val) {
			/*
			 * Extraction de la valeur - cas notamment de la lecture par douchette
			 */
			val = val.trim();

			var firstChar = val.substring(0, 1);
			var lastChar = val.substring(vallength - 1, vallength);
			if (firstChar == "[" || firstChar == String.fromCharCode(123)) {
				var vallength = val.length;
				var lastChar = val.substring(vallength - 1, vallength);
				if (lastChar == "]" || lastChar == String.fromCharCode(125)) {
					val = extractUidValFromJson(val);
				} else {
					val = "";
				}
			} else if (val.substring(0, 4) == "http" || val.substring(0, 3) == "htp") {
				var elements = valeur.split("/");
				var nbelements = elements.length;
				if (nbelements > 0) {
					val = elements[nbelements - 1];
				}
			}
			return val;
		}

		function search(module, fieldid, value, is_container) {
			/*
			 * Declenchement de la recherche Ajax
			 */
			/*
			 * Traitement des caracteres parasites de ean128
			 */
			if (value) {
				/*
				 * Traitement des caracteres parasites de ean128
				 */
				if (value.length > 0) {
					value = value.replace(/]C1/g, "");
				}
				var url = module;
				var chaine;
				var options = "";
				if (is_container == true) {
					mouvements = {};
				} else {
					objets = {};
				}
				document.getElementById("resultMessage").innerHTML = "";
				$.ajax({
					url: url, method: "GET", data: { uid: value, is_container: is_container, is_partial: true }, success: function (djs) {
						var data = JSON.parse(djs);
						for (var i = 0; i < data.length; i++) {
							var uid = data[i].uid;
							if (module == "objectGetLastEntry") {
								uid = data[i].parent_uid;
							}
							if (module == "objectGetDetail") {
								objets[uid] = {};
								objets[uid]["position"] = data[i].last_movement_type;
							}
							options += '<option value="' + uid + '">' + uid + "-" + data[i].identifier;
							if (module == "objectGetLastEntry") {
								options += " col:" + data[i].column_number + " line:" + data[i].line_number;
								mouvements[uid] = {};
								mouvements[uid]["col"] = data[i].column_number;
								mouvements[uid]["line"] = data[i].line_number;
							}
							options += "</option>";
						}
						$("#" + fieldid).html(options);
						$("#" + fieldid).change();
					}
				});
			}
		}

		function extractUidValFromJson(valeur) {
			/*
			 * Extrait le contenu de la chaine json
			 * Transformation des [] en { }
			 */
			// valeur = valeur.replace("[", String.fromCharCode(123));
			//valeur = valeur.replace ("]", String.fromCharCode(125));
			var data = JSON.parse(valeur);
			if (data["db"] == db) {
				return data["uid"];
			} else {
				return data["db"] + ":" + data["uid"];
			}
		}

		$("#container_uid").change(function () {
			var val = $("#container_uid").val();
			if (val > 0 && mouvements[val]) {
				$("#col").val(mouvements[val]["col"]);
				$("#line").val(mouvements[val]["line"]);
			} else {
				$("#col").val(1);
				$("#line").val(1);
			}
		});

		/*
		 * Declenchement des mouvements
		 */
		$("#entry").click(function (event) {
			/*
			 * Verification qu'un objet et un container soient selectionnes
			 */
			var ok = false;
			var ouid = $("#object_uid").val();
			var cuid = $("#container_uid").val();
			if (ouid && cuid) {
				if (ouid.length > 0 && cuid.length > 0) {
					ok = true;
				}
			}
			if (ok) {
				$("#movement_type_id").val("1");
				write();
			}
			event.preventDefault();
		});

		$("#exit").click(function (event) {
			/*
			  * Verification qu'un objet soit selectionne
			  */
			var ok = false;
			var ouid = $("#object_uid").val();
			if (ouid) {
				if (ouid.length > 0) {
					ok = true;
				}
			}
			if (ok) {
				$("#movement_type_id").val("2");
				write();
			}
			event.preventDefault();
		});

		function setMessage(isOk, message = "") {
			var mess = document.getElementById("resultMessage");
			if (isOk) {
				mess.innerHTML = "{t}Mouvement créé{/t}";
				mess.classList.add("message");
				mess.classList.remove("messageError");
				$("#object_search").val("");
				$("#object_uid").val("");
				$("#position_stock").empty();
				$("#object_search").focus();
			} else {
				mess.innerHTML = message;
				mess.classList.remove("message");
				mess.classList.add("messageError");
			}

		}
		function write() {
			$.ajax({
				url: "smallMovementWriteAjax",
				method: "POST",
				data: {
					movement_type_id: $("#movement_type_id").val(),
					object_uid: $("#object_uid").val(),
					container_uid: $("#container_uid").val(),
					movement_reason_id: $("#movement_reason_id").val(),
					column_number: $("#column_number").val(),
					line_number: $("#line_number").val()
				}
				, success: function (res) {
					var result = JSON.parse(res);
					if (result.error_code == 200) {
						setMessage(true);

					} else {
						setMessage(false, result.error_message);
					}
				}
			});
		}
		/*
		 * Remise a zero des zones de recherche
		 */
		$("#clear_container_search").click(function (event) {
			$("#container_search").val("");
			$("#container_uid").empty();
			$("#container_search").focus();
		});
		$("#clear_object_search").click(function (event) {
			$("#object_search").val("");
			$("#object_uid").empty();
			$("#object_search").focus();
		});
		/*
		 * Inhibition de l'envoi du formulaire si vide
		 */
		$("#smallMovement").submit(function (event) {
			var valobj = $("#object_uid").val();
			if (valobj) {
				if (valobj.length != 0) {
					write()
				}
			}
			event.preventDefault();
		});
	});
</script>

<div id="resultMessage"></div>
<div class="container">
	<form class="form-horizontal" id="smallMovement" method="post" action="smallMovementWrite" onsubmit="return(testScan());">
		<input type="hidden" name="moduleBase" value="smallMovement">
		<input type="hidden" name="movement_id" value="0">
		<input type="hidden" id="movement_type_id" name="movement_type_id" value="1">
		<div class="row">
			<div class="col-xs-9 col-8">
				<input id="object_search" type="text" name="object_search" placeholder="{t}Objet à entrer ou déplacer / sortir{/t}" value="" class="form-control " autofocus autocomplete="off">
			</div>
			<div class="col-xs-3 col-4">
				<button id="clear_object_search" class="btn btn-block  btn-info " type="button">{t}Effacer{/t}</button>
			</div>
			<div class="col-xs-12 col-12">
				<select id="object_uid" name="object_uid" class="form-select ">
				</select>
			</div>
			<div class="col-xs-3 col-12">
				<input id="position_stock" class="form-control " disabled value="">
			</div>
			<div class="col-xs-12">
				<select id="movement_reason_id" name="movement_reason_id" class="form-select ">
					<option value="" {if $movement_reason_id=="" }selected{/if}>
						{t}Motif du déstockage...{/t}
					</option>
					{section name=lst loop=$movementReason}
					<option value="{$movementReason[lst].movement_reason_id}" {if $movement_reason_id==$movementReason[lst].movement_reason_id}selected{/if}>
						{$movementReason[lst].movement_reason_name}
					</option>
					{/section}
				</select>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-9 col-8">
				<input id="container_search" type="text" name="container_search" placeholder="{t}Contenant de destination{/t}" value="" class="form-control " autofocus autocomplete="off">
			</div>
			<div class="col-xs-3 col-4">
				<button id="clear_container_search" class="btn btn-block btn-info " type="button">{t}Effacer{/t}</button>
			</div>
			<div class="col-xs-12 col-12">
				<select id="container_uid" name="container_uid" class="form-select ">
				</select>
			</div>
			<div class="col-2 ">{t}Colonne :{/t}</div>
			<div class="col-4 ">
				<input id="column_number" name="column_number" value="1" class="form-control ">
			</div>
			<div class="col-2 ">{t}Ligne:{/t}</div>
			<div class="col-4">
				<input id="line_number" name="line_number" value="1" class="form-control ">
			</div>
		</div>

		<div class="row d-flex justify-content-center">
			<div class="col-auto">
				<button id="entry" class="btn btn-block btn-info " type="button">
					<span>
						{t}Entrer{/t}
					</span>
				</button>
			</div>
			<div class="col-auto">
				<button id="exit" class="btn btn-block btn-danger " type="button">
					<span>
						{t}Sortir{/t}
					</span>
				</button>
			</div>
		</div>
		{$csrf}
	</form>
</div>
<div class="container" id="optical">
	<fieldset>
		<legend>{t}Lecture par la caméra{/t}</legend>

		<div class="form-horizontal ">
			<div class="row d-flex justify-content-center">
				<div class="col-auto">
					<button id="start2" class="btn btn-success btn-block " type="button">
						<span>
							{t}Lecture de l'objet{/t}
						</span>
					</button>
				</div>
				<div class="col-auto">
					<button id="start" class="btn btn-success btn-block ">
						<span>
							{t}Lecture du contenant{/t}
						</span>
					</button>
				</div>
				<div class="col-auto">
					<button id="stop" class="btn btn-danger btn-block ">
						<span>
							{t}Arrêter la lecture{/t}
						</span>
					</button>
				</div>
			</div>
		</div>

		{include file="gestion/scanner.tpl"}
	</fieldset>
</div>
