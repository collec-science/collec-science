<a href="appliList">
    <img src="display/images/list.png" height="25">
    {t}Retour à la liste des applications{/t}
</a>
<h2>{t}Liste des droits disponibles pour l'application{/t}
    <a href="appliChange?aclappli_id={$data.aclappli_id}">
        {$data.appli} {if $data.applidetail}({$data.applidetail}){/if}
    </a>
</h2>
<div class="col-md-6">
    <a href="appliChange?aclappli_id={$data.aclappli_id}">
        <img src="display/images/edit.gif" height="25">
        {t}Modifier...{/t}
    </a>
    {if $newRightEnabled == 1}
        <a href="acoChange?aclaco_id=0&aclappli_id={$data.aclappli_id}">
            <img src="{$display}/images/new.png" height="25">
            {t}Nouveau droit...{/t}
        </a>
    {/if}
    <table id="acoliste" class="table table-bordered table-hover datatable display">
        <thead>
            <tr>
                <th>{t}Nom du droit d'accès{/t}</th>
            </tr>
        </thead>
        <tbody>
            {section name=lst loop=$dataAco}
                <tr>
                    <td>
                        <a href="acoChange?aclaco_id={$dataAco[lst].aclaco_id}&aclappli_id={$data.aclappli_id}">
                            {$dataAco[lst].aco}
                        </a>
                    </td>
                </tr>
            {/section}
        </tbody>
    </table>
</div>