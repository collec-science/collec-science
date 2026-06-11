<link rel="stylesheet" href="display/node_modules/leaflet-draw/dist/leaflet.draw.css">
<script src="display/node_modules/leaflet-draw/dist/leaflet.draw.js"></script>
<script>
    var sampling_place_init = "{$sampleSearch.sampling_place_id}";
    var eventTypeInit = "{$sampleSearch.event_type_id}";
    var appli_code = "{$APPLI_code}";
    var razRequired = false;
    $(document).ready(function () {
        var isGestion = "{$rights.manage}";
        var consultSeesAll = "{$consultSeesAll}";
        /**
         * Declenchement de l'export CSV
         */
        $("#exportCsv").on("click keyUp", function () {
            if (confirm("{t}Attention : cet export peut être long, évitez de traiter plus de 10000 échantillons à la fois (vous pouvez sélectionner en utilisant les UID). Confirmez-vous cette opération ?{/t}")) {
                $("#sample_search").attr("action", "sampleExportCsv");
                $("#sample_search").submit();
            }
        });
        /**
         * Declenchement de la recherche
         */
        $("#samplesearch_button").on("click keyUp", function () {
            var action = "{if strlen($moduleBase)>0}{$moduleBase}{else}sample{/if}{if strlen($action)>0}{$action}{else}List{/if}";
            $("#sample_search").attr("action", action);
            $("#sample_search").submit();
        });
        /*
         * Verification que des criteres de selection soient saisis
         */
        $("#sample_search").submit(function (event) {
            var ok = false;
            if ($("#name").val().length > 0) {
                ok = true;
                try {
                    obj = JSON.parse($("#name").val());
                    if (obj.db.length > 0) {
                        if (obj.db == appli_code) {
                            $("#uidsearch").val(obj.uid);
                            $("#name").val("");
                        } else {
                            $("#name").val(obj.db + ":" + obj.uid);
                        }
                    }
                } catch (error) { }
            }
            if ($("#collection_id").val() > 0) ok = true;
            if ($("#uidsearch").val() > 0) {
                ok = true;
            }
            if ($("#uid_min").val() > 0) ok = true;
            if ($("#uid_max").val() > 0) ok = true;
            if ($("#sample_type_id").val() > 0) ok = true;
            if ($("#sampling_place_id").val() > 0) ok = true;
            if ($("#object_status_id").val() > 1) ok = true;
            if ($("#select_date").val().length > 0) ok = true;
            if ($("#referent_id").val() > 0) ok = true;
            if ($("#movement_reason_id").val() > 0) ok = true;
            if ($("#campaign_id").val() > 0) ok = true;
            if ($("#trashed").val() == 1) ok = true;
            if ($("#samplesearch_id").val() > 0) ok = true;
            if ($("#country_id_search").val() > 0) ok = true;
            if ($("#country_origin_id_search").val() > 0) ok = true;
            if ($("#authorization_number").val().length > 0) ok = true;
            if ($("#event_type_id").val() > 0) ok = true;
            if ($("#subsample_quantity_min").val() > 0) ok = true;
            if ($("#subsample_quantity_max").val().length > 0) ok = true;
            if ($("#booking_type").val() != 0) ok = true;
            if ($("#without_container").is(':checked')) ok = true;
            if ($("#collections").val() > 0) ok = true;
            if ($("#metadatafilter").val().length > 0) ok = true;
            if ($("#operation_id").val() > 0) ok = true;
            var mf = $("#metadata_field").val();

            if (mf != null) {
                if (mf.length > 0 && $("#metadata_value").val().length > 2) {
                    ok = true;
                }
            }
            var points = ["SouthWest", "NorthEast"];
            var coordNames = ["lon", "lat"];
            var coordsOk = true;
            points.forEach(function (point) {
                coordNames.forEach(function (coordName) {
                    if (position) {
                        try {
                            $("#" + point + coordName).val(getCoord(point, coordName));
                        } catch (error) {
                            $("#" + point + coordName).val("");
                            coordsOk = false;
                        }
                    }
                    if ($("#" + point + coordName).val().length == 0) {
                        coordsOk = false;
                    }
                });
            });
            if (coordsOk) {
                ok = true;
            }
            if (!ok) {
                event.preventDefault();
            }
        });
        var lastSampletypeId = "{$sampleSearch.sample_type_id}";
        var datamd1 = "{$sampleSearch.metadata_value.1}";
        var datamd2 = "{$sampleSearch.metadata_value.2}";
        if (!datamd1.length > 0) {
            $("#metadatarow1").hide();
        }
        if (!datamd2.length > 0) {
            $("#metadatarow2").hide();
        }
        $("#showmetadata1").click(function () {
            $("#metadatarow1").show();
        });
        $("#showmetadata2").click(function () {
            $("#metadatarow2").show();
        });
        if (isGestion == 1 || consultSeesAll == 1) {
            var metadataFieldInitial = [];
            {foreach $sampleSearch.metadata_field as $val }
            metadataFieldInitial.push("{$val}");
            {/foreach }
        }
        var metadatafilter = "{$sampleSearch.metadatafilter}";
        $("#sample_type_id").change(function () {
            regenerateMetadata();
        });
        function regenerateMetadata() {
            if (isGestion == 1 || consultSeesAll == 1) {
                /* regenerate the list of metadata */
                var sampleTypeId = $("#sample_type_id").val();
                if (sampleTypeId != lastSampletypeId && sampleTypeId) {
                    $(".metadatavalue").val("");
                }
                lastSampletypeId = sampleTypeId;
                $.ajax({
                    url: "sampleTypeMetadataSearchable",
                    data: { "sample_type_id": sampleTypeId }
                })
                    .done(function (value) {
                        if (value.length > 0) {
                            $("#metadata_field").empty();
                            $("#metadata_field1").empty();
                            $("#metadata_field2").empty();
                            $("#metadatafilter").empty();
                            $("#metadatarow1").hide();
                            $("#metadatarow2").hide();
                            $("#metadatarow").show();
                            var selected = "";
                            var option = '<option value="" selected>{t}Métadonnée :{/t}</option>';
                            $("#metadata_field").append(option);
                            $("#metadata_field1").append(option);
                            $("#metadata_field2").append(option);
                            $("#metadatafilter").append('<option value="">{t}Métadonnée à afficher :{/t}</option>');
                            $.each(JSON.parse(value), function (i, obj) {
                                var nom = obj.fieldname.replace(/ /g, "_");
                                if (nom == metadataFieldInitial[0]) {
                                    selected = "selected";
                                }
                                option = '<option value="' + nom + '" ' + selected + '>' + nom + '</option>';
                                $("#metadata_field").append(option);
                                /* second champ */
                                selected = "";
                                if (nom == metadataFieldInitial[1]) {
                                    selected = "selected";
                                    $("#metadatarow1").show();
                                }
                                option = '<option value="' + nom + '" ' + selected + '>' + nom + '</option>';
                                $("#metadata_field1").append(option);
                                /* 3eme champ */
                                selected = "";
                                if (nom == metadataFieldInitial[2]) {
                                    selected = "selected";
                                    $("#metadatarow2").show();
                                }
                                option = '<option value="' + nom + '" ' + selected + '>' + nom + '</option>';
                                $("#metadata_field2").append(option);
                                selected = "";
                                /*
                                 * metadatafilter
                                 */
                                if (nom == metadatafilter) {
                                    selected = "selected";
                                }
                                option = '<option value="' + nom + '" ' + selected + '>' + nom + '</option>';
                                $("#metadatafilter").append(option);
                            })
                        }
                    });
            }

        }
        function getSamplingPlace() {
            var colid = $("#collection_id").val();
            var url = "samplingPlaceGetFromCollection";
            var data = { "collection_id": colid };
            $.ajax({ url: url, data: data })
                .done(function (d) {
                    if (d) {
                        d = JSON.parse(d);
                        options = '<option value="">{t}Choisissez...{/t}</option>';
                        for (var i = 0; i < d.length; i++) {
                            var libelle = "";
                            if (d[i].sampling_place_code) {
                                libelle = d[i].sampling_place_code + " - ";
                            }
                            libelle += d[i].sampling_place_name;
                            options += '<option value="' + d[i].sampling_place_id + '"';
                            if (d[i].sampling_place_id == sampling_place_init) {
                                options += ' selected="selected" ';
                            }
                            options += '>';
                            options += libelle;

                            options += '</option>';
                        };
                        $("#sampling_place_id").html(options);
                    }
                });
        }
        function getEventTypes() {
            var colid = $("#collection_id").val();
            if (!colid > 0) {
                colid = 0;
            }
            var url = "eventTypeGetAjax";
            var data = {
                "collection_id": colid,
                "object_type": 1
            };
            $.ajax({ url: url, data: data })
                .done(function (d) {
                    if (d) {
                        d = JSON.parse(d);

                        options = '<option value=""';
                        if (razRequired) {
                            options += " selected";
                        }
                        options += '>{t}Choisissez...{/t}</option>';
                        for (var i = 0; i < d.length; i++) {
                            var libelle = "";
                            options += '<option value="' + d[i].event_type_id + '"';
                            if (d[i].event_type_id == eventTypeInit && !razRequired) {
                                options += 'selected';
                            }
                            options += '>' + d[i].event_type_name + '</option>';
                        }
                        $("#event_type_id").html(options);
                    }
                });
        }

        $("#collection_id").change(function () {
            getSamplingPlace();
            var colId = $(this).val();
            if (colId > 0) {
                getEventTypes();
            } else {
                $("#event_type_id").prop("selectedIndex", 0).change();
            }
        });
        /*
          * Initialisation a l'ouverture de la page
          */
        getSamplingPlace();
        getEventTypes();


        $("#razid").on("click keyup", function () {
            razRequired = true;
            metadataFieldInitial = [];
            $("#object_status_id").prop("selectedIndex", 1).change();
            $("#collection_id").prop("selectedIndex", 0).change();
            $("#referent_id").prop("selectedIndex", 0).change();
            $("#sample_type_id").prop("selectedIndex", 0).change();
            sampling_place_init = "";
            $("#sampling_place_id").prop("selectedIndex", 0).change();
            $("#country_id_search").prop("selectedIndex", 0).change();
            $("#country_origin_id_search").prop("selectedIndex", 0).change();
            $("#movement_reason_id").prop("selectedIndex", 0).change();
            $("#select_date").prop("selectedIndex", 0).change();
            $("#campaign_id").prop("selectedIndex", 0).change();
            $("#operation_id").prop("selectedIndex", 0).change();
            $("#uidsearch").val("");
            $("#uid_min").val("0");
            $("#uid_max").val("0");
            $("#metadata_field").prop("selectedIndex", 0).change();
            $("#metadata_field1").prop("selectedIndex", 0).change();
            $("#metadata_field2").prop("selectedIndex", 0).change();
            $("#metadatafilter").prop("selectedIndex", 0).change();
            $("#metadata_value").val("");
            $("#metadata_value_1").val("");
            $("#metadata_value_2").val("");
            $("#metadatarow1").hide();
            $("#metadatarow2").hide();
            $("#NorthEastlat").val("");
            $("#NorthEastlon").val("");
            $("#SouthWestlat").val("");
            $("#SouthWestlon").val("");
            $("#trashed").val("0");
            $("#subsample_quantity_min").val("");
            $("#subsample_quantity_max").val("");
            $("#without_container").prop("checked", false);
            removeLayer();
            var now = new Date();
            $("#date_from").datepicker("setDate", new Date(now.getFullYear() - 1, now.getMonth(), now.getDay()));
            $("#date_to").datepicker("setDate", now);
            $("#booking_type").prop("selectedIndex", 0).change();
            $("#booking_from").datepicker("setDate", now);
            $("#booking_to").datepicker("setDate", now);
            $("#name").val("");
            $("#collections").val("");
            $("#event_type_id").prop("selectedIndex", 0).change();
            $("#uidsearch").focus();
            razRequired = false;
        });
        /* Management of tabs */
        var activeTab = "";
        var myStorage = window.localStorage;
        try {
            activeTab = myStorage.getItem("sampleSearchTab");
        } catch (Exception) {
        }
        try {
            if (activeTab.length > 0) {
                $("#" + activeTab).tab('show');
            }
        } catch (Exception) { }
        /**
         * Get the limit from the storage
         */
        var limit = "{$sampleSearch.limit}";
        $("#limit").change(function () {
            myStorage.setItem("sampleSearchLimit", $("#limit").val());
        });
        try {
            var localLimit = myStorage.getItem("sampleSearchLimit");
            $("#limit").val(localLimit);
        } catch (Exception) {
            $("#limit").val(100);
        }

        /*$('.nav-tabs > li > a').hover(function() {
            //$(this).tab('show');
        });*/
        /**
         * storage of the searchTab
         */
        $('.searchTab').on('shown.bs.tab', function () {
            myStorage.setItem("sampleSearchTab", $(this).attr("id"));
        });
        /**
         * Delete a recorded request
         */
        $("#samplesearchDeleteButton").click(function () {
            if (confirm("{t}Confirmez-vous la suppression ?{/t}") == true) {
                $("#samplesearchDelete").val(1);
                $("#sample_search").submit();
            }
        });
        /**
         * change the label of the research button
         */
        $("#samplesearch_name").keyup(function () {
            if ($(this).val().length > 0) {
                $("#samplesearch_button").val("{t}Enregistrer et rechercher{/t}");
            } else {
                $("#samplesearch_button").val("{t}Rechercher{/t}");
            }
        });
        /**
         * Initialize
         */
        if (isGestion == 1 || consultSeesAll == 1) {
            regenerateMetadata();
        }
        try {
            var asbc = myStorage.getItem("searchByColumn");
            if (asbc == 1) {
                $("#activateSearchByColumn").prop("checked", 1);
            }
        } catch (Exception) { }

        $("#activateSearchByColumn").change(function () {
            var asbc = 0;
            if (this.checked) {
                asbc = 1;
            }
            myStorage.setItem("searchByColumn", asbc);
        });
    });
