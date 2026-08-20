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
                if (!bootstrap.Tooltip.getInstance(tooltipTriggerEl))
                return new bootstrap.Tooltip(tooltipTriggerEl, {
                    delay: { show: 2000, hide: 500}
                })
            })
        }
        initializeBootstrapTooltip();
        $(".lexical").mouseenter(function () {
            var objet = $(this);
            const tip = bootstrap.Tooltip.getInstance(this);
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
                            /*
                             * decode html entities
                             */
                            const parser = new DOMParser();
                            const contentdecoded = parser.parseFromString(content, 'text/html');
                            content = contentdecoded.body.textContent;
                            tip.setContent({ '.tooltip-inner': content });
                            //tip.show();
                            $(this).attr("title", content);
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