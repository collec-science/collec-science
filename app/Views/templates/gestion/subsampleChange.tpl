<script>
    $(document).ready(function () {
        function createEnable() {
            if ($("#with_create").is(":checked") && $(".movement_type:checked").val() == 2) {
                $("#created").show();
            } else {
                $("#created").hide();
            }
        }
        var sample_type_origin = "{$sample.sample_type_id}";
        function getSampletype() {
            var collection_id = $("#collection_id").val();
            $.ajax({
                url: "sampleTypeGetListAjax",
                data: { "collection_id": collection_id }
            })
                .done(function (value) {
                    d = JSON.parse(value);
                    var options = '';
                    for (var i = 0; i < d.length; i++) {
                        options += '<option value="' + d[i].sample_type_id + '"';
                        if (d[i].sample_type_id == sample_type_origin) {
                            options += ' selected ';
                        }
                        options += '>' + d[i].sample_type_name;
                        if (d[i].multiple_type_id > 0) {
                            options += ' / ' + d[i].multiple_type_name + ' : ' + d[i].multiple_unit;
                        }
                        options += '</option>';
                    };
                    $("#sample_type_id").html(options);
                });
        }
        function searchSample() {
            var uid = $("#uidsearch").val();
            var name = $("#namesearch").val();
            var createdsample = "{$data.created_sample_id}";
            var mode = "none";
            var val = "";
            if (uid > 0) {
                mode = "uid";
            } else if (name.length > 3) {
                mode = "name";
            } else if (createdsample > 0) {
                mode = "sample_id";
            }
            var options = '';
            /**
             * clean select field
             */
            $("#createdsample_id").html(options);
            if (mode != "none") {
                $.ajax({
                    url: "sampleSearchAjax",
                    data: {
                        uidsearch: uid,
                        name: name,
                        sample_id: createdsample
                    }
                }).done(function (value) {

                    d = JSON.parse(value);
                    if (d.length > 0) {
                        for (var i = 0; i < d.length; i++) {
                            options += '<option value="' + d[i].sample_id + '"' + '>';
                            options += d[i].uid + " " + d[i].identifier;
                            options += '</option>';
                        }
                        $("#createdsample_id").html(options);
                        $(".tocreate").prop("disabled", true);
                    } else {
                        $(".tocreate").prop("disabled", false);
                    }
                });
            }
        }
        $("#with_create").change(function () {
            createEnable();
        });
        $(".movement_type").change(function () {
            createEnable();
        });
        $("#collection_id").change(function () {
            getSampletype();
        });
        /**
         * Search for existent sample
         */
        $("#uidsearch").change(function () {
            searchSample();
        });
        $("#namesearch").change(function () {
            searchSample();
        });
        /**
         * Default
         */
        $("#collection_id").val("{$sample.collection_id}");
        getSampletype();
        $("#sample_type_id").val("{$sample.sample_type_id}");
        searchSample();
    });
</script>
<h2>{t}Création - modification d'un prélèvement ou d'une restitution de sous-échantillon{/t}</h2>

