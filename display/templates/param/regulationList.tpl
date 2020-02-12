<h2>{t}Réglementations applicables{/t}</h2>
<div class="row">
	<div class="col-md-6">
    {if $droits.param == 1}
      <a href="index.php?module=regulationChange&regulation_id=0">
        {t}Nouveau...{/t}
      </a>
    {/if}
    <table id="regulationList" class="table table-bordered table-hover datatable " >
      <thead>
        <tr>
          <th>{t}Nom{/t}</th>
          <th>{t}Id{/t}</th>
          <th>{t}Description{/t}</th>
        </tr>
      </thead>
      <tbody>
        {foreach $data as $row}
          <tr>
            <td>
              {if $droits.param == 1}
                <a href="index.php?module=regulationChange&regulation_id={$row.regulation_id}">
                  {$row.regulation_name}
                </a>
              {else}
                {$row.regulation_name}
              {/if}
            </td>
            <td class="center">{$row.regulation_id}</td>
            <td class="textareaDisplay">{$row.regulation_comment}</td>
          </tr>
        {/foreach}
      </tbody>
    </table>
  </div>
</div>
