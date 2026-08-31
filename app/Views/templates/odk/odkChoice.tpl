<div class="row">
    <table id="odkChoices" class="table table-bordered table-hover datatable display" data-order='[[0,"asc"],[1,"asc"]]'>
        <thead>
            <tr>
                <th>{t}Nom de la rubrique{/t}</th>
                <th>{t}Nom affiché{/t}</th>
                <th>{t}Valeur correspondante{/t}</th>
                <th>{t}Filtre{/t}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $choices as $choice}
            <tr>
                <td>{$choice.name}</td>
                <td>{$choice.label}</td>
                <td>{$choice.choice_name}</td>
                <td>{$choice.choice_filter}</td>
            </tr>
            {/foreach}
        </tbody>
    </table>
</div>