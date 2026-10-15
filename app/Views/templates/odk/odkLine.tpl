<div class="row">
    <form id="linesEdit" method="post" action="odkLinesWrite">
         {$csrf}
        <input type="hidden" name="odk_id" value="{$data.odk_id}">
        <div class="row d-flex justify-content-center">
            <div class="col-auto">
                <button type="submit" class="btn btn-primary button-valid">{t}Enregistrer les modifications{/t}</button>
            </div>
        </div>
        <table id="odkLines" class="table table-bordered table-hover datatable-nopaging-nosort display" >
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
                    <td><input type="hidden" name="line_type-{$line.odk_line_id}" value="{$line.line_type}">
                        {$line.line_type}
                    </td>
                    <td><input  name="line_order-{$line.odk_line_id}" value="{$line.line_order}" required></td>
                    <td>
                        <input type="hidden" name="line_name-{$line.odk_line_id}" value="{$line.line_name}">
                        {$line.line_name}
                    </td>
                    <td><input name="line_label-{$line.odk_line_id}" value="{$line.line_label}"></td>
                    <td><input name="line_default-{$line.odk_line_id}" value="{$line.line_default}"></td>
                    <td><input name="line_required-{$line.odk_line_id}" value="{$line.line_required}"></td>
                    <td><textarea name="line_relevant-{$line.odk_line_id}">{$line.line_relevant}</textarea></td>
                    <td><input name="line_constraint-{$line.odk_line_id}" value="{$line.line_constraint}"></td>
                    <td><textarea name="line_constraint_message-{$line.odk_line_id}">{$line.line_constraint_message}</textarea></td>
                    <td><input name="line_appearance-{$line.odk_line_id}" value="{$line.line_appearance}"></td>
                    <td><textarea name="line_calculation-{$line.odk_line_id}">{$line.line_calculation}</textarea></td>
                    <td><textarea name="line_hint-{$line.odk_line_id}">{$line.line_hint}</textarea></td>
                    <td><input name="line_read_only-{$line.odk_line_id}" value="{$line.line_read_only}"></td>
                    <td><input name="line_choice_filter-{$line.odk_line_id}" value="{$line.line_choice_filter}"></td>
                    <td><input name="line_repeat_count-{$line.odk_line_id}" value="{$line.line_repeat_count}"></td>
                    <td><input name="line_parameters-{$line.odk_line_id}" value="{$line.line_parameters}"></td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </form>
</div>