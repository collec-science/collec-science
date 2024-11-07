<!-- Jquery -->
<script src="display/node_modules/jquery/dist/jquery.min.js"></script>
<!--script src="display/javascript/jquery-3.6.0.min.js"></script-->

<!-- Bootstrap -->
<link rel="stylesheet" href="display/javascript/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="display/javascript/bootstrap/css/bootstrap-theme.min.css">
<script src="display/node_modules/bootstrap/dist/js/bootstrap.min.js"></script>

<!--JqueryUI-->
<script src="display/node_modules/jquery-ui/dist/jquery-ui.min.js"></script>
<script src="display/node_modules/jquery-ui/ui/widgets/tooltip.js"></script>
<link rel="stylesheet" href="display/node_modules/jquery-ui/dist/themes/base/jquery-ui.min.css">

<!-- translations date/time -->
<script type="text/javascript" charset="utf-8"
    src="display/node_modules/jquery-ui/ui/i18n/datepicker-en-GB.js"></script>
<script type="text/javascript" charset="utf-8" src="display/node_modules/jquery-ui/ui/i18n/datepicker-fr.js"></script>
<script type="text/javascript" charset="utf-8"
    src="display/javascript/jquery-timepicker-addon/jquery-ui-timepicker-addon.min.js"></script>
<link rel="stylesheet" type="text/css" href="display/node_modules/jquery-ui-dist/jquery-ui.min.css" />
<link rel="stylesheet" type="text/css" href="display/node_modules/jquery-ui-dist/jquery-ui.theme.min.css" />
<link rel="stylesheet" type="text/css" href="display/CSS/bootstrap-prototypephp.css">
<script type="text/javascript" charset="utf-8" src="display/javascript/jquery-ui-custom/combobox.js"></script>

<!-- extension pour le menu -->
<script src="display/node_modules/smartmenus/dist/jquery.smartmenus.min.js" type="text/javascript"></script>
<link type="text/css" href="display/node_modules/smartmenus/dist/addons/bootstrap/jquery.smartmenus.bootstrap.css"
    rel="stylesheet">
<script src="display/node_modules/smartmenus/dist/addons/bootstrap/jquery.smartmenus.bootstrap.min.js"
    type="text/javascript"></script>

<!-- Datatables -->
<script src="display/node_modules/datatables.net/js/dataTables.min.js"></script>
<script src="display/node_modules/datatables.net-bs/js/dataTables.bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="display/node_modules/datatables.net-bs/css/dataTables.bootstrap.min.css" />
<script src="display/javascript/intl.js"></script>

<!-- Buttons to export from Datatables - classe datatable-export -->
<script src="display/node_modules/jszip/dist/jszip.min.js"></script>
<script src="display/node_modules/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="display/node_modules/datatables.net-buttons/js/buttons.print.min.js"></script>
<script src="display/node_modules/datatables.net-buttons/js/buttons.html5.min.js"></script>
<script src="display/node_modules/datatables.net-buttons-bs/js/buttons.bootstrap.min.js"></script>
<script src="display/node_modules/datatables.net-buttons/js/buttons.colVis.min.js"></script>
<link rel="stylesheet" type="text/css"
    href="display/node_modules/datatables.net-buttons-bs/css/buttons.bootstrap.min.css" />
<script src="display/node_modules/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js"></script>

<!-- Add sort on date/time -->
<script type="text/javascript" src="display/node_modules/moment/min/moment.min.js"></script>
<script type="text/javascript" src="display/node_modules/datetime-moment/datetime-moment.js"></script>

<!-- Date component-->
<script type="text/javascript" src="display/node_modules/moment/min/moment-with-locales.min.js"></script>
<script type="text/javascript" src="display/node_modules/datetime-moment/datetime-moment.js"></script>
<script type="text/javascript"
    src="display/node_modules/eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js"></script>
<link rel="stylesheet" type="text/css"
    href="display/node_modules/eonasdan-bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.min.css">

<!-- Display pictures -->
<link rel="stylesheet" href="display/node_modules/magnific-popup/dist/magnific-popup.css">
<script src="display/node_modules/magnific-popup/dist/jquery.magnific-popup.min.js"></script>

<!-- Cookies -->
<script src="display/javascript/js-cookie-master/src/js.cookie.js"></script>

