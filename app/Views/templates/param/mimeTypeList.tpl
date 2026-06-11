<div class="container">
    <h2>{t}Types de fichiers importables{/t}</h2>
    <div class="row">
        {if $rights.param == 1}
        <a href="mimeTypeChange?mime_type_id=0">
            <img src="display/images/new.png" height="25">
            {t}Nouveau...{/t}
        </a>
        {/if}
    </div>
    <table id="mimeTypeList" class="table table-bordered table-hover datatable display">
        <thead>
            <tr>
                <th>{t}Extension{/t}</th>
                <th>{t}Type mime associé{/t}</th>
            </tr>
        </thead>
        <tbody>
            {section name=lst loop=$data}
            <tr>
                <td>
                    {if $rights.param == 1}
                    <a href="mimeTypeChange?mime_type_id={$data[lst].mime_type_id}">
                        {$data[lst].extension}
                        {else}
                        {$data[lst].extension}
                        {/if}
                </td>
                <td>{$data[lst].content_type}</td>
            </tr>
            {/section}
        </tbody>
    </table>
    <div class="row bg-info">
        <div class="col-auto">
            {t}La liste officielle des types de média utilisables peut être consultée ici : {/t}
        </div>
        <div class="col-auto">
            <a href="https://www.iana.org/assignments/media-types/media-types.xhtml" target="_blank">https://www.iana.org/assignments/media-types/media-types.xhtml</a>

        </div>
    </div>
</div>