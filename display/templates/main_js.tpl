<!-- Jquery -->
<script src="{$display}/javascript/jquery-3.3.1.min.js"></script>

<!-- Bootstrap -->
<link rel="stylesheet"	href="{$display}/javascript/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet"	href="{$display}/javascript/bootstrap/css/bootstrap-theme.min.css">
<script	src="{$display}/javascript/bootstrap/js/bootstrap.min.js"></script>

<!--alpaca -->
<script type="text/javascript" src="display/javascript/alpaca/js/handlebars.runtime-v4.0.10.js"></script>
<script type="text/javascript" src="display/javascript/alpaca/js/alpaca-1.5.23.min.js"></script>
<link type="text/css" href="display/javascript/alpaca/css/alpaca-1.5.23.min.css" rel="stylesheet">


<!-- extension pour le menu -->
<script src="{$display}/javascript/smartmenus-1.1.0/jquery.smartmenus.min.js" type="text/javascript"></script>
<link type="text/css" href="display/javascript/smartmenus-1.1.0/addons/bootstrap/jquery.smartmenus.bootstrap.css" rel="stylesheet">
<script src="{$display}/javascript/smartmenus-1.1.0/addons/bootstrap/jquery.smartmenus.bootstrap.min.js" type="text/javascript"></script>

<!-- Datatables -->
<link rel="stylesheet" type="text/css" href="{$display}/javascript/DataTables-1.10.15/media/css/jquery.dataTables.min.css" />
<link rel="stylesheet" type="text/css" href="{$display}/javascript/DataTables-1.10.15/media/css/dataTables.bootstrap.min.css" />
<script type="text/javascript" src="{$display}/javascript/DataTables-1.10.15/media/js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="{$display}/javascript/DataTables-1.10.15/media/js/dataTables.bootstrap.min.js"></script>
<!-- Boutons d'export associes aux datatables - classe datatable-export -->
<script type="text/javascript" src="{$display}/javascript/DataTables-1.10.15/extensions/Buttons/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="{$display}/javascript/DataTables-1.10.15/extensions/Buttons/js/buttons.html5.min.js"></script>
<script type="text/javascript" src="{$display}/javascript/DataTables-1.10.15/extensions/Buttons/js/buttons.print.min.js"></script>
<link rel="stylesheet" type="text/css" href="{$display}/javascript/DataTables-1.10.15/extensions/Buttons/css/buttons.dataTables.min.css" />
<!--  <script type="text/javascript" charset="utf-8" src="{$display}/javascript/pdfmake.min.js"></script>
<script type="text/javascript" charset="utf-8" src="{$display}/javascript/vfs_fonts.js"></script>
<script type="text/javascript" charset="utf-8" src="{$display}/javascript/jszip.min.js"></script>
 -->
<!-- Rajout du tri sur la date/heure -->
<script type="text/javascript" src="{$display}/javascript/moment.min.js"></script>
<script type="text/javascript" src="{$display}/javascript/datetime-moment.js"></script>



<!-- datetime
<link rel="stylesheet" type="text/css" href="{$display}/javascript/datetimepicker/jquery.datetimepicker.css" />
<script type="text/javascript" src="{$display}/javascript/datetimepicker/jquery.datetimepicker.full.min.js"></script>
 -->
 
<!-- composant date/heure -->
<script type="text/javascript" charset="utf-8" src="{$display}/javascript/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
<script type="text/javascript" charset="utf-8" src="{$display}/javascript/jquery-ui-1.12.1.custom/i18n/datepicker-en.js"></script>
<script type="text/javascript" charset="utf-8" src="{$display}/javascript/jquery-ui-1.12.1.custom/i18n/datepicker-fr.js"></script>
<script type="text/javascript" charset="utf-8" src="{$display}/javascript/jquery-timepicker-addon/jquery-ui-timepicker-addon.min.js"></script>
<script type="text/javascript" charset="utf-8" src="{$display}/javascript/jquery-timepicker-addon/i18n/jquery-ui-timepicker-fr.js"></script>
<link rel="stylesheet" type="text/css" href="{$display}/javascript/jquery-ui-1.12.1.custom/jquery-ui.min.css"/>
<link rel="stylesheet" type="text/css" href="{$display}/javascript/jquery-ui-1.12.1.custom/jquery-ui.theme.min.css"/>
<link rel="stylesheet" type="text/css" href="{$display}/javascript/jquery-timepicker-addon/jquery-ui-timepicker-addon.min.css"/>
<script type="text/javascript" charset="utf-8" src="{$display}/javascript/jquery-ui-1.12.1.custom/combobox.js"></script>

<!-- Affichage des photos -->
<link rel="stylesheet" href="{$display}/javascript/magnific-popup/magnific-popup.css"> 
<script src="{$display}/javascript/magnific-popup/jquery.magnific-popup.min.js"></script> 

