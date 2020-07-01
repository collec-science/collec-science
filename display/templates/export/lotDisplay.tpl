<h2>Affichage d'un lot</h2>
<div class="row">
  <a href="index.php?module=lotList"><img src="display/images/list.png" height="25">{t}Retour à la liste des lots{/t}</a>
</div>
<div class="row">
  <div class="col-md-6 form-display">
    <dl class="dl-horizontal">
      <dt>{t}Collection :{/t}</dt>
      <dd>{$data.collection_name}</dd>
    </dl>
    <dl class="dl-horizontal">
      <dt>{t}Date de création{/t}</dt>
      <dd>{$data.lotdate}</dd>
    </dl>
    <dl class="dl-horizontal">
      <dt>{t}Nombre d'échantillons :{/t}</dt>
      <dd>{$data.sample_number}</dd>
    </dl>
    <div class="center">
      <form id="lotForm" action="index.php" class="form-horizontal" method="POST">
        <input type="hidden" name="moduleBase" value="lot">
        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
        <input type="hidden" name="action" value="delete">
      </form>
    </div>
  </div>
</div>
<fieldset class="col-md-6">
  <div class="row">
    <a href="index.php?module=exportChange&export_id=0&lot_id={$data.lot_id}">{t}Nouvel export...{/t}</a>
  </div>
  <div class="row">
    <table class="table table-bordered table-hover datatable" data-order='[[1,"desc"]]'>
      <thead>
        <tr>
          <th class="center"><img src="display/images/edit.gif" height="25"></th>
          <th>{t}Date du dernier export{/t}</th>
          <th>{t}Type d'export{/t}</th>
          <th class="center"><img src="display/images/exec.png" height="25"></th>
        </tr>
      </thead>
      <tbody>
        {foreach $exports as $export}
          <tr>
            <td class="center">
              <a href="index.php?module=exportChange&export_id={$export.export_id}&lot_id={$export.lot_id}">
                  <img src="display/images/edit.gif" height="25">
              </a>
            </td>
            <td>{$export.export_date}</td>
            <td>{$export.export_template_name}</td>
            <td>
              <a href="index.php?module=exportExec&export_id={$export.export_id}&lot_id={$export.lot_id}">
                  <img src="display/images/exec.png" height="25">
              </a>
            </td>
          </tr>
        {/foreach}
      </tbody>
    </table>
  </div>
</fieldset>

