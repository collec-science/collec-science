{* Mouvements > Mouvements petit terminal > *}
<script src="{$display}/bower_components/qcode-decoder/build/qcode-decoder.min.js"></script>
<script>
var is_scan = false;
function testScan() {
	if (is_scan) {
		return false;
	} else {
		return true;
	}
}


		

$(document).ready(function() { 
	'use strict';
	var destination = "object";
	var video = document.querySelector("#reader");
	var is_read = false;
	var snd = new Audio("{$display}/images/sound.ogg"); 
    var qr = new QCodeDecoder();
    var timer;
    var timer_duration = 500;
    if (!(qr.isCanvasSupported() && qr.hasGetUserMedia())) {
        //alert('Your browser doesn\'t match the required specs.');
        throw new Error('Canvas and getUserMedia are required');
        console.log ('Canvas and getUserMedia are required');
        $("#optical").hide();
      }
    function resultHandler (err, result) {
        if (err) {
          return console.log(err.message);
        }
        $("#"+destination).val(result);
        snd.play();
        $("#"+destination).change();
      }
    function readEnable() {
		/*
		 * Fonction declenchant la lecture des qrcodes
		 */
		is_read = true;
		 qr.decodeFromCamera(video, resultHandler);
	}
	var mouvements = {};
	var objets = {};
	
	var db = "{$db}";
	/*
	 * Traitement des recherches
	 */
	$("#object_search").on ('keyup change', function () { 
		clearTimeout(timer);
		timer = setTimeout(object_search, timer_duration);
	});
	
	function object_search() {
		var val = getVal($("#object_search").val());
		if (val) {
			search("objectGetDetail", "object_uid", val , false );
		}
	}
	
	function container_search() {
		var val = getVal($("#container_search").val());
		if (val) {
			search("objectGetDetail","container_uid", val, true );
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
	
	$("#object_uid").on ("change", function () {
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
		
		search ("objectGetLastEntry", "container_uid", $("#object_uid").val(), false);
	});
	$('#start').click(function() {
		destination = "container_search";
		if (is_read == false) {
			readEnable();
		}
	});
	$('#start2').click(function() {
		destination = "object_search";
		if (is_read == false) {
			readEnable();
		}
	});
	$('#stop').click(function() {
		//$('#reader').html5_qrcode_stop();
		qr.stop();
		is_read == false;
	});
	/*
	 * Activation automatique de la lecture optique
	 */
	{if $read_optical == 1}
	readEnable();
	{/if}
	
	function getVal(val) {
		/*
		 * Extraction de la valeur - cas notamment de la lecture par douchette
		 */
		val = val.trim();
		
		var firstChar = val.substring(0,1);
		var lastChar = val.substring (vallength - 1, vallength);
		if ( firstChar == "[" || firstChar == String.fromCharCode(123)) {
			var vallength = val.length;
			var lastChar = val.substring (vallength - 1, vallength);
			if (lastChar == "]" || lastChar == String.fromCharCode(125) ) {
				val = extractUidValFromJson(val);
			} else {
				val = "";
			}
		} else if (val.substring(0,4) == "http" || val.substring(0,3) == "htp") {
			var elements = valeur.split("/");
			var nbelements = elements.length ;
			if (nbelements > 0) {
				val = elements[nbelements - 1];
			}
		}
		return val;
	}
	
	function search (module, fieldid, value, is_container) {
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
			 	value = value.replace ( /]C1/g, "");
			 }
		var url = "index.php";
		var chaine ;
		var options = "";
		if (is_container == true) {
			mouvements = {};
		} else {
			objets = {};
		}
		console.log(value);
		$.ajax ( { url:url, method:"GET", data : { module:module, uid:value, is_container:is_container, is_partial:true }, success : function ( djs ) {
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
				options += '<option value="' + uid +'">' + uid + "-" + data[i].identifier; 
				if (module == "objectGetLastEntry") {
					options += " col:"+data[i].column_number+" line:"+data[i].line_number;
					mouvements[uid] = {};
					mouvements [uid]["col"]=data[i].column_number;
					mouvements[uid]["line"]=data[i].line_number;
				}
				options += "</option>";
			} 
			$("#"+fieldid).html(options);
			$("#"+fieldid).change();
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
			return data["db"]+":"+data["uid"];
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
		 	$("#smallMovement").submit();
		 } else {
			 event.preventDefault();
		 }
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
			 $("#smallMovement").submit();
		 } else {
			 event.preventDefault();
		 }
	});
	/*
	 * Remise a zero des zones de recherche
	 */
	$("#clear_container_search").click(function(event) { 
		$("#container_search").val("");
		$("#container_uid").empty();
		$("#container_search").focus();
	});
	$("#clear_object_search").click(function(event) { 
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
		 	if (valobj.length == 0) {
				 event.preventDefault();
			 }
		 }
	 });
	
	
});
</script>

