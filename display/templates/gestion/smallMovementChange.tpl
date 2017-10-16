<script>
$(document).ready(function() { 
	$("#object_search").change( function () { 
		var url = "index.php";
		var chaine ;
		$.ajax ( { url:url, method:"GET", data : { module:"objectGetDetail", uid:uid, is_container:is_container, is_partial:true }, success : function ( djs ) {
			var data = JSON.parse(djs);
			if (data.length > 0) {
				/*
				 * Preparation de la liste
				 */
				
				if (!isNaN(data[0].uid)) {
					var id = "", type="";
					if (data[0].identifier) {
						id = data[0].identifier;
					}
					if (data[0].type_name) {
						type = " (" + data[0].type_name+")";
					}
					chaine = id + type ;
					console.log("Détail associé à l'UID : " + chaine);
					$("#"+champ+"_uid").val(data[0].uid);
					$("#"+champ+"_detail").val(chaine);
				} else {
					$("#"+champ+"_uid").val("");
					$("#"+champ+"_detail").val("");
				}
			} else {
				/*
				 * vidage des champs
				 */
				$("#"+champ+"_uid").val("");
				$("#"+champ+"_detail").val("");
			}
			/*
			 * Reinitialisation de la zone de lecture
			 */
			 $("#valeur-scan").val("");
		}
		} ); 
	});	
	
}
</script>

<div class="row">
	<div class="col-xs-12">
		<form class="form-horizontal protoform fastform" id="fastInputForm"	method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="smallMovement"> 
			<input type="hidden" name="action" value="Write"> 
			<input type="hidden" name="storage_id" value="0"> 
			
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