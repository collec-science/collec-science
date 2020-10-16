<a href="index.php?module=campaignList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
{if $droits.param == 1}
  &nbsp;
  <a href="index.php?module=campaignChange&campaign_id={$data.campaign_id}">
    <img src="display/images/edit.gif" height="25">
    {t}Modifier...{/t}
  </a>
{/if}
<h2>{t}Campagne{/t} {$data.campaign_name}</h2>

<div class="row">
  <div class="col-md-6">
    <div class="form-display">
      <dl class="dl-horizontal">
          <dt>{t}Nom de la campagne :{/t}</dt>
          <dd>{$data.campaign_name}</dd>
      </dl>
      <dl class="dl-horizontal">
        <dt>{t}Référent ou responsable :{/t}</dt>
        <dd>{$data.referent_name}</dd>
      </dl>
      <dl class="dl-horizontal">
        <dt>{t}Date de début :{/t}</dt>
        <dd>{$data.campaign_from}</dd>
      </dl>
      <dl class="dl-horizontal">
        <dt>{t}Date de fin :{/t}</dt>
        <dd>{$data.campaign_to}</dd>
      </dl>
    </div>
    <fieldset>
      <legend>{t}Réglementations applicables{/t}</legend>
      <a href="index.php?module=campaignRegulationChange&campaign_regulation_id=0&campaign_id={$data.campaign_id}">{t}Nouvelle réglementation{/t}</a>
      <table class="table table-bordered table-hover datatable">
      <thead>
        <tr>
          <th>{t}Nom{/t}</th>
          <th class="lexical" data-lexical="authorization">{t}N° d'autorisation{/t}</th>
          <th>{t}Date d'autorisation{/t}</th>
        </tr>
      </thead>
      <tbody>
        {foreach $regulations as $regulation}
          <tr>
            <td>
              <a href="index.php?module=campaignRegulationChange&campaign_regulation_id={$regulation.campaign_regulation_id}&campaign_id={$regulation.campaign_id}">
                {$regulation.regulation_name}
              </a>
            </td>
            <td class="center">{$regulation.authorization_number}</td>
            <td class="center">{$regulation.authorization_date}</td>
          </tr>
        {/foreach}
      </tbody>
      </table>
    </fieldset>
  </div>
  <fieldset class="col-md-6">
    <legend>{t}Documents associés{/t}</legend>
    {include file="gestion/documentList.tpl"}
  </fieldset>
</div>
