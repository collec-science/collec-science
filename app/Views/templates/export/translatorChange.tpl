<script>
    $(document).ready(function () {
        var nameid = 10000;
        $(document).on("keyup", function (e) {
            var target = $(e.target);

            /**
             * Add a new line in multiple values
             */
            if (target.is('.name:last-child') && $(target).val().length && $(target).data("ligne") == $("#tableitems tbody tr:last-child").data("ligne")) {
                var table = document.getElementById("tableitems");
                var row = document.createElement("tr");
                row.dataset.ligne = nameid;
                table.tBodies[0].appendChild(row);
                const cell1 = row.insertCell(-1);
                const el1 = document.createElement("input");
                el1.classList.add("name");
                el1.classList.add("form-control");
                el1.name = "name[]";
                el1.id = "name" + nameid;
                el1.dataset.ligne = nameid;
                cell1.appendChild(el1);
                const cell2 = row.insertCell(-1);
                const el2 = document.createElement("input");
                el2.name = "value[]";
                el2.classList.add("form-control");
                el2.id = "value" + nameid;
                cell2.appendChild(el2);
                nameid++;
            }
        });
    });
</script>
<div class="container">
    <h2>{t}Modification d'une table de correspondance{/t}</h2>
    <div class="row d-flex">
        <div class="col-auto">
            <a href="translatorList">
                <img src="display/images/list.png" height="25">
                {t}Retour à la liste{/t}
            </a>
        </div>
    </div>
    <div class="row">
        <form id="translatorId" class="form-horizontal" action="translatorWrite" method="POST">
            <input type="hidden" name="moduleBase" value="translator">
            <input type="hidden" name="translator_id" value="{$data.translator_id}">
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
            </div>
            <div class="row">
                <label for="translatorName" class="form-label col-4"><span class="red">*</span> {t}Nom :{/t}</label>
                <div class="col-8">
                    <input id="translatorName" type="text" class="form-control" name="translator_name" value="{$data.translator_name}" autofocus required>
                </div>
            </div>
            <table class="table table-bordered datatable-nopaging display" id="tableitems">
                <thead>
                    <tr>
                        <th>{t}Libellé dans la base de données{/t}</th>
                        <th>{t}Libellé exporté{/t}</th>
                    </tr>
                </thead>
                <tbody>
                    {$numligne = 0}
                    {foreach $items as $item}
                    <tr id="tr{$numligne}"  data-ligne="{$numligne}">
                        <td>
                            <input class="name form-control" id="name{$numligne}" name="name[]" value="{$item.name}" data-ligne="{$nameid}">
                        </td>
                        <td>
                            <input class="value form-control" id="value{$numligne}" name="value[]" value="{$item.value}">
                        </td>
                    </tr>
                    {$numligne = $numligne + 1}
                    {/foreach}
                    <tr id="tr5000"  data-ligne="5000">
                        <td>
                            <input class="name form-control" id="name5000" name="name[]" data-ligne="5000" value="">
                        </td>
                        <td>
                            <input class="value form-control" id="value5000" name="value[]" value="">
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>

                {if $data.translator_id > 0 }
                <div class="col-auto">
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                </div>
                {/if}
            </div>
            {$csrf}
        </form>
    </div>
</div>