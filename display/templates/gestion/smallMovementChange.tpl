<script src="{$display}/bower_components/qcode-decoder/build/qcode-decoder.min.js"></script>
<script>
$(document).ready(function() { 
	'use strict';
	var destination = "object";
	var video = document.querySelector("#reader");
	var is_read = false;
	var snd = new Audio("{$display}/images/sound.ogg"); 
    var qr = new QCodeDecoder();
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
	var db = "{$db}";
	/*
	 * Traitement des recherches
	 */
	$("#object_search").on ('keyup change', function () { 
		var val = getVal($("#object_search").val());
		if (val.toString().length > 0) {
			search("objectGetDetail", "object_uid", val , false );
		}
	});
	
	$("#container_search").on('keyup change', function () { 
		var val = getVal($("#container_search").val());
		if (val.toString().length > 0) {
			search("objectGetDetail","container_uid", val, true );
		}
	});
	
	$("#object_uid").on ("change", function () {
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
		var url = "index.php";
		var chaine ;
		var options = "";
		if (is_container == true) {
			mouvements = {};
		}
		$.ajax ( { url:url, method:"GET", data : { module:module, uid:value, is_container:is_container, is_partial:true }, success : function ( djs ) {
			var data = JSON.parse(djs);
			for (var i = 0; i < data.length; i++) {
				var uid = data[i].uid;
				if (module == "objectGetLastEntry") {
					uid = data[i].parent_uid;
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
	
});
</script>

<div class="row">
	<div class="col-xs-12 col-md-6">
		<form class="form-horizontal protoform" id="smallMovement"	method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="smallMovement"> 
			<input type="hidden" name="action" value="Write"> 
			<input type="hidden" name="storage_id" value="0"> 
			<input type="hidden" id="movement_type_id" name="movement_type_id" value="1">
			
			<div class="col-xs-12 col-md-6">
				<input id="object_search" type="text" name="object_search" placeholder="Objet cherché"
							value="" class="form-control input-lg" autofocus autocomplete="off" >
			</div>
			<div class="col-xs-12 col-md-6">
				<select id="object_uid" name="object_uid" class="form-control input-lg">
				
				</select>
			</div>
			<div class="col-xs-12 col-md-6">
			<input id="container_search" type="text" name="container_search" placeholder="Container cherché"
							value="" class="form-control input-lg" autofocus autocomplete="off" >
			</div>
			<div class="col-xs-12 col-md-6">
				<select id="container_uid" name="container_uid" class="form-control input-lg">
				</select>
			</div>	
			<div class="col-xs-12 col-md-6">
			<div class="row">
				<div class="col-xs-2">Col:</div>
				<div class="col-xs-4">
				<input id="col" name="column_number" value="1" class="form-control input-lg">
				</div>
				<div class="col-xs-2">Line:</div>
				<div class="col-xs-4">
				<input id="line" name="line_number" value="1" class="form-control input-lg">
				</div>
			</div>
			</div>
			<div class="col-xs-12 col-md-6">
					<select id="storage_reason_id" name="storage_reason_id" class="form-control input-lg">
					<option value="" {if $storage_reason_id == ""}selected{/if}>Motif de sortie...</option>
					{section name=lst loop=$storageReason}
					<option value="{$storageReason[lst].storage_reason_id}" {if $storage_reason_id == $storageReason[lst].storage_reason_id}selected{/if}>
					{$storageReason[lst].storage_reason_name}
					</option>	
					{/section}		
					</select>
			</div>
			<div class="row">	
			<div class="col-xs-12 center">
			 <button id="entry" class="btn btn-info input-lg">Entrée</button>
			 <button id="exit" class="btn btn-danger input-lg">Sortie</button>
			</div>
			</div>
			
		</form>
	</div>
</div>	
<!-- Rajout pour la lecture optique -->
<div class="row" id="optical">
	<fieldset>
		<legend>Lecture par la caméra de l'ordinateur ou du smartphone (utiliser firefox)</legend>
		<div class="col-xs-12 col-md-6">
			<div class="form-horizontal protoform">
				<div class="form-group center">
					<button id="start2" class="btn btn-success">Lecture de
						l'objet à entrer</button>
						<button id="start" class="btn btn-success">Lecture du
						container</button>
					<button id="stop" class="btn btn-danger">Arrêter la
						lecture</button>
				</div>
			</div>
		</div>
		<div class="col-xs-12 col-md-6 center">
			<video id="reader" autoplay width="320" height="240" poster="{$display}/images/webcam.png"></video>
		</div>
		
	</fieldset>
</div>