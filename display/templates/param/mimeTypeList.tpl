<h2>{t}Types de fichiers importables{/t}</h2>
<div class="row">
	<div class="col-md-6">
        {if $droits.param == 1}
            <a href="index.php?module=mimeTypeChange&mime_type_id=0">
            {t}Nouveau...{/t}
            </a>
        {/if}
        <table id="mimeTypeList" class="table table-bordered table-hover datatable" >
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
                            {if $droits.param == 1}
                                <a href="index.php?module=mimeTypeChange&mime_type_id={$data[lst].mime_type_id}">
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
    </div>
</div>