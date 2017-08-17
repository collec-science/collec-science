<!-- Jquery -->
<script src="/display/javascript/jquery-1.12.4.min.js"></script>
<!-- script src="/display/javascript/jquery-ui.min.js"></script-->

<!-- Bootstrap -->
<link rel="stylesheet"	href="/display/javascript/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet"	href="/display/javascript/bootstrap/css/bootstrap-theme.min.css">
<script	src="/display/javascript/bootstrap/js/bootstrap.min.js"></script>

<!--handlebars -->
<script type="text/javascript" src="display/javascript/alpaca/js/handlebars.js"></script>

<!--alpaca -->
<script type="text/javascript" src="display/javascript/alpaca/js/alpaca.js"></script>
<link type="text/css" href="display/javascript/alpaca/css/alpaca.css" rel="stylesheet">

<!-- extension pour le menu -->
<script src="/display/javascript/smartmenus-1.0.1/jquery.smartmenus.min.js" type="text/javascript"></script>
<script src="/display/javascript/smartmenus-1.0.1/addons/bootstrap/jquery.smartmenus.bootstrap.min.js" type="text/javascript"></script>

<!-- Datatables -->
<link rel="stylesheet" type="text/css" href="/display/javascript/DataTables-1.10.15/media/css/jquery.dataTables.min.css" />
<link rel="stylesheet" type="text/css" href="/display/javascript/DataTables-1.10.15/media/css/dataTables.bootstrap.min.css" />
<script type="text/javascript" src="/display/javascript/DataTables-1.10.15/media/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="/display/javascript/DataTables-1.10.15/media/js/dataTables.bootstrap.min.js"></script>
<!-- Boutons d'export associes aux datatables - classe datatable-export -->
<script type="text/javascript" src="/display/javascript/DataTables-1.10.15/extensions/Buttons/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="/display/javascript/DataTables-1.10.15/extensions/Buttons/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="/display/javascript/DataTables-1.10.15/extensions/Buttons/js/buttons.print.min.js"></script>
<link rel="stylesheet" type="text/css" href="/display/javascript/DataTables-1.10.15/extensions/Buttons/css/buttons.dataTables.min.css" />
<script type="text/javascript" charset="utf-8" src="/display/javascript/pdfmake.min.js"></script>
<script type="text/javascript" charset="utf-8" src="/display/javascript/vfs_fonts.js"></script>
<script type="text/javascript" charset="utf-8" src="/display/javascript/jszip.min.js"></script>

<!-- Rajout du tri sur la date/heure -->
<script type="text/javascript" src="/display/javascript/moment.min.js"></script>
<script type="text/javascript" src="/display/javascript/datetime-moment.js"></script>



<!-- datetime
<link rel="stylesheet" type="text/css" href="/display/javascript/datetimepicker/jquery.datetimepicker.css" />
<script type="text/javascript" src="/display/javascript/datetimepicker/jquery.datetimepicker.full.min.js"></script>
 -->
 
<!-- composant date/heure -->
<script type="text/javascript" charset="utf-8" src="/display/javascript/jquery-ui-1.12.0.custom/jquery-ui.min.js"></script>
<script type="text/javascript" charset="utf-8" src="/display/javascript/jquery-ui-1.12.0.custom/i18n/datepicker-en.js"></script>
<script type="text/javascript" charset="utf-8" src="/display/javascript/jquery-ui-1.12.0.custom/i18n/datepicker-fr.js"></script>
<script type="text/javascript" charset="utf-8" src="/display/javascript/jquery-timepicker-addon/jquery-ui-timepicker-addon.min.js"></script>
<script type="text/javascript" charset="utf-8" src="/display/javascript/jquery-timepicker-addon/i18n/jquery-ui-timepicker-fr.js"></script>
<link rel="stylesheet" type="text/css" href="/display/javascript/jquery-ui-1.12.0.custom/jquery-ui.min.css"/>
<link rel="stylesheet" type="text/css" href="/display/javascript/jquery-ui-1.12.0.custom/jquery-ui.theme.min.css"/>
<link rel="stylesheet" type="text/css" href="/display/javascript/jquery-timepicker-addon/jquery-ui-timepicker-addon.min.css"/>

<!-- Affichage des photos -->
<link rel="stylesheet" href="/display/javascript/magnific-popup/magnific-popup.css"> 
<script src="/display/javascript/magnific-popup/jquery.magnific-popup.min.js"></script> 

<!-- Code specifique -->
<link rel="stylesheet" type="text/css" href="/display/CSS/bootstrap-prototypephp.css" >
<script type="text/javascript" src="/display/javascript/bootstrap-prototypephp.js"></script>


<!--  implementation automatique des classes -->
<script>
$(document).ready(function() {
	$.fn.dataTable.moment( 'DD/MM/YYYY HH:mm:ss' );
	$.fn.dataTable.moment( 'DD/MM/YYYY' );
	$('.datatable').DataTable({
		language : {
			url : 'display/javascript/fr_FR.json'
		},
		 "searching": false
	});
	$('.datatable-nopaging').DataTable({
		language : {
			url : 'display/javascript/fr_FR.json'
		},
		"paging" : false,
		"searching": false
	});
	$('.datatable-nopaging-nosort').DataTable({
		language : {
			url : 'display/javascript/fr_FR.json'
		},
		"paging" : false,
		"searching": false,
		"ordering": false
	});
	
	$('.datatable-export').DataTable({	
		 dom: 'Bfrtip',
		language : {
			url : 'display/javascript/fr_FR.json'
		},
		"paging" : false,
		"searching": false,
        buttons: [
            'copyHtml5',
            'excelHtml5',
            'csvHtml5',
            {
                extend: 'pdfHtml5',
                orientation: 'landscape'
            },
            'print'
        ]
	});
	
	$('.taux,nombre').attr('title', '{$LANG[message].34}');
	$('.taux').attr({
		'pattern' : '-?[0-9]+(\.[0-9]+)?',
		'maxlength' : "10"
	});
	$('.nombre').attr({
		'pattern' : '-?[0-9]+',
		'maxlength' : "10"
	});
	
	$(".date").datepicker( $.datepicker.regional['fr'] );
	$.datepicker.setDefaults($.datepicker.regional['fr']);
	$('.timepicker').attr('pattern', '[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]');
	$.timepicker.setDefaults($.timepicker.regional['fr']);
	$('.datetimepicker').datetimepicker({ 
		dateFormat: "dd/mm/yy",
		timeFormat: 'HH:mm:ss',
		timeInput: true
	});
});

</script>
