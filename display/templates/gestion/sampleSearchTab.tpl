<script>
    var sampling_place_init = "{$sampleSearch.sampling_place_id}";
    var appli_code ="{$APPLI_code}";
    $(document).ready(function () {
        var metadataFieldInitial = [];
        {foreach $sampleSearch.metadata_field as $val}
            metadataFieldInitial.push ( "{$val}" );
        {/foreach}

        /*
         * Verification que des criteres de selection soient saisis
         */
         $("#sample_search").submit (function ( event) {
             var ok = false;
             if ($("#name").val().length > 0) {
                 ok = true;
                 try {
                    obj = JSON.parse($("#name").val());
                    if (obj.db.length > 0) {
                        if (obj.db == appli_code) {
                            $("#name").val(obj.uid);
                        } else {
                            $("#name").val(obj.db + ":"+ obj.uid);
                        }
                    }
                 } catch (error) {}
             }
             if ($("#collection_id").val() > 0) ok = true;
             if ($("#uid_min").val() > 0) ok = true;
             if ($("#uid_max").val() > 0) ok = true;
             if ($("#sample_type_id").val() > 0) ok = true;
             if ($("#sampling_place_id").val() > 0 ) ok = true ;
             if ($("#object_status_id").val() > 1) ok = true;
             if ($("#select_date").val().length > 0) ok = true;
             if ($("#referent_id").val() > 0) ok = true;
             if ($("#movement_reason_id").val() > 0) ok = true;
             if ($("#trashed").val() == 1) ok = true;
             var mf = $("#metadata_field").val();
             if ( mf != null) {
                 if (mf.length > 0 && $("#metadata_value").val().length > 0) {
                     ok = true;
                 }
             }
             if (ok == false) event.preventDefault();
         });

         function getMetadata() {
             var sampleTypeId = $("#sample_type_id").val();
             $("#metadata_field").empty();
             //$("#metadata_value").val("");
             $("#metadata_field1").empty();
             //$("#metadata_value_1").val("");
             $("#metadata_field2").empty();
             //$("#metadata_value_2").val("");
             $("#metadatarow").hide();
             $("#metadatarow1").hide();
             $("#metadatarow2").hide();

             if (sampleTypeId.length > 0) {
                $.ajax( {
                       url: "index.php",
                    data: { "module": "sampleTypeMetadata", "sample_type_id": sampleTypeId }
                })
                .done (function (value) {
                    if (value.length > 0) {
                                $("#metadatarow").show();
                        var selected = "";
                        var option = '<option value="">{t}Métadonnée :{/t}</option>';
                        $("#metadata_field").append(option);
                        $("#metadata_field1").append(option);
                        $("#metadata_field2").append(option);
                           $.each(JSON.parse(value), function(i, obj) {
                               if (obj.isSearchable == "yes") {
                            var nom = obj.name.replace(/ /g,"_");
                            if (nom == metadataFieldInitial[0]) {
                                selected = "selected";
                                $("#metadatarow1").show();
                            }
                            option = '<option value="'+nom+'" '+selected+'>'+nom+'</option>';
                            $("#metadata_field").append(option);
                            /* second champ */
                            selected = "";
                            if (nom == metadataFieldInitial[1]) {
                                selected = "selected";
                                $("#metadatarow2").show();
                            }
                            option = '<option value="'+nom+'" '+selected+'>'+nom+'</option>';
                            $("#metadata_field1").append(option);
                            /* 3eme champ */
                            selected = "";
                            if (nom == metadataFieldInitial[2]) {
                                selected = "selected";
                            }
                            option = '<option value="'+nom+'" '+selected+'>'+nom+'</option>';
                            $("#metadata_field2").append(option);
                            selected = "";

                               }
                        })
                    }
                   })
                   ;
             }
         }

         function getSamplingPlace () {
            var colid = $("#collection_id").val();
            var url = "index.php";
            var data = { "module":"samplingPlaceGetFromCollection", "collection_id": colid };
            $.ajax ( { url:url, data: data})
            .done (function( d ) {
                    if (d ) {
                    d = JSON.parse(d);
                    options = '<option value=""></option>';
                     for (var i = 0; i < d.length; i++) {
                         var libelle = "";
                         if (d[i].sampling_place_code) {
                                libelle = d[i].sampling_place_code + " - ";
                            }
                            libelle += d[i].sampling_place_name;
                            options += '<option value="'+d[i].sampling_place_id + '"';
                            if (d[i].sampling_place_id == sampling_place_init ) {
                                options += ' selected="selected" ';
                                $("#sampling_place_id").next().find(".custom-combobox-input").val(libelle);
                            }
                            options += '>';
                            options += libelle;

                            options += '</option>';
                          };
                    $("#sampling_place_id").html(options);
                    }
                });
        }

         $("#collection_id").change ( function () {
             getSamplingPlace();
         });
         /*
          * Initialisation a l'ouverture de la page
          */
          getSamplingPlace();

         /*
          * Gestion des metadonnees
          */
         $("#sample_type_id").change( function() {
             getMetadata();
         });
         $("#sample_type_id").combobox({
             select: function (event, ui) {
                 $("#metadata_value").val("");
                 $("#metadata_value_2").val("");
                 $("#metadata_value_1").val("");
                 getMetadata();
             }
         });
         /*
          * Declenchement de la recherche des metadonnees
          * si sample_type_id est renseigne au demarrage de la page
          */
         $("#metadatarow").hide();
         if ($("#sample_type_id").val() > 0 ) {
             getMetadata();
         }
         if ($("#metadata_value").val().length == 0) {
             $("#metadatarow1").hide();
         }
         if ($("#metadata_value_1").val().length == 0) {
             $("#metadatarow2").hide();
         }
         $("#metadata_value").change(function () {
                 if ($(this).val().length > 0) {
                     $("#metadatarow1").show();
                 }
         });
         $("#metadata_value_1").change(function () {
             if ($(this).val().length > 0) {
                 $("#metadatarow2").show();
             }
     });
     $("#razid").on ("click keyup", function () {
        $("#object_status_id").prop("selectedIndex", 1).change();
        $("#collection_id").prop("selectedIndex", 0).change();
        $("#referent_id").prop("selectedIndex", 0).change();
        $("#sample_type_id").combobox("select", "").change();
        $("#sampling_place_id").combobox("select", "").change();
        $("#movement_reason_id").prop("selectedIndex", 0).change();
        $("#select_date").prop("selectedIndex", 0).change();
        $("#uid_min").val("0");
        $("#uid_max").val("0");
        $("#metadatarow").hide();
        $("#metadata_value").val("");
        $("#metadata_value_1").val("");
        $("#metadata_value_2").val("");
        $("#trashed").val("0");
        var now = new Date();
        $("#date_from").datepicker("setDate", new Date(now.getFullYear() -1, now.getMonth(), now.getDay()));
        $("#date_to").datepicker("setDate", now );
        $("#name").val("");
        $("#name").focus();
     });
     $('.nav-tabs > li > a').hover(function() {
            $(this).tab('show');
 		});
    });
