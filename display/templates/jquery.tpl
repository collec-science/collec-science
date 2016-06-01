<!-- script type="text/javascript" charset="utf-8" src="display/javascript/DataTables-1.9.4/media/js/jquery.js"></script-->
<script type="text/javascript" charset="utf-8" src="display/javascript/jquery-1.12.4.min.js"></script>
<script type="text/javascript" charset="utf-8" src="display/javascript/jquery-ui.min.js"></script>
<script type="text/javascript" charset="utf-8" src="display/javascript//DataTables-1.9.4/media/js/jquery.dataTables.js"></script>
<script type="text/javascript" charset="utf-8" src="display/javascript/DataTables-1.9.4/extras/TableTools/media/js/TableTools.js"></script>
<script type="text/javascript" charset="utf-8" src="display/javascript/DataTables-1.9.4/extras/TableTools/media/js/ZeroClipboard.js"></script>
<script type="text/javascript" charset="utf-8" src="display/javascript/carhartl-jquery-cookie-3caf209/jquery.cookie.js"></script>
<style type="text/css" > 
@import "display/CSS/TableTools.css";
@import "display/CSS/dataTables.css";
@import "display/CSS/jquery-ui.min.css";
@import "display/CSS/jquery-ui.theme.min.css";
</style>
<!--  Definition des balises titre et du datepicker par defaut -->
<script>
$(document).ready(function() {
	$('.taux,nombre').attr('title','{$LANG[message].34}');
	<!--$('.taux').attr('placeholder', '100, 95.5...');-->
	$(".date").datepicker( { dateFormat: "dd/mm/yy" } );
	$('.taux').attr( {
		'pattern': '[0-9]+(\.[0-9]+)?',
		'maxlength' : "10"
	} );
	$('.nombre').attr( {
		'pattern': '[0-9]+',
		'maxlength' : "10"
	}
	);
	$('.timepicker').attr('pattern', '[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]');
} ) ;
</script>