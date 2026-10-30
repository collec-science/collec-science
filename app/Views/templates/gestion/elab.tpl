<script>
    $(document).ready(function () {
        /* Management of tabs */
        var myStorage = window.localStorage;
        var activeTab = "";
        try {
            activeTab = myStorage.getItem("elab");
        } catch (Exception) {
        }
        try {
            if (activeTab.length > 0) {
                $("#" + activeTab).tab('show');
            }
        } catch (Exception) { }
        $('.nav-link').on('shown.bs.tab', function () {
            myStorage.setItem("elab", $(this).attr("id"));
        });
        $("#collection_id").change(function () {
            getSampletype();
        });

        var sample_type_origin = "{$sample_type_id}";
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
        getSampletype();
        const result = document.getElementById("result");
        if ("{$model}".length == 0) {
            result.style.display = 'none';
        }

        const sampleType = document.getElementById('sample_type_id');
        sampleType.addEventListener("change", (event) => {
            var sampleTypeId = sampleType.value;
            if (sampleTypeId != sample_type_origin) {
                result.style.display = 'none';
            } else {
                result.style.display = '';
            }
        });
        /**
         * copy to clipboard function
         */
        // Initialise Bootstrap tooltips
        const copyBtn = document.getElementById('copyBtn');
        const copied = "{t}Copié !{/t}";
        const copy = "{t}Copier...{/t}";
        function copyModel() {
            navigator.clipboard.writeText(document.getElementById('model').value).then(() => {
                copyBtn.innerHTML = copied;
                setTimeout(() => {
                    copyBtn.innerHTML = copy;
                }, 2000);
            });
        }
        copyBtn.addEventListener("click", (event) => {
            copyModel();
        });
    });
</script>
<div class="container-fluid">
    <div class="row align-items-center">
        <div class="col-auto">
            <h2>{t}Importer les échantillons générés avec ElabFTW{/t}</h2>
        </div>
        <div class="col-auto">
            {$help}
        </div>
    </div>
    <!-- Tab box -->
    <ul class="nav nav-tabs" id="elabTab" role="tablist">
        <li class="nav-item ">
            <a class="nav-link active" id="tabmodel" data-bs-toggle="tab" role="tab" aria-controls="navmodel" aria-selected="true" href="#navmodel">
                {t}Informations générales{/t}
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tabimport" href="#navimport" data-bs-toggle="tab" role="tab" aria-controls="navimport" aria-selected="false">
                {t}Importation{/t}
            </a>
        </li>
    </ul>
    <div class="tab-content col-12 form-horizontal" id="tabContent">
        <div class="tab-pane active in" id="navmodel" role="tabpanel" aria-labelledby="tabmodel">

            <form action="elabModel" method="post" class="form-horizontal">
                <div class="row">
                    <label for="collection_id" class="col-4 form-label">{t}Collection :{/t}</label>
                    <div class="col-8">
                        <select id="collection_id" name="collection_id" class="form-select">
                            {foreach $collections as $collection}
                            <option value="{$collection.collection_id}" {if $collection.collection_id==$collection_id}selected{/if}>
                                {$collection.collection_name}
                            </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="row">
                    <label for="sample_type_id" class="form-label col-4">
                        {t}Type d'échantillon :{/t}
                    </label>
                    <div class="col-8">
                        <select id="sample_type_id" name="sample_type_id" class="form-select">

                        </select>
                    </div>
                </div>
                <fieldset id="result">
                    <legend>{t}À insérer dans le template de ressource d'ElabFTW{/t}</legend>
                    <div class="row" id="modelRow">
                    <label for="model" class="form-label col-4">
                        {t}Champ metadata :{/t}
                    </label>
                    <div class="col-6">
                        <textarea id="model" class="form-control" rows="10" readonly>{$model}</textarea>
                    </div>
                    <div class="col-2">
                        <button class="btn btn-outline-secondary" type="button" id="copyBtn">{t}Copier...{/t}</button>
                    </div>
                </div>
                </fieldset>
                
                <div class="row">
                    <div class="row d-flex justify-content-center">
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary button-valid">{t}Générer le code{/t}</button>
                        </div>
                    </div>
                </div>
                {$csrf}
            </form>
        </div>
    </div>
    <div class="tab-pane fade" id="navimport" role="tabpanel" aria-labelledby="tabimport">

    </div>
</div>