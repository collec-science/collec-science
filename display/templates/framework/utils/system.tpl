<div class="col-md-12">
  <table class="datatable table table-bordered table-hover">
    <thead>
      <th>{t}Nom de la variable{/t}</th>
      <th>{t}Contenu{/t}</th>
    </thead>
    <tbody>
      {foreach from=$data key="k" item="v"}
      <tr>
        <td>{$k}</td>
        <td>{$v}</td>
      </tr>
      {/foreach}
    </tbody>
  </table>
</div>
