<script>
    $(document).ready(function () {
        $("#importOption").change(function () {
            var opt = $(this).val();
            if (opt == "other") {
                $("#upfile").prop("disabled", false);
                $("#upfile").prop("required", true);
            } else {
                $("#upfile").prop("disabled", true);
                $("#upfile").prop("required", false);
            }
        });
    });
</script>
<div class="container">
    <div class="row">
        <div class="col-auto">
            <h2>{t}Liste des pays{/t}</h2>
        </div>
        <div class="col-auto">
            {$help}
        </div>
    </div>
    <div class="row">
        <table id="countryList" class="table table-bordered table-hover datatable-searching display" data-order='[[1,"asc"]]'>
            <thead>
                <tr>
                    <th>{t}Code numérique{/t}</th>
                    <th>{t}Nom du pays{/t}</th>
                    <th>{t}Code (2 positions){/t}</th>
                    <th>{t}Code (3 positions){/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $countries as $country}
                <tr>
                    <td>{$country.country_id}</td>
                    <td>{$country.country_name}</td>
                    <td>{$country.country_code2}</td>
                    <td>{$country.country_code3}</td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
    <div class="row bg-info">

        <span class="col-inline">
            {t}La liste des pays est fournie en français. Vous pouvez la remplacer par une liste en anglais (pré-installée).{/t}
            <br>
            {t}Si vous souhaitez la remplacer par une liste dans une autre langue, vous pouvez la télécharger ici :{/t}
            <a href="https://stefangabos.github.io/world_countries" target="_blank">https://stefangabos.github.io/world_countries</a>
        </span>
    </div>
    {if $rights.param == 1}
    <div class="row">
        <form class="form-horizontal" method="post" enctype="multipart/form-data" action="countryImport" id="countryImport">
            <div class="row">
                <label for="importOption" class="form-label col-4">
                    {t}Type d'importation :{/t}
                </label>
                <div class="col-8">
                    <select class="form-select" id="importOption" name="importOption">
                        <option value="en">{t}Importer le fichier en anglais{/t}</option>
                        <option value="fr">{t}Importer le fichier en français{/t}</option>
                        <option value="other">{t}Importer un fichier téléchargé{/t}</option>
                    </select>
                </div>
            </div>
            <div class="row">
                <label for="upfile" class="form-label col-4">
                    {t}Fichier à importer :{/t}
                </label>
                <div class="col-8">
                    <input type="file" name="upfile" id="upfile" class="form-control" disabled>
                </div>
            </div>
            <div class="col-8 offset-4">
                {t}Le fichier téléchargé doit être au format CSV, séparateur virgule, avec les colonnes suivantes :{/t}
                <ul>
                    <li>{t}id : code numérique du pays{/t}</li>
                    <li>{t}alpha2 : code sur deux positions{/t}</li>
                    <li>{t}alpha3 : code sur trois positions{/t}</li>
                    <li>{t}name : nom du pays{/t}</li>
                </ul>
            </div>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Importer le fichier{/t}</button>
                </div>
            </div>
            {$csrf}
        </form>
        {/if}
    </div>
</div>