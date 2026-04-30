<div class="container-fluid">
    <h2>{t}Types de datasets{/t}</h2>
    <div class="row">
        <a href="datasetTypeChange?dataset_type_id=0">
            <img src="display/images/new.png" height="25">
            {t}Nouveau...{/t}
        </a>
        <table id="datasetTypeList" class="table table-bordered table-hover datatable-nopaging-nosearching display">
            <thead>
                <tr>
                    <th>{t}Nom{/t}</th>
                    <th>{t}Champs exportables{/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $data as $row}
                <tr>
                    <td>
                        <a href="datasetTypeChange?dataset_type_id={$row.dataset_type_id}">
                            {$row.dataset_type_name}
                        </a>
                    </td>
                    <td>{$row.fields}</td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>