<script type="text/javascript" charset="utf-8" src="display/javascript/jquery-1.12.4.min.js"></script>
<script type="text/javascript" charset="utf-8" src="display/javascript/jquery-ui.min.js"></script>

<script type="text/javascript" charset="utf-8" src="display/javascript/jquery-ui-1.12.0.custom/jquery-ui.min.js"></script>
<script type="text/javascript" charset="utf-8" src="display/javascript/jquery-ui-1.12.0.custom/i18n/datepicker-fr.js"></script>
<script type="text/javascript" charset="utf-8" src="display/javascript/jquery-ui-1.12.0.custom/i18n/datepicker-en.js"></script>
<script type="text/javascript" charset="utf-8" src="display/javascript/jquery-timepicker-addon/jquery-ui-timepicker-addon.min.js"></script>
<script type="text/javascript" charset="utf-8" src="display/javascript/jquery-timepicker-addon/i18n/jquery-ui-timepicker-fr.js"></script>


<script type="text/javascript" charset="utf-8" src="display/javascript/carhartl-jquery-cookie-3caf209/jquery.cookie.js"></script>

<!-- Datatables -->
<link rel="stylesheet" type="text/css" href="display/javascript/DataTables-1.10.12/media/css/jquery.dataTables.min.css" />
<link rel="stylesheet" type="text/css" href="display/javascript/DataTables-1.10.12/media/css/dataTables.bootstrap.min.css" />
<script type="text/javascript" src="display/javascript/DataTables-1.10.12/media/js/jquery.dataTables.min.js" ></script>
<script type="text/javascript" src="display/javascript/DataTables-1.10.12/media/js/dataTables.bootstrap.min.js"></script>


<style type="text/css" > 
@import "display/CSS/TableTools.css";
@import "display/CSS/dataTables.css";
@import "display/CSS/jquery-ui.min.css";
@import "display/CSS/jquery-ui.theme.min.css";
@import "display/javascript/jquery-timepicker-addon/jquery-ui-timepicker-addon.min.css";
</style>
<!--  Definition des balises titre et du datepicker par defaut -->
<script>
$(document).ready(function() {
	$('.taux,nombre').attr('title','{$LANG[message].34}');
	<!--$('.taux').attr('placeholder', '100, 95.5...');-->
	$('.taux').attr( {
		'pattern': '[0-9]+(\.[0-9]+)?',
		'maxlength' : "10"
	} );
	$('.nombre').attr( {
		'pattern': '[0-9]+',
		'maxlength' : "10"
		}
	);
	$('.datatable').DataTable({
		language : {
			url : 'display/javascript/fr_FR.json'
		}
	});

	$('.timepicker').attr('pattern', '[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]');
	$('.datepicker').datetimepicker({ 
		timepicker:false,
		 format:'d/m/Y'
	});
	$('.datetimepicker').datetimepicker({ 
		format:'d/m/Y H:i'
	});
	$.datepicker.setDefaults($.datepicker.regional['fr']);
	$(".date").datepicker( { dateFormat: "dd/mm/yy" } );
	$('.timepicker').attr('pattern', '[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]');
	$.timepicker.setDefaults($.timepicker.regional['fr']);
	$('.datetimepicker').datetimepicker({ 
		dateFormat: "dd/mm/yy",
		timeFormat: 'HH:mm:ss',
		timeInput: true
	})

	
} ) ;
</script>