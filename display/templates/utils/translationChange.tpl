<h2>{t}Liste des traductions des libellés des tables de références{/t}</h2>
<div class="row">
    <div class="col-lg-6">
        <form class="form-horizontal" id="translationForm" method="post" action="index.php">
            <input type="hidden" name="module" value="translationWrite">
            <input type="hidden" name="country" value="{$country}">
            <div class="row">
                <div class="col-lg-12">
                <table class="table table-bordered table-hover datatable-export" data-order='[[0,"asc"],[1,"asc"]]'>
                    <thead>
                        <tr>
                            <th>{t}Nom de la table{/t}</th>
                            <th>{t}Libellé d'origine{/t}</th>
                            <th>{t}Libellé traduit{/t}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {$i = 0}
                        {foreach $data as $row}
                        {$i = $i + 1}
                        <tr>
                            <td>{$row.tablename}</td>
                            <input type="hidden" name="id-{$i}-translation_id" id="id-{$i}-translation_id" value="{$row.translation_id}">
                            <td>
                                <input class="form-control" id="row-{$i}-initial_label" name="row-{$i}-initial_label"
                                    value="{$row.initial_label}" readonly>
                            </td>
                            <td>
                                <input class="form-control" id="row-{$i}-country_label" name="row-{$i}-country_label"
                                    value="{$row.country_label}">
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
                </div>
            </div>
            {if $droits.param == 1}
            <div class="row">
                <div class="form-group center">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
            </div>
            {/if}
        </form>
    </div>
</div>