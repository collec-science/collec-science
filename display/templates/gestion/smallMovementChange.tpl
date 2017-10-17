<script>
$(document).ready(function() { 
	var mouvements = [];
	/*
	 * Traitement des recherches
	 */
	$("#object_search").on ('keyup change', function () { 
		search("objectGetDetail", "object_uid", $("#object_search").val(), false );
	});
	$("#container_search").on('keyup change', function () { 
		search("objectGetDetail","container_uid", $("#container_search").val(), true );
	});
	
	$("#object_uid").on ("change", function () {
		search ("objectGetLastEntry", "container_uid", $("#object_uid").val(), false);
	});
	
	function search (module, fieldid, value, is_container) {
		var url = "index.php";
		var chaine ;
		var options = "";
		if (is_container == true) {
			mouvements = [];
		}
		$.ajax ( { url:url, method:"GET", data : { module:module, uid:value, is_container:is_container, is_partial:true }, success : function ( djs ) {
			var data = JSON.parse(djs);
			for (var i = 0; i < data.length, i++) {
				options += '<option value="' + data[i].uid +'">' + data[i].uid + " - " data[i].identifier; 
				if (module == "objectGetLastEntry") {
					options += " col:"+data[i].column_number+" line:"+data[i].line_number;
				}
				options += "</option>";
				if (is_container == true) {
					mouvements [data[i].uid] = ["col"]
				}
			} 
			$("#"+fieldid).html(options);
		}
		});
	}
	
	/*
	 * Declenchement des mouvements
	 */
	 $("#entry").click(function () { 
		 /*
		  * Verification qu'un objet et un container soient selectionnes
		  */
		  var ouid = $("#object_uid").val();
		 var cuid = $("#container_uid").val();
		 if (ouid.length > 0 && couid.length > 0) {
			 $("#movement_type_id").val("1");
			 $("#smallMovement").submit();
		 }
		 
	 });
	
	$("#exit").click(function () { 
		/*
		  * Verification qu'un objet soit selectionne
		  */
		 var ouid = $("#object_uid").val();
		 if (ouid.length > 0) {
			 $("#movement_type_id").val("2");
			 $("#smallMovement").submit();
		 }
	});
	
});
</script>

<div class="row">
	<div class="col-xs-12">
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
			<div class="col-xs-6">
			 <button id="entry" class="btn btn-success">Entrée</button>
			</div>
			<div class="col-xs-6">
			 <button id="exit" class="btn btn-danger">Sortie</button>
			</div>
			
		</form>
	</div>
</div>	