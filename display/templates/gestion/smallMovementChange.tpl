<script>
$(document).ready(function() { 
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
							value="" class="form-control" autofocus autocomplete="off" >
			</div>
			<div class="col-xs-12 col-md-6">
				<select id="object_uid" name="object_uid" class="form-control">
				
				</select>
			</div>
			<div class="col-xs-12 col-md-6">
			<input id="container_search" type="text" name="container_search" placeholder="Container cherché"
							value="" class="form-control" autofocus autocomplete="off" >
			</div>
			<div class="col-xs-12 col-md-6">
				<select id="container_uid" name="container_uid" class="form-control">
				</select>
			</div>	
			<div class="col-xs-12 col-md-6">
			<div class="row">
				<div class="col-xs-2">Col:</div>
				<div class="col-xs-4">
				<input id="col" name="column_number" value="1" class="form-control">
				</div>
				<div class="col-xs-2">Line:</div>
				<div class="col-xs-4">
				<input id="line" name="line_number" value="1" class="form-control">
				</div>
			</div>
			</div>
			<div class="col-xs-12 col-md-6">
					<select id="storage_reason_id" name="storage_reason_id" class="form-control">
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
			 <button id="entry" class="btn btn-info">Entrée</button>
			 <button id="exit" class="btn btn-danger">Sortie</button>
			</div>
			</div>
			
		</form>
	</div>
</div>	