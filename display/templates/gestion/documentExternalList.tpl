<table id="documentList" class="table table-bordered table-hover datatable" data-order='[[5, "desc"], [4, "desc"]]'>
  <thead>
    <tr>
      <th>{t}Nom du document{/t}</th>
      <th>{t}Description{/t}</th>
      <th>{t}Taille{/t}</th>
      <th>{t}Date
        d'import{/t}</th>
      <th>{t}Date
        de création{/t}</th>
      {if $droits["gestion"] == 1 && $modifiable == 1 }
      <th>{t}Supprimer{/t}</th>
      {/if}
    </tr>
  </thead>
  <tbody>
    {section name=lst loop=$dataDoc}
    <tr>
        <a href="index.php?module=documentGet&document_id={$dataDoc[lst].document_id}&attached=1&phototype=0"
          title="{t}document original{/t}">
          {$dataDoc[lst].document_name}
        </a>
      </td>
      <td>{$dataDoc[lst].document_description}</td>
      <td>{$dataDoc[lst].size}</td>
      <td>{$dataDoc[lst].document_import_date}</td>
      <td>{$dataDoc[lst].document_creation_date}</td>
      {if $droits["gestion"] == 1 && $modifiable == 1}
      <td>
        <div class="center">
          <a href="index.php?module={$moduleParent}documentDelete&document_id={$dataDoc[lst].document_id}&uid={$data.uid}&campaign_id={$data.campaign_id}&activeTab=tab-document"
            onclick="return confirm('{t}Confirmez-vous la suppression ?{/t}');">
            <img src="display/images/corbeille.png" height="20">
          </a>
        </div>
      </td>
      {/if}
    </tr>
    {/section}
  </tbody>
</table>
