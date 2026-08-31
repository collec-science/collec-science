<div class="row">
    <table id="odkLines" class="table table-bordered table-hover datatable display" data-order='[[1,"asc"]]'>
        <thead>
            <tr>
                <th>{t}Type{/t}</th>
                <th>{t}ordre de tri{/t}</th>
                <th>{t}Nom technique{/t}</th>
                <th>{t}Libellé affiché{/t}</th>
                <th>{t}Valeur par défaut{/t}</th>
                <th>{t}Requis{/t}</th>
                <th>{t}Dépendance{/t}</th>
                <th>{t}Contrainte{/t}</th>
                <th>{t}Message lié à la contrainte{/t}</th>
                <th>{t}Apparence{/t}</th>
                <th>{t}Règle de calcul{/t}</th>
                <th>{t}message d'aide{/t}</th>
                <th>{t}Lecture seule{/t}</th>
                <th>{t}Filtre de sélection{/t}</th>
                <th>{t}Nombre de répétitions{/t}</th>
                <th>{t}Paramètres complémentaires{/t}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $lines as $line}
            <tr>
                <td>{$line.line_type}</td>
                <td>{$line.line_order}</td>
                <td>{$line.line_name}</td>
                <td>{$line.line_label}</td>
                <td>{$line.line_default}</td>
                <td>{$line.line_required}</td>
                <td>{$line.line_relevant}</td>
                <td>{$line.line_constraint}</td>
                <td>{$line.line_constraint_message}</td>
                <td>{$line.line_appearance}</td>
                <td>{$line.line_calculation}</td>
                <td>{$line.line_hint}</td>
                <td>{$line.line_read_only}</td>
                <td>{$line.line_choice_filter}</td>
                <td>{$line.line_repeat_count}</td>
                <td>{$line.line_parameters}</td>
            </tr>
            {/foreach}
        </tbody>
    </table>
</div>