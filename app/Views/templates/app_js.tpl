<!-- leaflet -->
<link rel="stylesheet" href="display/node_modules/leaflet/dist/leaflet.css">
<script src="display/node_modules/leaflet/dist/leaflet.js"></script>
<script src="display/node_modules/pouchdb/dist/pouchdb.min.js"></script>
<script src="display/node_modules/leaflet.tilelayer.pouchdbcached/L.TileLayer.PouchDBCached.js"></script>
<script src="display/node_modules/leaflet.polyline.snakeanim/L.Polyline.SnakeAnim.js"></script>
<script src="display/node_modules/leaflet-mouse-position/src/L.Control.MousePosition.js"></script>
<script src="display/node_modules/leaflet-easyprint/dist/bundle.js"></script>
<script src="display/node_modules/pdfmake/build/pdfmake.min.js"></script>
<script src="display/node_modules/pdfmake/build/vfs_fonts.js"></script>
<script>
    /**
     * Generate a popup for lexical entries, when mouse is over a question icon
     * the field must have a class lexical and the attribute data-lexical with
     * the value to found
     */
    $(document).ready(function () {
        var lexicalDelay = 1000, lexicalTimer, tooltipContent;
        $(".lexical").mouseenter(function () {
            var objet = $(this);
            lexicalTimer = setTimeout(function () {
                var entry = objet.data("lexical");
                if (entry.length > 0) {
                    var url = "lexicalGet";
                    var data = {
                        "lexical": entry
                    }
                    $.ajax({ url: url, data: data })
                        .done(function (d) {
                            if (d) {
                                d = JSON.parse(d);
                                var content = d[0].split(" ");
                                var length = 0;
                                tooltipContent = "";
                                content.forEach(function (word) {
                                    if (length > 40) {
                                        tooltipContent += "<br>";
                                        length = 0;
                                    }
                                    tooltipContent += word + " ";
                                    length += word.length + 1;
                                });
                                tooltipDisplay(objet);
                            }
                        });
                }
            }, lexicalDelay);
        }).mouseleave(function () {
            clearTimeout(lexicalTimer);
            if ($(this).is(':ui-tooltip')) {
                $(this).tooltip("close");
            }
        });
        function tooltipDisplay(object) {
            $(object).tooltip({
                content: tooltipContent
            });
            //object.tooltip("option", "content", tooltipContent);
            $(object).attr("title", tooltipContent);
            $(object).tooltip("open");
        }
        $('.datatable-export-pdf').DataTable({
            layout: { 
                topStart: {
                    buttons: [
                        'copyHtml5',
                        'excelHtml5',
                        'csvHtml5',
                        'print',
                        'pdfHtml5'
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
    });
</script>