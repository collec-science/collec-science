<script>
  $(document).ready(function() {
    /* Management of tabs */
      var activeTab = "";
      var myStorage = window.localStorage;
          try {
          activeTab = myStorage.getItem("campaignDetailTab");
          } catch (Exception) {
          }
      try {
        if (activeTab.length > 0) {
          $("#"+activeTab).tab('show');
        }
      } catch (Exception) { }
      $('.nav-tabs > li > a').hover(function() {
        //$(this).tab('show');
       });
       $('.nav-link').on('shown.bs.tab', function () {
        myStorage.setItem("campaignDetailTab", $(this).attr("id"));
      });
  });
  </script>
<a href="index.php?module=campaignList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
<h2>{t}Campagne{/t} {$data.campaign_name}</h2>
<!-- Tab box -->
<ul class="nav nav-tabs" id="tabCampaignDetail" role="tablist">
  <li class="nav-item active">
    <a class="nav-link" id="tabCampaignDetail" data-toggle="tab" role="tab" aria-controls="navCampaignDetail"
      aria-selected="true" href="#navCampaignDetail">
      {t}Description{/t}
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" id="tabRules" href="#navRules" data-toggle="tab" role="tab" aria-controls="navRules"
      aria-selected="false">
      {t}Réglementations applicables{/t}
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" id="tabDocs" href="#navDocs" data-toggle="tab" role="tab" aria-controls="navDocs"
      aria-selected="false">
      {t}Documents associés{/t}
    </a>
  </li>
</ul>
<div class="tab-content col-lg-12" id="campaignContent">
  <div class="tab-pane active in" id="navCampaignDetail" role="tabpanel" aria-labelledby="tabCampaignDetail">
    {if $droits.param == 1}
    <div class="row">
      <a href="index.php?module=campaignChange&campaign_id={$data.campaign_id}">
        <img src="display/images/edit.gif" height="25">
        {t}Modifier...{/t}
      </a>
    </div>
    {/if}
    <div class="row">
      <div class="col-md-8 col-lg-6">
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
          <dl class="dl-horizontal">
            <dt class="lexical" data-lexical="uuid">{t}UUID :{/t}</dt>
            <dd>{$data.uuid}</dd>
          </dl>
        </div>
      </div>
    </div>
  </div>
  <div class="tab-pane fade" id="navRules" role="tabpanel" aria-labelledby="tabRules">
    <div class="row">
      <a href="index.php?module=campaignRegulationChange&campaign_regulation_id=0&campaign_id={$data.campaign_id}">
        {t}Nouvelle réglementation{/t}</a>
    </div>
    <div class="row">
      <div class="col-md-8 col-lg-6">
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
                <a
                  href="index.php?module=campaignRegulationChange&campaign_regulation_id={$regulation.campaign_regulation_id}&campaign_id={$regulation.campaign_id}">
                  {$regulation.regulation_name}
                </a>
              </td>
              <td class="center">{$regulation.authorization_number}</td>
              <td class="center">{$regulation.authorization_date}</td>
            </tr>
            {/foreach}
          </tbody>
        </table>
      </div>
    </div>

  </div>
  <div class="tab-pane fade" id="navDocs" role="tabpanel" aria-labelledby="tabDocs">
    <div class="row">
      <div class="col-lg-6 col-md-8">
        {include file="gestion/documentList.tpl"}
      </div>
    </div>
  </div>
</div>
