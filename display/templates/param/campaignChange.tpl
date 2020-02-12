<a href="index.php?module=campaignList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
<h3>{t}Création/modification d'une campagne{/t}</h3>
<div class="row">
  <div class="col-md-8">
    <form class="form-horizontal protoform" id="campaignChange" method="post" action="index.php">
      <input type="hidden" name="moduleBase" value="campaign">
      <input type="hidden" name="action" value="Write">
      <input type="hidden" name="protocol_id" value="{$data.protocol_id}">
      <div class="row">
        <fieldset class="col-md-6">
          <legend>{t}Description de la campagne{/t}</legend>
          <div class="form-group">
              <label for="campaign_name"  class="control-label col-md-4"><span class="red">*</span> {t}Nom de la campagne :{/t}</label>
              <div class="col-md-8">
                <input id="campaign_name" type="text" class="form-control" name="campaign_name" value="{$data.campaign_name}" autofocus required>
              </div>
          </div>
          <div class="form-group">
            <label for="referent_id" class="control-label col-md-4">{t}Responsable ou référent de la campagne :{/t}</label>
            <div class="col-md-8">
              <select id="referent_id" name="referent_id" class="form-control">
                <option value="" {if $data.referent_id == ""}selected{/if}>{t}Choisissez{/t}</option>
                {foreach $referents as $referent}
                  <option value="{$referent.referent_id}" {if $referent.referent_id == $data.referent_id}selected{/if}>
                    {$referent.referent_name}
                  </option>
                {/foreach}
              </select>
            </div>
          </div>
        </fieldset>
        <fieldset class="col-md-6">
          <legend>{t}Réglementations associées{/t}</legend>
          {foreach $regulations as $regulation}
            <div class="form-group">
              <label class="control-label col-md-8">{$regulation.regulation_name}</label>
              <div class="col-md-4 center">
                <input type="checkbox" name="regulation_id[]" value="{$regulation.regulation_id}" {if
                  $regulation.campaign_id > 0}checked{/if}>
              </div>
            </div>
          {/foreach}
        </fieldset>
      </div>
      <div class="row">
        <div class="col-md-12">
          <div class="form-group center">
            <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
            {if $data[campaign_id] > 0}
              <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
            {/if}
          </div>
        </div>
      </div>
    </form>
  </div>
</div>