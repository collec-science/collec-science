<table id="datasetColumnList" class="table table-bordered table-hover datatable-nopaging " data-order='[[6,"asc"]]'>
  <thead>
    <tr>
      <th>{t}Nom de la colonne{/t}</th>
      <th class="lexical" data-lexical="metadata">{t}Nom de la variable si metadata{/t}</th>
      <th>{t}Nom dans le fichier d'export{/t}</th>
      <th class="lexical" data-lexical="translationTable">{t}Nom de la table de correspondance{/t}</th>
      <th>{t}Contenu obligatoire ?{/t}</th>
      <th>{t}Valeur par défaut{/t}</th>
      <th>{t}Ordre de tri dans le fichier d'export{/t}</th>
    </tr>
  </thead>
  <tbody>
    {foreach $columns as $c}
      <tr>
        <td>
          <a href="index.php?module=datasetColumnChange&dataset_column_id={$c.dataset_column_id}&dataset_template_id={$data.dataset_template_id}">
            {$c.column_name}
          </a>
        </td>
        <td>{$c.metadata_name}</td>
        <td>{$c.export_name}</td>
        <td>{$c.translator_name}</td>
        <td class="center">{if $c.mandatory == 1}{t}oui{/t}{/if}</td>
        <td>{$c.default_value}</td>
        <td class="center">{$c.column_order}</td>
      </tr>
    {/foreach}
  </tbody>
</table>