<div class="row">
	<div class="col-xs-12 col-md-6">
		<form class="form-horizontal protoform" id="smallMovement"	method="post" action="index.php" onsubmit="return(testScan());">
			<input type="hidden" name="moduleBase" value="smallMovement"> 
			<input type="hidden" name="action" value="Write"> 
			<input type="hidden" name="movement_id" value="0"> 
			<input type="hidden" id="movement_type_id" name="movement_type_id" value="1">
			
			<div class="col-xs-12 col-md-6">
				<div class="row">
					<div class="col-xs-9 col-md-8">
						<input id="object_search" type="text" name="object_search" placeholder="{t}Objet à déplacer / sortir{/t}"
									value="" class="form-control input-lg" autofocus autocomplete="off" >
					</div>
					<div class="col-xs-3 col-md-4">
						<button id="clear_object_search" class="btn btn-block  btn-info" type="button">{t}Effacer{/t}</button>
					</div>
					<div class="col-xs-12 col-md-12">
						<select id="object_uid" name="object_uid" class="form-control input-lg">
						</select>
					</div>
				    <div class="col-xs-3 col-md-12">
						<input id="position_stock" class="form-control input-lg" disabled value="">
					</div>
					<div class="col-xs-6 col-md-8">
						<select id="movement_reason_id" name="movement_reason_id" class="form-control input-lg">
							<option value="" {if $movement_reason_id == ""}selected{/if}>{t}Motif du déstockage...{/t}</option>
							{section name=lst loop=$movementReason}
							<option value="{$movementReason[lst].movement_reason_id}" {if $movement_reason_id == $movementReason[lst].movement_reason_id}selected{/if}>
							{$movementReason[lst].movement_reason_name}
							</option>	
							{/section}		
						</select>
					</div>
					<div class="col-xs-3 col-md-4">	 
					 	<button id="exit" class="btn btn-block btn-danger input-lg" type="button">{t}Sortir{/t}</button>
					</div>
					<div class="col-xs-12 col-md-0">	 
					 	<br/>
					</div>
				</div>
			</div>
			<div class="col-xs-12 col-md-6">
				<div class="row">
					<div class="col-xs-9 col-md-8">
					<input id="container_search" type="text" name="container_search" placeholder="{t}Contenant de destination{/t}"
									value="" class="form-control input-lg" autofocus autocomplete="off" >
					</div>
					<div class="col-xs-3 col-md-4">
						<button id="clear_container_search" class="btn btn-block btn-info" type="button">{t}Effacer{/t}</button>
					</div>
					<div class="col-xs-12 col-md-12">
						<select id="container_uid" name="container_uid" class="form-control input-lg">
						</select>
					</div>
					<div class="col-xs-2 col-md-2">{t}Col:{/t}</div>
					<div class="col-xs-4 col-md-4">
						<input id="col" name="column_number" value="1" class="form-control input-lg">
					</div>
					<div class="col-xs-2 col-md-2">{t}Ligne:{/t}</div>
					<div class="col-xs-4 col-md-4">
						<input id="line" name="line_number" value="1" class="form-control input-lg">
					</div>
					<div class="col-xs-12 col-md-12">
			 			<button id="entry" class="btn btn-block btn-info input-lg" type="button">{t}Déplacer dans le contenant{/t}</button>
					</div>
				</div>
			</div>
			<div class="row">

			</div>
		</form>
	</div>
</div>	
<!-- Rajout pour la lecture optique -->
<div class="row" id="optical">
	<fieldset>
		<legend>{t}Lecture par la caméra de l'ordinateur ou du smartphone (utiliser Firefox){/t}</legend>
		<div class="col-xs-12 col-md-6">
			<div class="form-horizontal protoform">
				<div class="form-group center">
					<button id="start2" class="btn btn-success" type="button">{t}Lecture de l'objet à déplacer{/t}</button>
						<button id="start" class="btn btn-success">{t}Lecture du contenant{/t}</button>
					<button id="stop" class="btn btn-danger">{t}Arrêter la lecture{/t}</button>
				</div>
			</div>
		</div>
		<div class="col-xs-12 col-md-6 center">
			<video id="reader" autoplay width="320" height="240" poster="{$display}/images/webcam.png"></video>
		</div>
		
	</fieldset>
</div>