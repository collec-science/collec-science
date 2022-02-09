{* Objets > échantillons > Rechercher > UID d'un échantillon > Modifier > *}
<script type="text/javascript" src="display/javascript/alpaca/js/formbuilder.js"></script>

<script type="text/javascript">
	var identifier_fn = "";
	var is_scan = false;
	var sampling_place_init = "{$data.sampling_place_id}";
	var parent_uid = "{$parent_sample.uid}";
	function testScan() {
		if (is_scan) {
			return false;
		} else {
			return true;
		}
	}

    $(document).ready(function() {
    	function convertGPStoDD(valeur) {
    		var parts = valeur.trim().split(/[^\d]+/);
			if (parts.length == 1) {
				parts[1] = 0;
				parts[2] = 0;
			} else if (parts.length == 2) {
				parts[2] = 0;
			}
			var dd = parseFloat(parts[0]) + ((parseFloat(parts[1]) + parseFloat(parts[2])/60) / 60);
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
				setLocalisation();
    		}
    	});
    	$("#longitude").change( function () {
    		var value = $(this).val();
    		if (value.length > 0) {
    			$("#wgs84_x").val( convertGPStoDD(value));
				setLocalisation();
    		}
    	});

        $("#scan_label").focus(function () {
        	is_scan = true;
        });
		$("#scan_label").blur(function () {
        	is_scan = false;
        });

    	function getMetadata() {
    		/*
    		 * Recuperation du modele de metadonnees rattache au type d'echantillon
    		 */
       		var dataParse = $("#metadataField").val();
        	 dataParse = dataParse.replace(/&quot;/g,'"');
        	 dataParse = dataParse.replace(/\n/g,"\\n");
        	 if (dataParse.length > 2) {
        		 dataParse = JSON.parse(dataParse);
        	 }
       	    var schema;
       	    var sti = $("#sample_type_id").val();
       	    if (sti) {
       	    	$.ajax( {
       	    		url: "index.php",
       	    		data: { "module": "sampleTypeMetadata", "sample_type_id": sti }
       	    	})
       	    	.done (function (value) {
       	    		if (value) {
       	    		var schema = value.replace(/&quot;/g,'"');
       	    		showForm(JSON.parse(schema),dataParse);
       	    		$(".alpaca-field-select").combobox();
       	    		}
       	    	})
       	    	;
       	    }
        }

    	function getSamplingPlace () {
    		/*
    		 * Recuperation de la liste des lieux de prelevement rattaches a la collection
    		 */
    		var colid = $("#collection_id").val();
    		var url = "index.php";
    		var data = { "module":"samplingPlaceGetFromCollection", "collection_id": colid };
    		$.ajax ( { url:url, data: data})
    		.done (function( d ) {
   				if (d ) {
    				d = JSON.parse(d);
    				options = '<option value="">{t}Choisissez...{/t}</option>';
    				 for (var i = 0; i < d.length; i++) {
    				        options += '<option value="'+d[i].sampling_place_id + '"';
    				        if (d[i].sampling_place_id == sampling_place_init ) {
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
    			if ( x.length == 0 && y.length == 0 ) {
    				var url = "index.php";
    	    		var data = { "module":"samplingPlaceGetCoordinate", "sampling_place_id": locid };
    	    		$.ajax ( { url:url, data: data})
    	    		.done (function( data ) {
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

    	function getGenerator() {
    		/*
    		 * Recuperation du script utilisable pour generer l'identifiant metier
    		 */
    		var sti = $("#sample_type_id").val();
       	    if (sti) {
       	    	$.ajax( {
       	    		url: "index.php",
       	    		data: { "module": "sampleTypeGenerator", "sample_type_id": sti }
       	    	})
       	    	.done (function (value) {
       	    		if (value.length > 0) {
       	    			identifier_fn = value;
       	    			$("#identifier_generate").prop("disabled", false);
       	    		} else {
       	    			$("#identifier_generate").prop("disabled", true);
       	    		}
       	    	})
     		}
    	}

			function setGeographicVisibility() {
				var collection_id = $("#collection_id").val();
				$.ajax( {
					url: "index.php",
					data: { "module": "collectionGet", "collection_id": collection_id}
				})
				.done (function (value) {
					value = JSON.parse(value);
					if (value.no_localization == 1) {
						$(".geographic").hide();
					} else {
						$(".geographic").show();
					}
				})
				;
			}

        $("#sample_type_id").change( function() {
       	 getMetadata();
       	 getGenerator();
        });

        $("#collection_id").change(function() {
        	getSamplingPlace();
					setGeographicVisibility();
        });

        $("#sampling_place_id").change (function() {
        	getCoordinatesFromLocalisation();
        });

        /*
         * Lecture initiale
         */
        getMetadata();
        getGenerator();
        getSamplingPlace();
				setGeographicVisibility();

        $('#sampleForm').submit(function(event) {
            if($("#action").val()=="Write"){
            	var error = false;
            	var sample_type_id = $("#sample_type_id").val();
            	if (sample_type_id) {
            		if (sample_type_id.length == 0 ) {
            			error = true;
            		}
            	} else {
            		error = true;
				}
            	var collection_id = $("#collection_id").val();
            	if (collection_id) {
            		if (collection_id.length == 0 ) {
            			error = true;
            		}
            	} else {
            		error = true;
            	}

                $('#metadata').alpaca().refreshValidationState(true);
                if($('#metadata').alpaca().isValid(true)){
                	var value = $('#metadata').alpaca().getValue();
                	 // met les metadata en JSON dans le champ (name="metadata") qui sera sauvegardé en base
                	 $("#metadataField").val(JSON.stringify(value));
                } else {
                   	error = true;
                }
                if (error) {
                	event.preventDefault();
                }

            }

    	});
        $("#reinit").click(function() {
        	$("#wgs84_x").val("");
        	$("#wgs84_y").val("");
        	$("#sampling_date").val("");
        	$("#collection_id").val("");
        	$("#sample_type_id").val("");
        	$("#sampling_place_id").val("");
        	$("#multiple_value").val("");
        	$("#metadataField").val("");
        	showForm([],"");
        	point.setCoordinates ([]);

        });
        $("#identifier_generate").click(function () {
        	if (identifier_fn.length > 0) {
        		$("#identifier").val(eval(identifier_fn));
        	}
        });


        $("#scan_label_action").click(function() {
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
        				 $("#dbuid_origin").val(data["db"]+":"+data["uid"]);
        				 break;
        			 case "id":
        				 $("#identifier").val(data["id"]);
        				 break;
        			 case "prj":
        				 $('#collection_id option[value]="'+data["prj"]+'"]').attr("selected", "selected");
        				 break;
        			 case "col":
        				 $('#collection_id option[value]="'+data["col"]+'"]').attr("selected", "selected");
        				 break;
        			 case "x":
        				 $("#wgs84_x").val(data["x"]);
        				 break;
        			 case "y":
        				 $("#wgs84_y").val(data["y"]);
        				 break;
        			 case "loc":
        				 $('#sampling_place_id option[value]="'+data["loc"]+'"]').attr("selected", "selected");
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
        				$('input[name='+key+']').val(data[key]);

        				break;


        			 }
        		 }
        	} catch (e) {
        		console.error ("Parsing Json error:", e);
        	}
        	}

        });
		$(".position").change(function() {
			setLocalisation();
		});

		function setLocalisation() {
			var x = $("#wgs84_x").val();
			var y = $("#wgs84_y").val();
			if (x.length > 0 && y.length > 0) {
				setPoint(x, y);
			}
		}


		/*
		* call to parent
		*/
		$("#parent_display").on("click keyup", function (){
			if (parent_uid.length > 0) {
				window.location.href = "index.php?module=sampleDisplay&uid="+parent_uid;
			}
		});
		/*
		* Search from parent
		*/
		$("#parent_search").on("keyup", function() {
			var chaine = $("#parent_search").val();
			if (chaine.length > 0) {
				var url = "index.php";
				var is_container = 2;
				var sample_id = $("#sample_id").val();
				var collection = "";
				var type = "";
				$.ajax ( { url:url, method:"GET", data : { module:"sampleSearchAjax", name:chaine }, success : function ( djs ) {
					var options = "";
					try {
						var data = JSON.parse(djs);
						for (var i = 0; i < data.length; i++) {
							if (sample_id != data[i].sample_id) {
								options += '<option value="' + data[i].sample_id +'">' + data[i].uid + "-" + data[i].identifier+"</option>";
								if (i == 0) {
									collection = data[0].collection_name;
									type = data[0].sample_type_name;
									parent_uid = data[0].uid;
								}
							}
						}
					} catch (error) {}
					$("#parent_sample_id").html(options);
					$("#parent_collection").val(collection);
					$("#parent_type").val(type);
					}
				});
			}
		});
		/*
		* Delete parent
		*/
		$("#parent_erase").on("click keyup", function() {
			$("#parent_sample_id").html("");
			$("#parent_collection").val("");
			$("#parent_type").val("");
			parent_uid = "";
		});
		/*
		 * update parent attributes
		 */
		$("#parent_sample_id").change(function() {
			var id = $(this).val();
			if (id.length > 0) {
				$.ajax( { url:"index.php", method:"GET", data : { module: "sampleGetFromIdAjax", sample_id:id},
				success : function (djs) {
					var collection = "";
					var type = "";
					var uid = "";
					try {
						var data = JSON.parse(djs);
						collection = data["collection_name"];
						type = data["sample_type_name"];
						uid = data["uid"];
					} catch (error) {}
					$("#parent_collection").val(collection);
					$("#parent_type").val(type);
					parent_uid = uid;
				}
				});
			}
		});
	});
</script>

<h2>{t}Création - modification d'un échantillon{/t}</h2>
<div class="row col-md-12">
	<a href="index.php?module={$moduleListe}">
		<img src="display/images/list.png" height="25">
		{t}Retour à la liste des échantillons{/t}
	</a>
	{if $data.uid > 0}
		<a href="index.php?module=sampleDisplay&uid={$data.uid}">
			<img src="display/images/box.png" height="25">{t}Retour au détail{/t}
		</a>
	{elseif $sample_parent_uid > 0}
		<a href="index.php?module=sampleDisplay&uid={$sample_parent_uid}">
			<img src="display/images/box.png" height="25">{t}Retour au détail{/t}
		</a>
	{/if}
</div>

{if $data.sample_id == 0}
	<button type="button" class="btn btn-warning" id="reinit">{t}Réinitialiser les champs{/t}</button>
{/if}
<div class="row">
	<div class="col-md-6">
		<form class="form-horizontal protoform" id="sampleForm" method="post" action="index.php" onsubmit="return(testScan());">
			<input type="hidden" id="sample_id" name="sample_id" value="{$data.sample_id}">
			<input type="hidden" name="moduleBase" value="sample">
			<input type="hidden" id="action" name="action" value="Write">
			<!--input type="hidden" name="parent_sample_id" value="{$data.parent_sample_id}"-->
			<input type="hidden" name="metadata" id="metadataField" value="{$data.metadata}">
			<div class="form-group center">
				<button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
				{if $data.sample_id > 0 }
					<button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
				{/if}
			</div>
			<fieldset>
				<legend>{t}Échantillon parent{/t}</legend>
				<div class="form-group">
					<label for="parent_sample_id" class="control-label col-md-4"> {t}Parent :{/t}</label>
					<div class="col-md-2">
						<input id="parent_search" class="form-control" placeholder="{t}UID ou identifiant{/t}">
					</div>
					<div class="col-md-4">
						<select id="parent_sample_id" name="parent_sample_id">
							{if $data.parent_sample_id > 0}
								<option value="{$data.parent_sample_id}">
									{$parent_sample.uid} {$parent_sample.identifier}
								</option>
							{/if}
						</select>
					</div>
					<div id="parent_display" class="col-md-1">
						<img  src="display/images/zoom.png" height="25" title="{t}Afficher le parent{/t}">
					</div>
					<div id="parent_erase" class="col-md-1">
						<img  src="display/images/eraser.png" height="25" title="{t}Supprimer le parent{/t}">
					</div>
				</div>
				<div class="form-group">
					<label for="parent_collection" class="control-label col-md-4">{t}Collection :{/t}</label>
					<div class="col-md-8">
						<input id="parent_collection" class="form-control" readonly value="{$parent_sample.collection_name}">
					</div>
				</div>
				<div class="form-group">
					<label for="parent_type" class="control-label col-md-4">{t}Type :{/t}</label>
					<div class="col-md-8">
						<input id="parent_type" class="form-control" readonly value="{$parent_sample.sample_type_name}">
					</div>
				</div>
			</fieldset>
			<fieldset>
				<legend>{t}Données générales{/t}</legend>
				<div class="form-group">
					<label for="scan_label" class="control-label col-md-4">{t}Scannez l'étiquette existante :{/t}</label>
					<div class="col-md-5">
						<input id="scan_label" class="form-control" placeholder="{t}Placez le curseur dans cette zone et scannez l'étiquette{/t}">
					</div>
					<div class="col-md-3">
						<button class="btn btn-info" type="button" id="scan_label_action">{t}Mettre à jour les champs{/t}</button>
					</div>
				</div>
				<div class="form-group">
					<label for="uid" class="control-label col-md-4">{t}UID :{/t}</label>
					<div class="col-md-8">
						<input id="uid" name="uid" value="{$data.uid}" readonly class="form-control" title="{t}identifiant unique dans la base de données{/t}">
					</div>
				</div>
				<div class="form-group">
					<label for="appli" class="control-label col-md-4">{t}Identifiant ou nom :{/t}</label>
					<div class="col-md-6">
						<input id="identifier" type="text" name="identifier" class="form-control" value="{$data.identifier}" autofocus >
					</div>
					<div class="col-md-2">
						<button class="btn btn-info" type="button" id="identifier_generate" disabled
					title="{t}Générez l'identifiant à partir des informations saisies{/t}">{t}Générer{/t}</button>
					</div>
				</div>
				<div class="form-group">
					<label for="object_status_id" class="control-label col-md-4"><span class="red">*</span> {t}Statut :{/t}</label>
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
					<label for="collection_id" class="control-label col-md-4"><span class="red">*</span> {t}Collection :{/t}</label>
					<div class="col-md-8">
						<select id="collection_id" name="collection_id" class="form-control" autofocus>
							{section name=lst loop=$collections}
								<option value="{$collections[lst].collection_id}" {if $data.collection_id == $collections[lst].collection_id}selected{/if}>
									{$collections[lst].collection_name}
								</option>
							{/section}
						</select>
					</div>
				</div>
				<div class="form-group">
					<label for="referentId"  class="control-label col-md-4">{t}Référent de l'échantillon :{/t}</label>
					<div class="col-md-8">
						<select id="referentId" name="referent_id" class="form-control">
							<option value="" {if $data.referent_id == ""}selected{/if}>Choisissez...</option>
							{foreach $referents as $referent}
									<option value="{$referent.referent_id}" {if $data.referent_id == $referent.referent_id}selected{/if}>
									{$referent.referent_name}
									</option>
							{/foreach}
						</select>
					</div>
				</div>
				<div class="form-group">
					<label for="sample_type_id" class="control-label col-md-4"><span class="red">*</span> {t}Type :{/t}</label>
					<div class="col-md-8">
						<select id="sample_type_id" name="sample_type_id" class="form-control">
							<option disabled selected value >{t}Choisissez...{/t}</option>
							{section name=lst loop=$sample_type}
								<option value="{$sample_type[lst].sample_type_id}" {if $sample_type[lst].sample_type_id == $data.sample_type_id}selected{/if}>
									{$sample_type[lst].sample_type_name}
									{if $sample_type[lst].multiple_type_id > 0}
										/{$sample_type[lst].multiple_type_name} : {$sample_type[lst].multiple_unit}
									{/if}
								</option>
							{/section}
						</select>
					</div>
				</div>
				<div class="form-group">
					<label for="dbuid_origin" class="control-label col-md-4">{t}Base de données et UID d'origine :{/t}</label>
					<div class="col-md-8">
						<input id="dbuid_origin" class="form-control" name="dbuid_origin" value="{$data.dbuid_origin}" placeholder="{t}db:uid. Exemple: col:125{/t}">
					</div>
				</div>
				<div class="form-group geographic">
					<label for="campaign_id" class="control-label col-md-4">{t}Campagne de prélèvement :{/t}</label>
					<div class="col-md-8">
						<select id="campaign_id" name="campaign_id" class="form-control">
							<option value="" {if $data.campaign_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
							{foreach $campaigns as $campaign}
								<option value="{$campaign.campaign_id}" {if $data.campaign_id == $campaign.campaign_id}selected{/if}>
									{$campaign.campaign_name}
								</option>
							{/foreach}
						</select>
					</div>
				</div>
				<div class="form-group geographic">
				<label for="country_id" class="control-label col-md-4 lexical" data-lexical="country">{t}Pays de collecte :{/t}</label>
					<div class="col-md-8">
						<select id="country_id" name="country_id" class="form-control">
							<option value="" {if $data.country_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
							{foreach $countries as $country}
								<option value="{$country.country_id}" {if $data.country_id == $country.country_id}selected{/if}>
									{$country.country_name}
								</option>
							{/foreach}
						</select>
					</div>
				</div>
				<div class="form-group geographic">
				<label for="country_origin_id" class="control-label col-md-4 lexical" data-lexical="country_origin">{t}Pays de provenance :{/t}</label>
					<div class="col-md-8">
						<select id="country_origin_id" name="country_origin_id" class="form-control">
							<option value="" {if $data.country_origin_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
							{foreach $countries as $country}
								<option value="{$country.country_id}" {if $data.country_origin_id == $country.country_id}selected{/if}>
									{$country.country_name}
								</option>
							{/foreach}
						</select>
					</div>
				</div>
				<div class="form-group geographic">
					<label for="sampling_place_id" class="control-label col-md-4">{t}Lieu de prélèvement :{/t}</label>
					<div class="col-md-8">
						<select id="sampling_place_id" name="sampling_place_id" class="form-control ">
						</select>
					</div>
				</div>
				<div class="form-group geographic">
					<label for="wy" class="control-label col-md-4">{t}Latitude :{/t}</label>
					<div class="col-md-8" id="wy">
						{t}Format sexagesimal (45°01,234N) :{/t}<input id="latitude" placeholder="45°01,234N" autocomplete="off" class="form-control">
						{t}Format décimal (45.081667) :{/t}<input id="wgs84_y" name="wgs84_y" placeholder="45.081667" autocomplete="off" class="form-control taux position" value="{$data.wgs84_y}">
					</div>
				</div>
				<div class="form-group geographic">
					<label for="wx" class="control-label col-md-4">{t}Longitude :{/t}</label>
					<div class="col-md-8" id="wx">
						{t}Format sexagesimal (0°01,234W) :{/t}
						<input id="longitude" placeholder="0°01,234W" autocomplete="off" class="form-control">
						{t}Format décimal (-0.081667) :{/t}
						<input id="wgs84_x" name="wgs84_x"  placeholder="-0.081667" autocomplete="off" class="form-control taux position" value="{$data.wgs84_x}">
					</div>
				</div>
				<div class="form-group geographic">
					<label for="location_accuracy"  class="control-label col-md-4 lexical" data-lexical="accuracy">{t}Précision de la localisation (en mètres) :{/t}</label>
					<div class="col-md-8">
						<input id="sampling_date" class="form-control taux" name="location_accuracy" value="{$data.location_accuracy}">
					</div>
				</div>
				<div class="form-group">
					<label for="sampling_date"  class="control-label col-md-4">{t}Date de création/échantillonnage de l'échantillon :{/t}</label>
					<div class="col-md-8">
						<input id="sampling_date" class="form-control datetimepicker" name="sampling_date" value="{$data.sampling_date}">
					</div>
				</div>
				<div class="form-group">
					<label for="sample_creation_date"  class="control-label col-md-4">{t}Date d'import dans la base de données :{/t}</label>
					<div class="col-md-8">
						<input id="sample_creation_date" class="form-control" name="sample_creation_date" readonly value="{$data.sample_creation_date}">
					</div>
				</div>
				<div class="form-group">
					<label for="expiration_date"  class="control-label col-md-4">{t}Date d'expiration de l'échantillon :{/t}</label>
					<div class="col-md-8">
						<input id="expiration_date" class="form-control datepicker" name="expiration_date"  value="{$data.expiration_date}">
					</div>
				</div>
				<div class="form-group">
					<label for="object_comment" class="control-label col-md-4">{t}Commentaire :{/t}</label>
					<div class="col-md-8">
						<textarea class="form-control" rows="3" id="object_comment" name="object_comment">{$data.object_comment}</textarea>
					</div>
				</div>
			</fieldset>
			<fieldset>
				<legend>{t}Sous-échantillonnage (si le type le permet){/t}</legend>
				<div class="form-group">
					<label for="multiple_value"  class="control-label col-md-4">
					{t 1=$data.multiple_type_name 2=$data.multiple_unit}Quantité initiale de sous-échantillons (%1:%2) :{/t}</label>
					<div class="col-md-8">
						<input id="multiple_value" class="form-control taux" name="multiple_value" value="{$data.multiple_value}">
					</div>
				</div>
			</fieldset>
			<fieldset>
				<legend>{t}Jeu de métadonnées{/t}</legend>
				<div class="form-group">
					<div class="col-md-10 col-sm-offset-1">
						<div id="metadata"></div>
					</div>
				</div>
			</fieldset>
			<fieldset>
				<legend>{t}Informations diverses{/t}</legend>
				<div class="form-group">
					<label for="uuid"  class="control-label col-md-4">{t}UID universel (UUID) :{/t}</label>
					<div class="col-md-8">
						<input id="expiration_date" class="form-control uuid" name="uuid"  value="{$data.uuid}">
					</div>
				</div>
				{if $data.sample_id > 0}
					<div class="form-group">
						<label for="trashed" class="col-md-4 control-label">{t}Échantillon en attente de suppression (mis à la corbeille) :{/t}</label>
						<div class="col-md-8" id="trashed">
							<div class="radio-inline">
							<label>
								<input type="radio" name="trashed" id="trashed1" value="1" {if $data.trashed == 1}checked{/if}>
								{t}oui{/t}
							</label>
							</div>
							<div class="radio-inline">
								<label>
									<input type="radio" name="trashed" id="trashed0" value="0" {if $data.trashed == 0}checked{/if}>
									{t}non{/t}
								</label>
							</div>
						</div>
					</div>
				{/if}
			</fieldset>
			<div class="form-group center">
				<button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
				{if $data.sample_id > 0 }
					<button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
				{/if}
			</div>
		</form>
	</div>
	<div class="col-md-6 geographic">
		{include file="gestion/objectMapDisplay.tpl"}
	</div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
