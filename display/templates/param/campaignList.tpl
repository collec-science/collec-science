<h2>{t}Campagnes de prélèvement{/t}</h2>
<div class="row">
	<div class="col-md-6">
    {if $droits.param == 1}
      <a href="index.php?module=campaignChange&campaign_id=0">
        {t}Nouveau...{/t}
      </a>
    {/if}
    <table id="campaignList" class="table table-bordered table-hover datatable " >
      <thead>
        <tr>
          <th>{t}Nom{/t}</th>
          <th>{t}Id{/t}</th>
          <th>{t}Responsable{/t}</th>
          <th>{t}du{/t}</th>
          <th>{t}au{/t}</th>
          <th class="lexical" data-lexical="uuid">{t}UUID{/t}</th>
          {if $droits.param == 1}
            <th>{t}Modifier{/t}</th>
          {/if}
        </tr>
      </thead>
      <tbody>
        {foreach $data as $row}
          <tr>
            <td>
                <a href="index.php?module=campaignDisplay&campaign_id={$row.campaign_id}">
                  {$row.campaign_name}
                </a>
            </td>
            <td class="center">{$row.campaign_id}</td>
            <td class="textareaDisplay">{$row.referent_name}</td>
            <td class="center nowrap">{$row.campaign_from}</td>
            <td class="center nowrap">{$row.campaign_to}</td>
            <td class="nowrap">{$row.uuid}</td>
            {if $droits.param == 1}
              <td class="center">
                <a href="index.php?module=campaignChange&campaign_id={$row.campaign_id}" title="{t}Modifier{/t}">
                  <img src="display/images/edit.gif" height="25" alt="{t}Modifier{/t}">
                </a>
              </td>
            {/if}
          </tr>
        {/foreach}
      </tbody>
    </table>
  </div>
</div>
