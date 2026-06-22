<div class="container">
    <h2>{t}Liste des tables de correspondance{/t}</h2>
    <div class="row">
        <div class="bg-info">
            {t}Les tables de correspondance permettent de remplacer un libellé présent dans la base de données par un libellé attendu dans le système d'informations destinataire de l'export{/t}
        </div>
    </div>

    <div class="row align-items-center">
        <div class="col-auto">
            <a href="translatorChange?translator_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
        </div>
        <div class="col-auto">
            {$help}
        </div>

    </div>
    <table id="translatorList" class="table table-bordered table-hover datatable display">
        <thead>
            <tr>
                <th>{t}Nom{/t}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $data as $row}
            <tr>
                <td>
                    <a href="translatorChange?translator_id={$row.translator_id}">
                        {$row.translator_name}
                    </a>
                </td>
            </tr>
            {/foreach}
        </tbody>
    </table>
</div>