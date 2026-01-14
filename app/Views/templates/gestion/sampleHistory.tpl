<div class="row">
    <div class="col-md-12">
        <div class="bg-info">
            {t}Les valeurs dans le tableau sont celles qui existaient auparavant et qui ont été modifiées à la date indiquée, et non les valeurs saisies ce jour-là.{/t}
            {t}Les métadonnées sont en fin de tableau, après la colonne trashed.{/t}
            <br>
            {t}L'échantillon a été créé le {/t}{$data.sample_creation_date}
            {if strlen($data.object_login) > 0}{t} par le compte {/t}{$data.object_login}{/if}
        </div>
        <table class="table table-bordered table-hover datatable-nopaging display" data-order='[[0,"desc"]]'>
            <thead>
                <tr>
                    {foreach $histoheader as $h}
                    <th>{$h}</th>
                    {/foreach}
                </tr>
            </thead>
            <tbody>
                {foreach $histo as $row}
                <tr>
                    {foreach $histoheader as $h}
                    <td>
                        {$row[$h]}
                    </td>
                    {/foreach}
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>