<!-- specific code -->
<script type="text/javascript" src="display/javascript/bootstrap-prototypephp.js"></script>


<!--  Automatic implementation of classes -->
<script >
    var dataTableLanguage = {
        "sProcessing": "{t}Traitement en cours...{/t}",
        "sSearch": "{t}Rechercher :{/t}",
        "sLengthMenu": "{t}Afficher _MENU_ éléments{/t}",
        "sInfo": "{t}Affichage de l'élément _START_ à _END_ sur _TOTAL_ éléments{/t}",
        "sInfoEmpty": "{t}Affichage de l'élément 0 à 0 sur 0 élément{/t}",
        "sInfoFiltered": "{t}(filtré de _MAX_ éléments au total){/t}",
        "sInfoPostFix": "",
        "sLoadingRecords": "{t}Chargement en cours...{/t}",
        "sZeroRecords": "{t}Aucun élément à afficher{/t}",
        "sEmptyTable": "{t}Aucune donnée disponible dans le tableau{/t}",
        "oPaginate": {
            "sFirst": "{t}Premier{/t}",
            "sPrevious": "{t}Précédent{/t}",
            "sNext": "{t}Suivant{/t}",
            "sLast": "{t}Dernier{/t}"
        },
        "oAria": {
            "sSortAscending": "{t}: activer pour trier la colonne par ordre croissant{/t}",
            "sSortDescending": "{t}: activer pour trier la colonne par ordre décroissant{/t}"
        },
        "buttons": {
            "pageLength": {
                _: "{t}Afficher %d éléments{/t}",
                '-1': "{t}Tout afficher{/t}"
            }
        }
    };
    var myStorage = window.localStorage;
    $(document).ready(function () {
        var pageLength = myStorage.getItem("pageLength");
        if (!pageLength) {
            pageLength = 10;
        }
        var locale = "{$LANG['date']['locale']}";
        $.fn.dataTable.ext.order.intl(locale, { "sensitivity": "base" });
        $.fn.dataTable.ext.order.htmlIntl(locale, { "sensitivity": "base" });
        $.fn.dataTable.moment('{$LANG["date"]["formatdatetime"]}');
        $.fn.dataTable.moment('{$LANG["date"]["formatdate"]}');
        var lengthMenu = [10, 25, 50, 100, 500, { label:'all',value: -1}];
        $('.datatable').DataTable({
            "language": dataTableLanguage,
            "searching": false,
            //dom: 'Bfrtip',
            layout: { 
                topStart: {
                    buttons: ['pageLength']
                } 
            },
            "pageLength": pageLength,
            "lengthMenu": lengthMenu,
            fixedHeader: {
                header: true,
                footer: true
            }
            //buttons
        });
        $('.datatable-nopaging-nosearching').DataTable({
            "language": dataTableLanguage,
            "searching": false,
            "paging": false,
            fixedHeader: {
                header: true,
                footer: true
            }
        });
        $('.datatable-searching').DataTable({
            "language": dataTableLanguage,
            "searching": true,
            //dom: 'Bfrtip',
            layout: { 
                topStart: {
                    buttons: ['pageLength']
                } 
            },
            "pageLength": pageLength,
            "lengthMenu": lengthMenu,
            fixedHeader: {
                header: true,
                footer: true
            }
        });
        $('.datatable-nopaging').DataTable({
            "language": dataTableLanguage,
            "paging": false,
            "searching": true,
            fixedHeader: {
                header: true,
                footer: true,
            },
            
        });
        $('.datatable-nopaging-nosort').DataTable({
            "language": dataTableLanguage,
            "paging": false,
            "searching": false,
            "ordering": false,
            fixedHeader: {
                header: true,
                footer: true
            }
        });
        $('.datatable-nosort').DataTable({
            "language": dataTableLanguage,
            "searching": false,
            "ordering": false,
            layout: { 
                topStart: {
                    buttons: ['pageLength']
                } 
            },
            "pageLength": pageLength,
            "lengthMenu": lengthMenu,
            fixedHeader: {
                header: true,
                footer: true
            }
        });
        $('.datatable-export').DataTable({
            layout: { 
                topStart: {
                    buttons: [
                        'copyHtml5',
                        'excelHtml5',
                        'csvHtml5',
                        'print'
                    ]
                } 
            },
            "language": dataTableLanguage,
            "paging": false,
            fixedHeader: {
                header: true,
                footer: true
            },
            "searching": true,
        });
        $('.datatable-export-paging').DataTable({
            //dom: 'Bfrtip',
            layout: { 
                topStart: {
                    buttons: [
                        'pageLength',
                        'copyHtml5',
                        'excelHtml5',
                            {
                            extend: 'csvHtml5',
                            filename: 'export_' + new Date().toISOString()
                            },
                        'print'
                    ]
                } 
            },
            "language": dataTableLanguage,
            "paging": true,
            "searching": true,
            "pageLength": pageLength,
            "lengthMenu": lengthMenu,
            fixedHeader: {
                header: true,
                footer: true
            }
        });

        $(".datatable, .datatable-export-paging, .datatable-searching, .datatable-nosort").on('length.dt', function (e, settings, len) {
            if (len > -1) {
                myStorage.setItem('pageLength', len);
            }
        });
        if (pageLength == -1) {
            pageLength = 10;
        }
        /* Initialisation for paging datatables */
        $(".datatable, .datatable-export-paging, .datatable-searching, .datatable-nosort").DataTable().page.len(pageLength).draw();

        $('.taux,nombre').attr('title', '{t}Valeur numérique...{/t}');
        $('.taux').attr({
            'pattern': '-?[0-9]+(\.[0-9]+)?',
            'maxlength': "10"
        });
        $('.nombre').attr({
            'pattern': '-?[0-9]+',
            'maxlength': "10"
        });
        {literal }
        $('.uuid').attr({
            'pattern': '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
            'maxlength': "36"
        });
        {/literal}

            $('.datepicker').datetimepicker({
                locale: locale,
                format: '{$LANG["date"]["formatdate"]}'
            });
            $('.datetimepicker').datetimepicker({
                locale: locale,
                format: '{$LANG["date"]["formatdate"]} HH:mm:ss'
            });
            $('.timepicker').datetimepicker({
                locale: locale,
                format: 'HH:mm:ss'
            });
            $('.date, .datepicker, .timepicker, .datetimepicker').attr('autocomplete', 'off');
            /**
             * Legacy
             */
            function deleteLegacyFields(form) {
                $(form).find("input[name='moduleBase']").remove();
                $(form).find("input[name='module']").remove();
                $(form).find("input[name='action']").remove();
            }
            $(".button-valid").on("keyup click", function () {
                var module = $(this.form).find("input[name='moduleBase']").val();
                var action = $(this.form).find("input[name='action']").val();
                if (module && action) {
                    $(this.form).attr("action", module + action);
                    deleteLegacyFields($(this.form));
                }
            });
            $(".button-delete").on("keyup click", function (e) {
                if (confirm("{t}Confirmez-vous la suppression ?{/t}")) {
                    var module = $(this.form).find("input[name='moduleBase']").val();
                    if (module) {
                        $(this.form).attr("action", module + "Delete");
                        deleteLegacyFields($(this.form));
                    }
                    $(this.form).submit();
                } else {
                    e.preventDefault();
                }
            });
            /*
             * Initialze combobox
             */
            $(".combobox").combobox();
            /**
             * Get a confirmation
             */
            $(".confirm").on("click keydown", function (event) {
                if (!confirm("{t}Confirmez-vous cette opération ?{/t}")) {
                    event.preventDefault();
                }
            });
            /**
             * Add support of tabulation in textarea
             */
            $(".textarea-edit").keydown(function (event) {
                if (event.keyCode === 9) {
                    var v = this.value, s = this.selectionStart, e = this.selectionEnd;
                    this.value = v.substring(0, s) + '\t' + v.substring(e);
                    this.selectionStart = this.selectionEnd = s + 1;
                    return false;
                }
            });
        });
    function encodeHtml(rawStr) {
        if (rawStr && rawStr.length > 0) {
            try {
                var encodedStr = rawStr.replace(/[\u00A0-\u9999<>\&]/gim, function (i) {
                    return '&#' + i.charCodeAt(0) + ';';
                });
            } catch (Exception) { }
            return encodedStr;
        } else {
            return "";
        }
    }
    function operationConfirm() {
        return confirm("{t}Confirmez-vous cette opération ?{/t}");
    }
</script>