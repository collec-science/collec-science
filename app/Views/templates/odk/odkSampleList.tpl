<div class="row">
    <!--List of sample types-->
    {$maxSortOrder = 0}
    <table class="table table-bordered table-hover datatable-nopaging-nosearching" id="odkSamples" data-order='[[1,"asc"],[0,"asc"]]'>
        <thead>
            <tr>
                <th>{t}Type d'échantillon{/t}</th>
                <th>{t}Ordre d'affichage{/t}</th>
                <th>{t}Radical de l'identifiant métier{/t}</th>
                <th>{t}Ajout d'images{/t}</th>
                <th>{t}Ajout de vidéos{/t}</th>
                <th>{t}Ajout de prises sonores{/t}</th>
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
                <td class="center">{if $sample.with_picture == 1}{t}oui{/t}{else}{t}non{/t}{/if}</td>
                <td class="center">{if $sample.with_video == 1}{t}oui{/t}{else}{t}non{/t}{/if}</td>
                <td class="center">{if $sample.with_sound == 1}{t}oui{/t}{else}{t}non{/t}{/if}</td>
            </tr>
            {if $sample.sampletype_order > $maxSortOrder}
            {$maxSortOrder = $sample.sampletype_order}
            {/if}
            {/foreach}
        </tbody>
    </table>
</div>