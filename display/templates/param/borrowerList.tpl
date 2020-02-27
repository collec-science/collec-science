<h2>{t}Emprunteurs{/t}</h2>
<div class="row">
    <div class="col-md-6">
        {if $droits.param == 1}
            <a href="index.php?module=borrowerChange&borrower_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
        {/if}
        <table id="borrowerList" class="table table-bordered table-hover datatable " >
            <thead>
                <tr>
                    <th>{t}Nom{/t}</th>
                    <th>{t}Adresse{/t}</th>
                    <th>{t}Téléphone{/t}</th>
                    <th>{t}Mail{/t}</th>
                    <th>{t}Code du laboratoire{/t}</th>
                    <th>{t}Objets empruntés{/t}</th>
                    {if $droits.param == 1}
                        <th>{t}Modifier{/t}</th>
                    {/if}
                </tr>
            </thead>
            <tbody>
                {section name=lst loop=$data}
                    <tr>
                        <td>{$data[lst].borrower_name}</td>
                        <td>
                            <span class="textareaDisplay">{$data[lst].borrower_address}</span>
                        </td>
                        <td>{$data[lst].borrower_phone}</td>
                        <td>{$data[lst].borrower_mail}</td>
                        <td>{$data[lst].laboratory_code}</td>
                        <td class="center">
                            <a href="index.php?module=borrowerDisplay&borrower_id={$data[lst].borrower_id}">
                                <img src="display/images/list.png" height="25">
                            </a>
                        </td>
                        {if $droits.param == 1}
                            <td class="center">
                                <a href="index.php?module=borrowerChange&borrower_id={$data[lst].borrower_id}">
                                    <img src="display/images/edit.gif" height="25">
                                </a>
                            </td>
                        {/if}
                    </tr>
                {/section}
            </tbody>
        </table>
    </div>
</div>