</script>
<div class="row col-lg-10 col-md-12">
    <form class="" id="sample_search" action="index.php" method="GET">
        <input id="moduleBase" type="hidden" name="moduleBase" value="{if strlen($moduleBase)>0}{$moduleBase}{else}sample{/if}">
        <input id="action" type="hidden" name="action" value="{if strlen($action)>0}{$action}{else}List{/if}">
        <input id="isSearch" type="hidden" name="isSearch" value="1">
        <!-- boite d'onglets -->
        <ul class="nav nav-tabs  " id="myTab" role="tablist" >
            <li class="nav-item active">
                <a class="nav-link" id="tabsearch-uid" data-toggle="tab"  role="tab" aria-controls="navsearch-uid" aria-selected="true" href="#navsearch-uid">
                    {t}UID/identifiant{/t}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="tabsearch-type" href="#navsearch-type"  data-toggle="tab" role="tab" aria-controls="navsearch-type" aria-selected="false">
                    <img src="display/images/label.png" height="25">
                    {t}Type et métadonnées{/t}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="tabsearch-divers" href="#navsearch-divers"  data-toggle="tab" role="tab" aria-controls="navsearch-divers" aria-selected="false">
                    {t}Divers{/t}
                </a>
            </li>
            <li class="nav-item">
                    <a class="nav-link" id="tabsearch-loc" href="#navsearch-loc"  data-toggle="tab" role="tab" aria-controls="navsearch-loc" aria-selected="false">
                        {t}Localisation{/t}
                    </a>
                </li>
        </ul>
        <div class="tab-content col-lg-12 form-horizontal" id="search-tabContent">
            <div class="tab-pane active in" id="navsearch-uid" role="tabpanel" aria-labelledby="tabsearch-uid">
                <div class="row">
                    <div class="form-group">
                        <label for="name" class= "col-sm-3 control-label">{t}UID ou identifiant :{/t}</label>
                        <div class="col-sm-6">
                            <input id="name" type="text" class="form-control" name="name" value="{$sampleSearch.name}" title="{t}uid, identifiant principal, identifiants secondaires (p. e. : cab:15 possible){/t}">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label for="uid_min" class="col-sm-3 control-label">{t}UID entre :{/t}</label>
                        <div class="col-sm-3">
                            <input id="uid_min" name="uid_min" class="nombre form-control" value="{$sampleSearch.uid_min}">
                        </div>
                        <div class="col-sm-3">
                            <input id="uid_max" name="uid_max" class="nombre form-control" value="{$sampleSearch.uid_max}">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label for="collection_id" class="col-sm-3 control-label">{t}Collection :{/t}</label>
                        <div class="col-sm-6">
                            <select id="collection_id" name="collection_id" class="form-control">
                            <option value="" {if $sampleSearch.collection_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
                            {section name=lst loop=$collections}
                            <option value="{$collections[lst].collection_id}" {if $collections[lst].collection_id == $sampleSearch.collection_id}selected{/if}>
                            {$collections[lst].collection_name}
                            </option>
                            {/section}
                            </select>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label for="object_status_id" class="col-sm-3 control-label">{t}Statut :{/t}</label>
                        <div class="col-sm-2">
                            <select id="object_status_id" name="object_status_id" class="form-control">
                            <option value="" {if $sampleSearch.object_status_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
                            {section name=lst loop=$objectStatus}
                            <option value="{$objectStatus[lst].object_status_id}" {if $objectStatus[lst].object_status_id == $sampleSearch.object_status_id}selected{/if}>
                            {$objectStatus[lst].object_status_name}
                            </option>
                            {/section}
                            </select>
                        </div>
                        <label for="trashed" class="col-sm-2 control-label" title="{t}Échantillons mis à la corbeille ?{/t}">{t}Corbeille ?{/t}</label>
                        <div class="col-sm-2">
                            <select id="trashed" name="trashed" class="form-control">
                                <option value="" {if $sampleSearch.trashed == ""}selected{/if}>{t}Tous{/t}</option>
                                <option value="1" {if $sampleSearch.trashed == "1"}selected{/if}>{t}Oui{/t}</option>
                                <option value="0" {if $sampleSearch.trashed == "0"}selected{/if}>{t}Non{/t}</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tab-pane fade" id="navsearch-type" role="tabpanel" aria-labelledby="tabsearch-type">

            </div>
            <div class="tab-pane fade" id="navsearch-divers" role="tabpanel" aria-labelledby="tabsearch-divers">

            </div>
            <div class="tab-pane fade" id="navsearch-loc" role="tabpanel" aria-labelledby="tabsearch-loc">

            </div>
        <div class="row">
            <div class="col-sm-offset-3 col-sm-6 center">
                <input type="submit" class="btn btn-success" value="{t}Rechercher{/t}">
                <button type="button" id="razid" class="btn btn-warning">{t}RAZ{/t}</button>
            </div>
        </div>
    </div>
    </form>
</div>