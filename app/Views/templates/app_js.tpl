<!-- leaflet -->
<link rel="stylesheet" href="display/node_modules/leaflet/dist/leaflet.css">
<script src="display/node_modules/leaflet/dist/leaflet.js"></script>
<script src="display/node_modules/pouchdb/dist/pouchdb.min.js"></script>
<script src="display/node_modules/leaflet.tilelayer.pouchdbcached/L.TileLayer.PouchDBCached.js"></script>
<script src="display/node_modules/leaflet.polyline.snakeanim/L.Polyline.SnakeAnim.js"></script>
<script src="display/node_modules/leaflet-mouse-position/src/L.Control.MousePosition.js"></script>
<script src="display/node_modules/leaflet-easyprint/dist/bundle.js"></script>
<!--script src="display/node_modules/pdfmake/build/pdfmake.min.js"></script>
<script src="display/node_modules/pdfmake/build/vfs_fonts.js"></script-->
<script>
    /**
     * Generate a popup for lexical entries, when mouse is over a question icon
     * the field must have a class lexical and the attribute data-lexical with
     * the value to found
     */
    $(document).ready(function () {
        /* Tooltip */
        function initializeBootstrapTooltip() {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('.lexical'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                tooltipTriggerEl.setAttribute('title', 'lexical');
                return new bootstrap.Tooltip(tooltipTriggerEl)
            });
        }
        initializeBootstrapTooltip();
        $(".lexical").mouseenter(function () {
            var objet = $(this);
            const tip = bootstrap.Tooltip.getOrCreateInstance(this);
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
                            var content = d[0];
                            /*var content = d[0].split(" ");
                            var length = 0;
                            tooltipContent = "";
                            content.forEach(function (word) {
                                if (length > 40) {
                                    tooltipContent += "<br>";
                                    length = 0;
                                }
                                tooltipContent += word + " ";
                                length += word.length + 1;
                            });*/
                            tip.setContent({ '.tooltip-inner': content });
                            $(this).attr("title", content);
                            console.log(content);
                            if (document.querySelector('.tooltip.show')) {
                                tip.show();
                            }
                        }
                    });
            }
        });
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