<!-- Cookies -->
<script src="/display/javascript/js-cookie-master/src/js.cookie.js"></script> 

<!-- Code specifique -->
<link rel="stylesheet" type="text/css" href="{$display}/CSS/bootstrap-prototypephp.css" >
<script type="text/javascript" src="{$display}/javascript/bootstrap-prototypephp.js"></script>


<!--  implementation automatique des classes -->
<script>
var dataTableLanguage = {
    "sProcessing":     "{t}Traitement en cours...{/t}",
    "sSearch":         "{t}Rechercher :{/t}",
    "sLengthMenu":     "{t}Afficher _MENU_ éléments{/t}",
    "sInfo":           "{t}Affichage de l'élément _START_ à _END_ sur _TOTAL_ éléments{/t}",
    "sInfoEmpty":      "{t}Affichage de l'élément 0 à 0 sur 0 élément{/t}",
    "sInfoFiltered":   "{t}(filtré de _MAX_ éléments au total){/t}",
    "sInfoPostFix":    "",
    "sLoadingRecords": "{t}Chargement en cours...{/t}",
    "sZeroRecords":    "{t}Aucun élément à afficher{/t}",
    "sEmptyTable":     "{t}Aucune donnée disponible dans le tableau{/t}",
    "oPaginate": {
        "sFirst":      "{t}Premier{/t}",
        "sPrevious":   "{t}Précédent{/t}",
        "sNext":       "{t}Suivant{/t}",
        "sLast":       "{t}Dernier{/t}"
    },
    "oAria": {
        "sSortAscending":  "{t}: activer pour trier la colonne par ordre croissant{/t}",
        "sSortDescending": "{t}: activer pour trier la colonne par ordre décroissant{/t}"
    }
};
$(document).ready(function() {
	$.fn.dataTable.moment( '{$LANG["date"]["formatdatetime"]}' );
	$.fn.dataTable.moment( '{$LANG["date"]["formatdate"]}' );
	$('.datatable').DataTable({
		"language" : dataTableLanguage,
		"searching": false
	});
	$('.datatable-nopaging').DataTable({
		"language" : dataTableLanguage,
		"paging" : false,
		"searching": false
	});
	$('.datatable-nopaging-nosort').DataTable({
		"language" : dataTableLanguage,
		"paging" : false,
		"searching": false,
		"ordering": false
	});
	
	$('.datatable-export').DataTable({	
		 dom: 'Bfrtip',
		"language" : dataTableLanguage,
		"paging" : false,
		"searching": false,
        buttons: [
            'copyHtml5',
            'excelHtml5',
            'csvHtml5',
           /* {
                extend: 'pdfHtml5',
                orientation: 'landscape'
            },*/
            'print'
        ]
	});
	$('.datatable-export-paging').DataTable({	
		 dom: 'Bfrtip',
		"language" : dataTableLanguage,
		"paging" : true,
		"searching": true,
       buttons: [
           'copyHtml5',
           'excelHtml5',
           'csvHtml5',
          /* {
               extend: 'pdfHtml5',
               orientation: 'landscape'
           },*/
           'print'
       ]
	});

	
	$('.taux,nombre').attr('title', '{t}Valeur numérique...{/t}');
	$('.taux').attr({
		'pattern' : '-?[0-9]+(\.[0-9]+)?',
		'maxlength' : "10"
	});
	$('.nombre').attr({
		'pattern' : '-?[0-9]+',
		'maxlength' : "10"
	});
	
	$(".date").datepicker( $.datepicker.regional['{$LANG["date"]["locale"]}'] );
	$(".datepicker").datepicker( $.datepicker.regional['{$LANG["date"]["locale"]}'] );
	$.datepicker.setDefaults($.datepicker.regional['{$LANG["date"]["locale"]}']);
	$('.timepicker').attr('pattern', '[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]');
	$.timepicker.setDefaults($.timepicker.regional['{$LANG["date"]["locale"]}']);
	$('.datetimepicker').datetimepicker({ 
		dateFormat: "{$LANG["date"]["formatdatecourt"]}",
		timeFormat: 'HH:mm:ss',
		timeInput: true
	});
	var lib = "{t}Confirmez-vous la suppression ?{/t}" ;
	$('.button-delete').keypress(function() {
		if (confirm(lib) == true) {
			$(this.form).find("input[name='action']").val("Delete");
			$(this.form).submit();
		} else
			return false;
	});
	$(".button-delete").click(function() {
		if (confirm(lib) == true) {
			$(this.form).find("input[name='action']").val("Delete");
			$(this.form).submit();
		} else {
			return false;
		}
	});
	/*
	 * Initialisation des combobox
	 */
	$(".combobox").combobox();

});

</script>
