<h2>Modification d'un export</h2>
<div class="row">
    <a href="lotList"><img src="display/images/list.png" height="25">{t}Retour à la liste des lots{/t}</a>&nbsp;
  <a href="lotDisplay?lot_id={$lot.lot_id}"><img src="display/images/display.png" height="25">{t}Retour au détail du lot{/t}</a>
</div>
<div class="row">
  <div class="col-md-6 form-display">
    <dl class="dl-horizontal">
      <dt>{t}Collection :{/t}</dt>
      <dd>{$lot.collection_name}</dd>
    </dl>
    <dl class="dl-horizontal">
      <dt>{t}Date de création{/t}</dt>
      <dd>{$lot.lot_date}</dd>
    </dl>
    <dl class="dl-horizontal">
      <dt>{t}Nombre d'échantillons :{/t}</dt>
      <dd>{$lot.sample_number}</dd>
    </dl>
  </div>
</div>
<div class="row">
  <div class="col-md-6">
    <form class="form-horizontal " id="exportForm" method="post" action="index.php">
      <input type="hidden" name="moduleBase" value="export">
      <input type="hidden" name="action" value="Write">
      <input type="hidden" name="export_id" value="{$data.export_id}">
      <input type="hidden" name="lot_id" value="{$data.lot_id}">
      <div class="form-group">
        <label for="export_template_id" class="control-label col-md-4"><span class="red">*</span> {t}Modèle d'export :{/t}</label>
        <div class="col-md-8">
          <select id="export_template_id" name="export_template_id" class="form-control">
            {foreach $templates as $template}
              <option value="{$template.export_template_id}" {if $template.export_template_id==$data.export_template_id} selected{/if}>{$template.export_template_name} </option>
            {/foreach}
          </select>
        </div>
      </div>
      <div class="form-group center">
        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
        {if $data.export_template_id > 0 }
          <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
        {/if}
      </div>
    {$csrf}</form>
  </div>
</div>