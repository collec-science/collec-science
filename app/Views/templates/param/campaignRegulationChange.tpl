<a href="campaignList"><img src="display/images/list.png" height="25">{t}Retour à la liste des campagnes{/t}</a>
&nbsp;
<a href="campaignDisplay?campaign_id={$data.campaign_id}"><img src="display/images/display.png" height="25">{t}Retour au détail de la campagne{/t}</a>
<h3>{t}Création/modification d'une réglementation associée à la campagne {/t}{$campaign.campaign_name}</h3>
<div class="row">
  <div class="col-md-8">
    <form class="form-horizontal protoform" id="campaignRegulationChange" method="post" action="index.php">
      <input type="hidden" name="moduleBase" value="campaignRegulation">
      <input type="hidden" name="action" value="Write">
      <input type="hidden" name="campaign_id" value="{$data.campaign_id}">
      <input type="hidden" name="campaign_regulation_id" value="{$data.campaign_regulation_id}">
      <div class="form-group">
        <label for="referent_id" class="control-label col-md-4">{t}Réglementation :{/t}</label>
        <div class="col-md-8">
          <select id="regulation_id" name="regulation_id" class="form-control" autofocus>
            {foreach $regulations as $regulation}
              <option value="{$regulation.regulation_id}" {if $regulation.regulation_id == $data.regulation_id}selected{/if}>
                {$regulation.regulation_name}
              </option>
            {/foreach}
          </select>
        </div>
      </div>
      <div class="form-group">
        <label for="authorization_number"  class="control-label col-md-4 lexical" data-lexical="authorization"> {t}N° d'autorisation :{/t}</label>
        <div class="col-md-8">
          <input id="authorization_number" type="text" class="form-control" name="authorization_number" value="{$data.authorization_number}">
        </div>
      </div>
      <div class="form-group">
        <label for="authorization_date"  class="control-label col-md-4"> {t}Date d'autorisation :{/t}</label>
        <div class="col-md-8">
          <input id="authorization_date" class="form-control datepicker" name="authorization_date" value="{$data.authorization_date}">
        </div>
      </div>
      <div class="form-group center">
        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
        {if $data.campaign_regulation_id > 0}
          <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
        {/if}
      </div>
    {$csrf}</form>
  </div>
</div>
