<div class="container">
    <h2>{t}Licences utilisables pour publier les collections{/t}</h2>
    <div class="row">
        <div class="col-auto">
            {if $rights.param == 1}
            <a href="licenseChange?license_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
            {/if}
            <table id="licenseList" class="table table-bordered table-hover datatable display">
                <thead>
                    <tr>
                        <th>{t}Code{/t}</th>
                        <th>{t}URL{/t}</th>
                    </tr>
                </thead>
                <tbody>
                    {section name=lst loop=$data}
                    <tr>
                        <td>
                            {if $rights.param == 1}
                            <a href="licenseChange?license_id={$data[lst].license_id}">
                                {$data[lst].license_name}
                                {else}
                                {$data[lst].license_name}
                                {/if}
                        </td>
                        <td>{$data[lst].license_url}</td>
                    </tr>
                    {/section}
                </tbody>
            </table>
        </div>
    </div>
</div>