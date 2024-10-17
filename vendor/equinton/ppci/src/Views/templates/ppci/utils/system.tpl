<script >
  scroll = "75vh";
</script>
<div class="col-md-12">
  <div class="row">
  <table class="datatable-nopaging display table table-bordered table-hover">
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
</div>
