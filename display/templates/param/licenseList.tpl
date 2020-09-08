<h2>{t}Licences utilisables pour publier les collections{/t}</h2>
<div class="row">
  <div class="col-md-6">
    {if $droits.param == 1}
    <a href="index.php?module=licenseChange&license_id=0">
      {t}Nouveau...{/t}
    </a>
    {/if}
    <table id="licenseList" class="table table-bordered table-hover datatable">
      <thead>
        <tr>
          <th>{t}Code{/t}</th>
          <th>{t}URL{/t}</th>
        </tr>
      </thead>
      <tbody>
        {section name=lst loop=$data}
        <tr>
          <td>
            {if $droits.param == 1}
            <a href="index.php?module=licenseChange&license_id={$data[lst].license_id}">
              {$data[lst].license_name}
              {else}
              {$data[lst].license_name}
              {/if}
          </td>
          <td>{$data[lst].license_url}</td>
        </tr>
        {/section}
      </tbody>
    </table>
  </div>
</div>