<div class="row">
    <div class="col-md-6">
        <a href="{$moduleListe}">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
        <a href="{$moduleParent}Display?uid={$sample.uid}">
            <img src="display/images/edit.gif" height="25">
            {t}Retour au détail{/t} ({$sample.uid} {$sample.identifier})
        </a>
        <form class="form-horizontal " id="subsampleForm" method="post" action="subsampleWrite">
            <input type="hidden" name="subsample_id" value="{$data.subsample_id}">
            <input type="hidden" name="sample_id" value="{$data.sample_id}">
            <input type="hidden" name="moduleBase" value="subsample">
            <input type="hidden" name="uid" value="{$sample.uid}">
            <input type="hidden" name="subsample_login" value="{$data.subsample_login}">

            <div class="form-group">
                <label for="subsampling_date" class="control-label col-md-4"><span class="red">*</span>
                    {t}Date :{/t}
                </label>
                <div class="col-md-8">
                    <input id="subsample_date" name="subsample_date" required value="{$data.subsample_date}"
                        class="form-control datetimepicker">
                </div>
            </div>

            <div class="form-group">
                <label for="movement_type_id" class="control-label col-md-4"><span class="red">*</span>
                    {t}Mouvement :{/t}
                </label>
                <div class="col-md-8">
                    <label class="radio-inline">
                        <input class="movement_type " type="radio" name="movement_type_id" id="movement_type_id1"
                            value="1" {if $data.movement_type_id==1}checked{/if}> {t}Entrée dans le stock{/t}
                    </label>
                    <label class="radio-inline">
                        <input type="radio" class="movement_type " name="movement_type_id" id="movement_type_id2"
                            value="2" {if $data.movement_type_id==2}checked{/if}> {t}Sortie du stock{/t}
                    </label>
                </div>
            </div>

            <div class="form-group">
                <label for="subsample_quantity" class="control-label col-md-4"><span class="red">*</span>
                    {t 1=$data.multiple_unit}Quantité (%1) :{/t}
                </label>
                <div class="col-md-8">
                    <input id="subsample_quantity" name="subsample_quantity" value="{$data.subsample_quantity}"
                        class="form-control taux">
                </div>
            </div>

            <div class="form-group">
                <label for="borrower_id" class="control-label col-md-4">{t}Emprunteur :{/t}</label>
                <div class="col-md-8">
                    <select id="borrower_id" name="borrower_id" class="form-control">
                        <option value="" {if $data.borrower_id=="" }selected{/if}>
                            {t}Choisissez...{/t}
                        </option>
                        {foreach $borrowers as $borrower}
                        <option value="{$borrower.borrower_id}" {if
                            $borrower.borrower_id==$data.borrower_id}selected{/if}>
                            {$borrower.borrower_name}
                        </option>
                        {/foreach}
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="subsample_comment" class="control-label col-md-4">{t}Commentaire :{/t}</label>
                <div class="col-md-8">
                    <textarea id="subsample_comment" name="subsample_comment" class="form-control"
                        rows="3">{$data.subsample_comment}</textarea>
                </div>
            </div>

            <div class="form-group">
                <label for="with_create" class="control-label col-md-4 lexical" data-lexical="composite">
                    {t}Avec création ou rattachement à un échantillon composé :{/t}
                </label>
                <div class="col-md-8 center">
                    <input type="checkbox" id="with_create" name="composite_create" value="1" class="form-control">
                </div>
            </div>

            <div id="created" hidden>
                <div class="form-group">
                    <label for="identifier" class="control-label col-md-4">{t}Identifiant ou nom :{/t}</label>
                    <div class="col-md-8">
                        <input id="identifier" type="text" name="identifier" class="form-control tocreate">
                    </div>
                </div>
                <div class="form-group">
                    <label for="collection_id" class="control-label col-md-4"><span class="red">*</span>
                        {t}Collection :{/t}</label>
                    <div class="col-md-8">
                        <select id="collection_id" name="collection_id" class="form-control tocreate" autofocus>
                            {foreach $collections as $collection}
                            <option value="{$collection.collection_id}">
                                {$collection.collection_name}
                            </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="sample_type_id" class="control-label col-md-4"><span class="red">*</span>
                        {t}Type :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="sample_type_id" name="sample_type_id" class="form-control tocreate">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="uidsearch" class="col-md-4 control-label">{t}Échantillon déjà existant - UID
                        :{/t}</label>
                    <div class="col-md-2">
                        <input id="uidsearch" name="uidsearch" class="form-control nombre">
                    </div>
                    <label for="namesearch" class="col-md-2 control-label">
                        {t}ou identifiant ou UUID :{/t}
                    </label>
                    <div class="col-md-4">
                        <input id="namesearch" type="text" class="form-control" name="name"
                            title="{t}identifiant principal, identifiants secondaires (p. e. : cab:15), UUID (p. e. : e1b1bdd8-d1e7-4f07-8e96-0d71e7aada2b){/t}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="uid" class="col-md-4 control-label">
                        {t}Échantillon composé correspondant :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="createdsample_id" name="createdsample_id" class="form-control">
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="multiple_value" class="control-label col-md-4">
                        {t 1=$data.multiple_unit}Quantité affectée à l'échantillon (%1):{/t}</label>
                    <div class="col-md-8">
                        <input id="multiple_value" class="form-control taux" name="multiple_value"
                            value="{$data.multiple_value}">
                    </div>
                </div>
            </div>

            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.subsample_id > 0 }
                <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
            {$csrf}
        </form>
    </div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>