<h2>{t}Liste des emprunts réalisés par {/t}<i>{$data.borrower_name}</i></h2>
<div class="row">
    <a href="index.php?module=borrowerList">
            <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    &nbsp;
    <a href="index.php?module=borrowerChange&borrower_id={$data.borrower_id}">
        <img src="display/images/edit.gif" height="25">
        {t}Modifier l'emprunteur{/t}
    </a>
</div>
<div class="row">
    <div class="form-display col-md-6">
        <dl class="dl-horizontal">
            <dt>{t}Nom :{/t}</dt>
            <dd>{$data.borrower_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Adresse :{/t}</dt>
            <dd>
                <textarea class="textareadisplay col-md-12" rows="5">{$data.borrower_address}</textarea>
            </dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Téléphone :{/t}</dt>
            <dd>{$data.borrower_phone}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Mail :{/t}</dt>
            <dd>{$data.borrower_mail}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Code du laboratoire :{/t}</dt>
            <dd>{$data.laboratory_code}</dd>
        </dl>
    </div>
</div>
<div class="row col-md-8">
    <table class="table datatable table-bordered table-hover" data-sort='[[0,"desc"]]'>
        <thead>
            <tr>
                <th>{t}Date du prêt{/t}</th>
                <th>{t}Objet emprunté{/t}</th>
                <th>{t}Type{/t}</th>
                <th>{t}Date de retour prévue{/t}</th>
                <th>{t}Date de retour{/t}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $borrowings as $borrowing}
                <tr>
                    <td class="center">{$borrowing.borrowing_date}</td>
                    <td>
                        <a href="index.php?module={if $borrowing.object_type=='sample'}sampleDisplay{else}containerDisplay{/if}&uid={$borrowing.uid}">
                            {$borrowing.uid} {$borrowing.identifier}
                        </a>
                    </td>
                    <td>{$borrowing.name_type}</td>
                    <td class="center">{$borrowing.expected_return_date}</td>
                    <td class="center">{$borrowing.return_date}</td>
                </tr>
            {/foreach}
        </tbody>
    </table>
</div>