</script>
<div class="container-fluid">
    <div class="row">
        <form class="" id="sample_search"
            action="{if strlen($moduleBase)>0}{$moduleBase}{else}sample{/if}{if strlen($action)>0}{$action}{else}List{/if}"
            method="GET">
            <input id="moduleBase" type="hidden" name="moduleBase"
                value="{if strlen($moduleBase)>0}{$moduleBase}{else}sample{/if}">
            <input id="isSearch" type="hidden" name="isSearch" value="1">
            <input type="hidden" id="SouthWestlon" name="SouthWestlon" value="{$sampleSearch.SouthWestlon}">
            <input type="hidden" id="SouthWestlat" name="SouthWestlat" value="{$sampleSearch.SouthWestlat}">
            <input type="hidden" id="NorthEastlon" name="NorthEastlon" value="{$sampleSearch.NorthEastlon}">
            <input type="hidden" id="NorthEastlat" name="NorthEastlat" value="{$sampleSearch.NorthEastlat}">
            <input type="hidden" id="samplesearchDelete" name="samplesearchDelete" value="0">
            <!-- boite d'onglets -->
            <ul class="nav nav-tabs" id="searchTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link searchTab active" id="tabsearch-uid" data-bs-toggle="tab" role="tab"
                        aria-controls="navsearch-uid" aria-selected="true" href="#navsearch-uid">
                        {t}UID/identifiant{/t}
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link searchTab" id="tabsearch-type" href="#navsearch-type" data-bs-toggle="tab"
                        role="tab" aria-controls="navsearch-type" aria-selected="false">
                        {t}Type et métadonnées{/t}
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link searchTab" id="tabsearch-date" href="#navsearch-date" data-bs-toggle="tab"
                        role="tab" aria-controls="navsearch-date" aria-selected="false">
                        {t}Dates{/t}
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link searchTab" id="tabsearch-divers" href="#navsearch-divers" data-bs-toggle="tab"
                        role="tab" aria-controls="navsearch-divers" aria-selected="false">
                        {t}Divers{/t}
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link searchTab" id="tabsearch-loc" href="#navsearch-loc" data-bs-toggle="tab"
                        role="tab" aria-controls="navsearch-loc" aria-selected="false">
                        {t}Localisation{/t}
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link searchTab" id="tabsearch-record" href="#navsearch-record" data-bs-toggle="tab"
                        role="tab" aria-controls="navsearch-record" aria-selected="false">
                        {t}Recherches enregistrées{/t}
                    </a>
                </li>
            </ul>
            <div class="tab-content form-horizontal" id="search-tabContent">
                <div class="tab-pane active" id="navsearch-uid" role="tabpanel" aria-labelledby="tabsearch-uid">
                    <div class="row">
                        <label for="uidsearch" class="col-2 text-end form-label">{t}UID :{/t}</label>
                        <div class="col-1">
                            <input id="uidsearch" name="uidsearch" class="form-control nombre"
                                value="{$sampleSearch.uidsearch}" autofocus>
                        </div>
                        <label for="name" class="col-3 text-end offset-md-2 text-end form-label">
                            {t}Identifiant(s) ou UUID :{/t}
                            <img src="display/images/qrcode.png" height="25">
                        </label>
                        <div class="col-4">
                            <input id="name" type="text" class="form-control" name="name" value="{$sampleSearch.name}"
                                title="{t}identifiant principal, identifiants secondaires (p. e. : cab:15), UUID (p. e. : e1b1bdd8-d1e7-4f07-8e96-0d71e7aada2b), ou liste d'identifiants principaux séparés par une virgule (p. e. : af74,af76){/t}">
                        </div>
                    </div>
                    <div class="row">
                        <label for="uid_min" class="col-2 text-end form-label">{t}UID entre :{/t}</label>
                        <div class="col-2">
                            <input id="uid_min" name="uid_min" class="nombre form-control"
                                value="{$sampleSearch.uid_min}">
                        </div>
                        <div class="col-2">
                            <input id="uid_max" name="uid_max" class="nombre form-control"
                                value="{$sampleSearch.uid_max}">
                        </div>
                    </div>
                    <div class="row">
                        <label for="collection_id" class="col-2 text-end form-label">{t}Collection :{/t}</label>
                        <div class="col-4">
                            <select id="collection_id" name="collection_id" class="form-select">
                                <option value="" {if $sampleSearch.collection_id=="" }selected{/if}>{t}Choisissez...{/t}
                                </option>
                                {foreach $collectionsSearch as $collection}
                                <option value="{$collection.collection_id}" {if
                                    $collection.collection_id==$sampleSearch.collection_id}selected{/if}>
                                    {$collection.collection_name}
                                </option>
                                {/foreach}
                            </select>
                        </div>
                        <label for="collections" class="col-2 text-end form-label">{t}Ou recherche multiple :{/t}</label>
                        <div class="col-4">
                            <select id="collections" name="collections[]" class="form-select" multiple size="3">
                                <option value="" {if count($sampleSearch.collections)==0}selected{/if}>
                                    {t}Choisissez...{/t}</option>
                                {foreach $collectionsSearch as $collection}
                                <option value="{$collection.collection_id}" {if
                                    in_array($collection.collection_id,$sampleSearch.collections)}selected{/if}>
                                    {$collection.collection_name}
                                </option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <label for="object_status_id" class="col-2 text-end form-label lexical" data-lexical="status">
                            {t}Statut :{/t}</label>
                        <div class="col-2">
                            <select id="object_status_id" name="object_status_id" class="form-select">
                                <option value="" {if $sampleSearch.object_status_id=="" }selected{/if}>
                                    {t}Choisissez...{/t}</option>
                                {section name=lst loop=$objectStatus}
                                <option value="{$objectStatus[lst].object_status_id}" {if
                                    $objectStatus[lst].object_status_id==$sampleSearch.object_status_id}selected{/if}>
                                    {$objectStatus[lst].object_status_name}
                                </option>
                                {/section}
                            </select>
                        </div>
                        <label for="trashed" class="col-2 offset-md-2 text-end form-label lexical" data-lexical="trashed"
                            title="{t}Échantillons mis à la corbeille{/t}">{t}En attente de suppression :{/t}</label>
                        <div class="col-2">
                            <select id="trashed" name="trashed" class="form-select">
                                <option value="" {if $sampleSearch.trashed=="" }selected{/if}>{t}Tous{/t}</option>
                                <option value="1" {if $sampleSearch.trashed=="1" }selected{/if}>{t}Oui{/t}</option>
                                <option value="0" {if $sampleSearch.trashed=="0" }selected{/if}>{t}Non{/t}</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="navsearch-type" role="tabpanel" aria-labelledby="tabsearch-type">
                    <div class="row">
                        <label for="sample_type_id" class="col-3 text-end form-label">{t}Type d'échantillon :{/t}</label>
                        <div class="col-6">
                            <select id="sample_type_id" name="sample_type_id" class="form-select ">
                                <option value="0" {if $sampleSearch.sample_type_id=="0" }selected{/if}>
                                    {t}Choisissez...{/t}</option>
                                {section name=lst loop=$sample_type}
                                <option value="{$sample_type[lst].sample_type_id}" {if
                                    $sample_type[lst].sample_type_id==$sampleSearch.sample_type_id}selected{/if}
                                    title="{$sample_type[lst].sample_type_description}">
                                    {$sample_type[lst].sample_type_name}
                                </option>
                                {/section}
                            </select>
                        </div>
                    </div>
                    <div class="row" id="metadatarow">
                        <label for="metadata_field" class="col-3 text-end form-label">
                            {t}Rechercher dans les métadonnées :{/t}
                        </label>
                        <div class="col-3">
                            <select class="form-select" id="metadata_field" name="metadata_field[]">
                                <option value="" {if $sampleSearch.metadata_field.0=="" }selected{/if}>
                                    {t}Métadonnée :{/t}</option>
                                {if $rights.manage == 1 || consultSeesAll == 1}
                                {foreach $metadatas as $value}
                                <option value="{$value.fieldname}" {if
                                    $sampleSearch.metadata_field.0==$value.fieldname}selected{/if}>
                                    {$value.fieldname}
                                </option>
                                {/foreach}
                                {/if}
                            </select>
                        </div>
                        <div class="col-3">
                            <input class="form-control metadatavalue" id="metadata_value" name="metadata_value[]"
                                value="{$sampleSearch.metadata_value.0}"
                                title="{t}Libellé à rechercher dans le champ de métadonnées sélectionné. Si plusieurs valeurs à rechercher, séparez-les par une virgule (sans espace){/t}">
                        </div>
                        <div class="col-1">
                            <img src="display/images/plus.png" height="25" id="showmetadata1">
                        </div>
                    </div>
                    <div class="row" id="metadatarow1">
                        <!--  metadonnees supplementaires -->
                            <label for="metadata_field1" class="col-3 text-end form-label">{t}et{/t}</label>
                            <div class="col-3">
                                <select class="form-select" id="metadata_field1" name="metadata_field[]">
                                    <option value="" {if $sampleSearch.metadata_field.1=="" }selected{/if}>
                                        {t}Métadonnée :{/t}</option>
                                    {if $rights.manage == 1 || consultSeesAll == 1}
                                    {foreach $metadatas as $value}
                                    <option value="{$value.fieldname}" {if
                                        $sampleSearch.metadata_field.1==$value.fieldname}selected{/if}>
                                        {$value.fieldname}
                                    </option>
                                    {/foreach}
                                    {/if}
                                </select>
                            </div>
                            <div class="col-3">
                                <input class="form-control metadatavalue" id="metadata_value_1" name="metadata_value[]"
                                    value="{$sampleSearch.metadata_value.1}"
                                    title="{t}Libellé à rechercher dans le champ de métadonnées sélectionné. Si plusieurs valeurs à rechercher, séparez-les par une virgule (sans espace){/t}">
                            </div>
                            <div class="col-1">
                                <img src="display/images/plus.png" height="25" id="showmetadata2">
                            </div>
                    </div>
                    <div class="row" id="metadatarow2">
                            <label for="metadata_field2" class="col-3 text-end form-label">{t}et{/t}</label>
                            <div class="col-3">
                                <select class="form-select" id="metadata_field2" name="metadata_field[]">
                                    <option value="" {if $sampleSearch.metadata_field.2=="" }selected{/if}>
                                        {t}Métadonnée :{/t}</option>
                                    {if $rights.manage == 1 || consultSeesAll == 1}
                                    {foreach $metadatas as $value}
                                    <option value="{$value.fieldname}" {if
                                        $sampleSearch.metadata_field.2==$value.fieldname}selected{/if}>
                                        {$value.fieldname}
                                    </option>
                                    {/foreach}
                                    {/if}
                                </select>
                            </div>
                            <div class="col-3">
                                <input class="form-control metadatavalue" id="metadata_value_2" name="metadata_value[]"
                                    value="{$sampleSearch.metadata_value.2}"
                                    title="{t}Libellé à rechercher dans le champ de métadonnées sélectionné. Si plusieurs valeurs à rechercher, séparez-les par une virgule (sans espace){/t}">
                            </div>
                    </div>
                    <div class="row">
                        <label for="metadatafilter" class="col-3 text-end form-label">
                            {t}N'afficher qu'une métadonnée :{/t}
                        </label>
                        <div class="col-3">
                            <select class="form-select" id="metadatafilter" name="metadatafilter">
                                <option value="" {if $sampleSearch.metadata_field.2=="" }selected{/if}>
                                    {t}Métadonnée à afficher :{/t}
                                </option>
                                {foreach $metadatas as $value}
                                <option value="{$value.fieldname}" {if
                                    $sampleSearch.metadatafilter==$value.fieldname}selected{/if}>
                                    {$value.fieldname}
                                </option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="navsearch-date" role="tabpanel" aria-labelledby="tabsearch-date">
                    <div class="row">
                        <div class="row">
                            <label for="select_date" class="col-3 text-end form-label">{t}Recherche par date :{/t}</label>
                            <div class="col-2">
                                <select class="form-select" id="select_date" name="select_date">
                                    <option value="" {if $sampleSearch.select_date=="" }selected{/if}>
                                        {t}Choisissez...{/t}</option>
                                    <option value="cd" {if $sampleSearch.select_date=="cd" }selected{/if}>
                                        {t}Date de création dans la base{/t}
                                    </option>
                                    <option value="sd" {if $sampleSearch.select_date=="sd" }selected{/if}>
                                        {t}Date d'échantillonnage{/t}
                                    </option>
                                    <option value="ed" {if $sampleSearch.select_date=="ed" }selected{/if}>
                                        {t}Date d'expiration{/t}
                                    </option>
                                    <option value="ch" {if $sampleSearch.select_date=="ch" }selected{/if}>
                                        {t}Date technique de dernier changement{/t}
                                    </option>
                                </select>
                            </div>

                            <label for="date_from" class="col-1 text-end form-label">{t}du :{/t}</label>
                            <div class="col-2">
                                <input class="datepicker form-control" id="date_from" name="date_from"
                                    value="{$sampleSearch.date_from}">
                            </div>
                            <label for="date_to" class="col-1 text-end form-label">{t}au :{/t}</label>
                            <div class="col-2">
                                <input class="datepicker form-control" id="date_to" name="date_to"
                                    value="{$sampleSearch.date_to}">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="row">
                            <label for="booking_type" class="col-3 text-end form-label">{t}Réservations :{/t}</label>
                            <div class="col-2">
                                <select id="booking_type" name="booking_type" class="form-select">
                                    <option value="0" {if $sampleSearch.booking_type==-1}selected{/if}>
                                        {t}Choisissez...{/t}</option>
                                    <option value="1" {if $sampleSearch.booking_type==1}selected{/if}>{t}Réservé{/t}
                                    </option>
                                    <option value="-1" {if $sampleSearch.booking_type==-1}selected{/if}>
                                        {t}Non réservé{/t}
                                    </option>
                                </select>
                            </div>
                            <label for="booking_from" class="col-1 text-end form-label">{t}du :{/t}</label>
                            <div class="col-2">
                                <input class="datepicker form-control" id="booking_from" name="booking_from"
                                    value="{$sampleSearch.booking_from}">
                            </div>
                            <label for="booking_to" class="col-1 text-end form-label">{t}au :{/t}</label>
                            <div class="col-2">
                                <input class="datepicker form-control" id="booking_to" name="booking_to"
                                    value="{$sampleSearch.booking_to}">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="navsearch-divers" role="tabpanel" aria-labelledby="tabsearch-divers">
                    <div class="row">
                        <div class="row">
                            <label for="referent_id" class="col-3 text-end form-label lexical"
                                data-lexical="referent">{t}Référent :{/t}</label>
                            <div class="col-3">
                                <select id="referent_id" name="referent_id" class="form-select">
                                    <option value="" {if $sampleSearch.referent_id=="" }selected{/if}>
                                        {t}Choisissez...{/t}</option>
                                    {foreach $referents as $referent}
                                    <option value="{$referent.referent_id}" {if
                                        $sampleSearch.referent_id==$referent.referent_id}selected{/if}>
                                        {$referent.referent_firstname} {$referent.referent_name}
                                    </option>
                                    {/foreach}
                                </select>
                            </div>
                            <label for="without_container" class="col-2 text-end form-check-label">
                                {t}Échantillons sans contenants :{/t}
                            </label>
                            <div class="col-1">
                                <input type="checkbox" id="without_container" name="without_container"
                                    class="form-check-input" value="1" {if $sampleSearch.without_container==1}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="row">
                            <label for="campaign_id" class="col-3 form-label lexical text-end"
                                data-lexical="campaign">{t}Campagne de prélèvement :{/t}</label>
                            <div class="col-3">
                                <select id="campaign_id" name="campaign_id" class="form-select">
                                    <option value="" {if $sampleSearch.campaign_id=="" }selected{/if}>
                                        {t}Choisissez...{/t}</option>
                                    {foreach $campaigns as $campaign}
                                    <option value="{$campaign.campaign_id}" {if
                                        $campaign.campaign_id==$sampleSearch.campaign_id}selected{/if}>
                                        {$campaign.campaign_name}</option>
                                    {/foreach}
                                </select>
                            </div>
                            <label for="authorization_number" class="col-2 text-end form-label lexical"
                                data-lexical="authorization">{t}N° d'autorisation :{/t}</label>
                            <div class="col-3">
                                <input id="authorization_number" name="authorization_number" class="form-control"
                                    value="{$sampleSearch.authorization_number}">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="row">
                            <label for="event_type_id" class="col-3 text-end form-label">{t}Type d'événement :{/t}</label>
                            <div class="col-3">
                                <select id="event_type_id" class="form-select" name="event_type_id">
                                    <option value="" {if $sampleSearch.event_type_id=="" }selected{/if}>
                                        {t}Choisissez...{/t}
                                    </option>
                                    {foreach $eventType as $et}
                                    <option value="{$et.event_type_id}" {if
                                        $sampleSearch.event_type_id==$et.event_type_id}selected{/if}>
                                        {$et.event_type_name}</option>
                                    {/foreach}
                                </select>
                            </div>
                            <label for="operation_id" class="col-2 text-end form-label">{t}Opération :{/t}</label>
                            <div class="col-3">
                                <select id="operation_id" class="form-select" name="operation_id">
                                    <option value="" {if $sampleSearch.operation_id==""}selected{/if}>
                                    {t}Choisissez...{/t}
                                    </option>
                                    {foreach $operations as $operation}
                                    <option value="{$operation.operation_id}"
                                    {if $operation.operation_id == $sampleSearch.operation_id}selected{/if}>
                                        {$operation.protocol_name}-{$operation.protocol_version}/{$operation.operation_name}-{$operation.operation_version}
                                    </option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="row">
                            <label for="movement_reason_id" class="col-3 text-end form-label">
                                {t}Motif de déstockage :{/t}</label>
                            <div class="col-3">
                                <select id="movement_reason_id" name="movement_reason_id" class="form-select">
                                    <option value="" {if $sampleSearch.movement_reason_id=="" }selected{/if}>
                                        {t}Choisissez...{/t}</option>
                                    {section name=lst loop=$movementReason}
                                    <option value="{$movementReason[lst].movement_reason_id}" {if
                                        $movementReason[lst].movement_reason_id==$sampleSearch.movement_reason_id}selected{/if}>
                                        {$movementReason[lst].movement_reason_name}
                                    </option>
                                    {/section}
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="row">
                            <label for="subsample_quantity_min" class="col-3 form-label text-end">
                                {t}Quantité minimale disponible dans l'échantillon :{/t}
                            </label>
                            <div class="col-3">
                                <input class="form-control taux" id="subsample_quantity_min"
                                    name="subsample_quantity_min" value="{$sampleSearch.subsample_quantity_min}">
                            </div>
                            <label for="subsample_quantity_max" class="col-2 form-label text-end">{t}maximale :{/t}</label>
                            <div class="col-3">
                                <input class="form-control taux" id="subsample_quantity_max"
                                    name="subsample_quantity_max" value="{$sampleSearch.subsample_quantity_max}">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="navsearch-loc" role="tabpanel" aria-labelledby="tabsearch-loc">
                    <div class="row">
                        <div class="col-5 col-12">
                            <div class="row">
                                <div class="row">
                                    <label for="sampling_place_id" class="col-4 text-end form-label">
                                        {t}Lieu de prélèvement :{/t}
                                    </label>
                                    <div class="col-8">
                                        <select id="sampling_place_id" name="sampling_place_id" class="form-select ">
                                            <option value="0" {if $sampleSearch.sampling_place_id=="0" }selected{/if}>
                                            </option>
                                            {section name=lst loop=$samplingPlace}
                                            <option value="{$samplingPlace[lst].sampling_place_id}" {if
                                                $samplingPlace[lst].sampling_place_id==$sampleSearch.sampling_place_id}selected{/if}>
                                                {if strlen({$samplingPlace[lst].sampling_place_code}) > 0}
                                                {$samplingPlace[lst].sampling_place_code} -&nbsp;
                                                {/if}
                                                {$samplingPlace[lst].sampling_place_name}
                                            </option>
                                            {/section}
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <label for="country_id_search" class="col-4 text-end form-label">
                                        {t}Pays de collecte :{/t}</label>
                                    <div class="col-8">
                                        <select id="country_id_search" name="country_id" class="form-select ">
                                            <option value="0" {if $country.country_id=="0" }selected{/if}></option>
                                            {section name=lst loop=$countries}
                                            <option value="{$countries[lst].country_id}" {if
                                                $countries[lst].country_id==$sampleSearch.country_id}selected{/if}>
                                                {$countries[lst].country_name}
                                            </option>
                                            {/section}
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <label for="country_origin_id_search" class="col-4 text-end form-label">
                                        {t}Pays de provenance :{/t}
                                    </label>
                                    <div class="col-8">
                                        <select id="country_origin_id_search" name="country_origin_id"
                                            class="form-select ">
                                            <option value="0" {if $country.country_id=="0" }selected{/if}></option>
                                            {section name=lst loop=$countries}
                                            <option value="{$countries[lst].country_id}" {if
                                                $countries[lst].country_id==$sampleSearch.country_origin_id}selected{/if}>
                                                {$countries[lst].country_name}
                                            </option>
                                            {/section}
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="map" class="hidden-sm col-6">
                            <div id="map" class="mapSearch"></div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="navsearch-record" role="tabpanel" aria-labelledby="tabsearch-record">
                    <div class="row">
                        <div class="row">
                            <label for="samplesearch_id" class="col-4 text-end form-label">
                                {t}Recherches enregistrées :{/t}
                            </label>
                            <div class="col-6">
                                <select id="samplesearch_id" class="form-select" name="samplesearch_id">
                                    <option value="" {if $samplesearch_id==0}selected{/if}>
                                        {t}Sélectionnez une recherche enregistrée{/t}
                                    </option>
                                    {foreach $samplesearches as $samplesearch}
                                    <option value="{$samplesearch.samplesearch_id}" {if
                                        $samplesearch_id==$samplesearch.samplesearch_id}selected{/if}>
                                        {$samplesearch.samplesearch_name}
                                        {if ! empty ($samplesearch.collection_name)}
                                        ({$samplesearch.collection_name})
                                        {/if}
                                    </option>
                                    {/foreach}
                                </select>
                            </div>
                            <div class="col-2">
                                <button type="button" id="samplesearchDeleteButton"
                                    class="btn btn-danger">{t}Supprimer{/t}</button>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <fieldset class="col-12">
                            <legend>{t}Enregistrer la recherche courante{/t}</legend>
                            <div class="row">
                                <label for="samplesearch_name" class="col-4 text-end form-label"><span class="red">*</span>
                                    {t}Nom de la recherche :{/t}
                                </label>
                                <div class="col-6">
                                    <input id="samplesearch_name" name="samplesearch_name" class="form-control">
                                </div>
                            </div>
                            <div class="row">
                                <label for="samplesearch_collection" class="col-4 text-end form-label">
                                    {t}Enregistrer pour la collection sélectionnée (le cas échéant) ?{/t}
                                </label>
                                <div id="samplesearch_collection" class="col-8">
                                    <label class="radio-inline">
                                        <input type="radio" name="samplesearch_collection" value="0" checked>{t}non{/t}
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio" name="samplesearch_collection" value="1">{t}oui{/t}
                                    </label>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                </div>

                <div class="row">
                    <label for="limit" class="col-3 text-end form-label">
                        {t}Nombre maxi à lire depuis la base de données (0 pour tous) :{/t}
                    </label>
                    <div class="col-1">
                        <input id="limit" name="limit" value="{$sampleSearch.limit}" class="form-control nombre">
                    </div>
                    <label for="page" class="col-1 text-end form-label">
                        {t}À partir de la page{/t}
                    </label>
                    <div class="col-1">
                        <input id="page" name="page" value="{$sampleSearch.page}" class="form-control nombre"
                            type="number">
                    </div>
                    <div class="col-4 center">
                        <button type="submit" id="samplesearch_button"
                            class="btn btn-primary">{t}Rechercher{/t}</button>
                        <button type="button" id="razid" class="btn btn-warning">{t}RAZ{/t}</button>
                        {if $rights.manage == 1}
                        <button type="button" id="exportCsv" class="btn btn-secondary"
                            title="{t}Export sans tenir compte de la pagination et sans affichage de la liste - format : export vers une autre base{/t}">
                            {t}Export CSV direct{/t}
                        </button>
                        {/if}
                        {$helpsamplesearch}
                    </div>
                    <label for="activateSearchByColumn" class="form-check-label  text-end col-1">
                        {t}Recherche par colonne :{/t}
                    </label>
                    <div class="col-1">
                        <input type="checkbox" id="activateSearchByColumn" class="form-check-input">
                    </div>
                </div>
            </div>
    </div>
    {$csrf}
    </form>
