<div class="row">
    <table id="odkChoices" class="table table-bordered table-hover datatable-nosort display" data-order='[[0,"asc"],[1,"asc"]]'>
        <thead>
            <tr>
                <th>{t}Nom de la rubrique{/t}</th>
                <th>{t}Valeur{/t}</th>
                <th>{t}Nom affiché{/t}</th>
                <th>{t}Filtre{/t}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $choices as $choice}
            <tr>
                <td>{$choice.list_name}</td>
                <td>{$choice.choice_name}</td>
                <td>{$choice.choice_label}</td>
                <td>{$choice.choice_filter}</td>
            </tr>
            {/foreach}
        </tbody>
    </table>
</div>