<h2>Affichage d'un lot</h2>
<div class="row">
  <a href="index.php?module=lotList"><img src="display/images/list.png" height="25">{t}Retour à la liste des lots{/t}</a>
</div>
<div class="row">
  <div class="col-md-6">
    <div class="form-display">
      <dl class="dl-horizontal">
        <dt>{t}Collection :{/t}</dt>
        <dd>{$data.collection_name}</dd>
      </dl>
      <dl class="dl-horizontal">
        <dt>{t}Date de création{/t}</dt>
        <dd>{$data.lot_date}</dd>
      </dl>
      <dl class="dl-horizontal">
        <dt>{t}Nombre d'échantillons :{/t}</dt>
        <dd>{$data.sample_number}</dd>
      </dl>
      <div class="center">
        <form id="lotForm" action="index.php"  method="POST">
          <input type="hidden" name="moduleBase" value="lot">
          <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
          <input type="hidden" name="action" value="delete">
        </form>
      </div>
    </div>
    <fieldset>
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
              <th>{t}Générer l'export{/t}</th>
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
                <td class="center">
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
  </div>
  <fiedset class="col-md-6">
    <legend>{t}Échantillons sélectionnés{/t}</legend>
    <table class="table table-bordered table-hover datatable">
      <thead>
        <tr>
          <th class="center">{t}uid{/t}</th>
          <th>{t}Identifiant métier{/t}</th>
          <th>{t}Type d'échantillon{/t}</th>
        </tr>
      </thead>
      <tbody>
        {foreach $samples as $sample}
          <tr>
            <td class="center">
              <a href="index.php?module=sampleDisplay&uid={$sample.uid}">{$sample.uid}</a>
            </td>
            <td>{$sample.identifier}</td>
            <td>{$sample.sample_type_name}</td>
          </tr>
        {/foreach}
      </tbody>
    </table>
  </fiedset>
</div>