</div>
</div>
{include file="mapDefault.tpl"}
<script>
    var map = setMap("map");

    var long = "{$data.station_long}";
    var lat = "{$data.station_lat}";
    var point;
    var SouthWestlat = "{$sampleSearch.SouthWestlat}";
    var SouthWestlon = "{$sampleSearch.SouthWestlon}";
    var NorthEastlat = "{$sampleSearch.NorthEastlat}";
    var NorthEastlon = "{$sampleSearch.NorthEastlon}";

    function setPosition(lat, long) {
        map.setView([lat, long]);
    }

    if (long.length > 0 && lat.length > 0) {
        mapData.mapDefaultLong = long;
        mapData.mapDefaultLat = lat;
    }
    var position;
    var editableLayers = new L.FeatureGroup();
    map.addLayer(editableLayers);
    var options = {
        draw: {
            polyline: false,
            polygon: false,
            circle: false,
            marker: false,
            circlemarker: false
        },
        edit: {
            featureGroup: editableLayers,
            remove: true
        }
    };
    var drawControl = new L.Control.Draw(options);
    L.control.scale().addTo(map);
    map.addControl(drawControl);
    map.on(L.Draw.Event.CREATED, function (e) {
        var type = e.layerType,
            layer = e.layer;
        editableLayers.addLayer(layer);
        position = layer.getLatLngs();
        center = layer.getCenter();
    });
    map.on(L.Draw.Event.EDITED, function (e) {
        var layers = e.layers;
        layers.eachLayer(function (layer) {
            position = layer.getLatLngs();
            center = layer.getCenter();

        });
    });
    function getCoord(pointName, coordName) {
        var points = {
            "SouthWest": 0,
            "NorthWest": 1,
            "NorthEast": 2,
            "SouthEast": 3
        };
        point = points[pointName];
        if ((point >= 0 && point <= 4) && (coordName == 'lon' || coordName == 'lat')) {
            if (coordName == 'lon') {
                return (position[0][point].wrap().lng);
            } else {
                return (position[0][point].wrap().lat);
            }
        }
    }
    var layerParam;
    if (SouthWestlat.length > 0 && SouthWestlon.length > 0 && NorthEastlat.length > 0 && NorthEastlon.length > 0) {
        var bounds = [[parseFloat(SouthWestlat), parseFloat(SouthWestlon)], [parseFloat(NorthEastlat), parseFloat(NorthEastlon)]];
        layerParam = new L.rectangle(bounds);
        editableLayers.addLayer(layerParam);
    }

    function removeLayer() {
        position = null;
        try {
            editableLayers.removeLayer(layerParam);
        } catch (Exception) { }
    }
    mapDisplay(map);

    $("body").on("shown.bs.tab", "#tabsearch-loc", function () {
        map.invalidateSize(true);
    });
</script>