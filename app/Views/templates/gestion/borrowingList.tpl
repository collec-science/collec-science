<a href="{$moduleParent}borrowingChange?uid={$data.uid}&borrowing_id=0">
    <img src="display/images/new.png" height="25">
    {t}Nouveau prêt{/t}
</a>
<table class="table datatable table-bordered table-hover" data-sort='[[0,"desc"]]'>
    <thead>
        <tr>
            <th>{t}Date du prêt{/t}</th>
            <th>{t}Emprunteur{/t}</th>
            <th>{t}Date de retour prévue{/t}</th>
            <th>{t}Commentaire{/t}</th>
            <th>{t}Date de retour{/t}</th>
        </tr>
    </thead>
    <tbody>
        {foreach $borrowings as $borrowing}
        <tr>
            <td class="center">
                <a href="{$moduleParent}borrowingChange?uid={$data.uid}&borrowing_id={$borrowing.borrowing_id}">
                    {$borrowing.borrowing_date}
                </a>
            </td>
            <td>
                <a href="borrowerDisplay?borrower_id={$borrowing.borrower_id}">
                    {$borrowing.borrower_name}
                </a>
            </td>
            <td class="center">{$borrowing.expected_return_date}</td>
            <td>
                <span class="textareaDisplay">{$borrowing.borrowing_comment}</span>
            </td>
            <td class="center">{$borrowing.return_date}</td>
        </tr>
        {/foreach}
    </tbody>
</table>