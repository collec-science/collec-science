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
<fieldset class="row col-lg-6">
    <legend>{t}Emprunts d'échantillons{/t}</legend>
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
</fieldset>
<fieldset class="row col-lg-6">
    <legend>{t}Emprunts de sous-échantillons{/t}</legend>
    <table id="subsampleList" class="table table-bordered table-hover datatable " data-order='[[0,"asc"]]' >
        <thead>
            <tr>
                <th>{t}Date{/t}</th>
                <th>{t}Échantillon concerné{/t}</th>
                <th>{t}Mouvement{/t}</th>
                <th>{t}Quantité{/t}</th>
                <th>{t}Commentaire{/t}</th>
                <th>{t}Réalisé par{/t}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $subsamples as $subsample}
                <tr>
                    <td>{$subsample.subsample_date}</td>
                    <td>
                        <a href="index.php?module=sampleDisplay&uid={$subsample.uid}">
                            {$subsample.uid} - {$subsample.identifier}
                        </a>
                    </td>
                    <td>
                        {if $subsample.movement_type_id == 1}
                            <span class="green">{t}Déplacement{/t}</span>
                        {else}
                            <span class="red">{t}Sortie du stock{/t}</span>
                        {/if}
                    </td>
                    <td >
                        {$subsample.subsample_quantity}
                    </td>
                    <td>
                        <span class="textareaDisplay">{$subsample.subsample_comment}</span>
                    </td>
                    <td>{$subsample.subsample_login}</td>
                </tr>
            {/foreach}
        </tbody>
    </table>
</fieldset>
