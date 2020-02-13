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
  <div class="form-display col-md-6">
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
    <fieldset>
      <legend>{t}Réglementations applicables{/t}</legend>
      <dl class="dl-horizontal">
        <dt></dt>
        <dd>
          {foreach $regulations as $regulation}
            {$regulation.regulation_name}<br>
          {/foreach}
        </dd>
      </dl>
    </fieldset>
  </div>
</div>
<div class="row">
  <div class="col-lg-8">
    {include file="gestion/documentList.tpl"}
  </div>
</div>