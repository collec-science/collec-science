<div class="row">
    <!--List of sample types-->
    {$maxSortOrder = 0}
    <table class="table table-bordered table-hover datatable-nopaging-nosearching" id="odkSamples" data-order='[[1,"asc"],[0,"asc"]]'>
        <thead>
            <tr>
                <th>{t}Type d'échantillon{/t}</th>
                <th>{t}Ordre d'affichage{/t}</th>
                <th>{t}Radical de l'identifiant métier{/t}</th>
                <th>{t}Nombre d'images{/t}</th>
                <th>{t}Nombre de vidéos{/t}</th>
                <th>{t}Nombre de prises sonores{/t}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $odksampletypes as $sample}
            <tr {if $sample.odk_sampletype_id==$sampletypeCurrent} class="table-primary" {/if}>
                <td>
                    <a href="odkDisplay?odk_id={$data.odk_id}&odk_sampletype_id={$sample.odk_sampletype_id}">
                        {$sample.sample_type_name}
                    </a>
                </td>
                <td class="center">{$sample.sampletype_order}</td>
                <td>{$sample.identifier_prefix}</td>
                <td class="center">{$sample.image_number}</td>
                <td class="center">{$sample.video_number}</td>
                <td class="center">{$sample.sound_number}</td>
            </tr>
            {if $sample.sampletype_order > $maxSortOrder}
            {$maxSortOrder = $sample.sampletype_order}
            {/if}
            {/foreach}
        </tbody>
    </table>
</div>