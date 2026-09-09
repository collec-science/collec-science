<script>
    $(document).ready(function () {
        /* Management of tabs */
        var myStorage = window.localStorage;
        var activeTab = "";
        try {
            activeTab = myStorage.getItem("odkTab");
        } catch (Exception) {
        }
        try {
            if (activeTab.length > 0) {
                $("#" + activeTab).tab('show');
            }
        } catch (Exception) { }
        $('.nav-link').on('shown.bs.tab', function () {
            myStorage.setItem("odkTab", $(this).attr("id"));
        });

        $("#odkSampletypeForm").submit(function (event) {
            var st = $("#sample_type_id").val();
            if (!st > 0) {
                event.preventDefault();
            }
        });
        $("#odkCalculate").submit(function(event) {
            if (!confirm("{t}Le contenu des lignes de formulaires et des choix va être réinitialisé{/t}")) {
                event.preventDefault();
            }
        });
    });
</script>
<div class="container-fluid">
    <div class="row align-items-center">
        <div class="col-auto">
            <a href="odkList">
                <img src="display/images/list.png" height="25">
                {t}Retour à la liste{/t}
            </a>
        </div>
        <div class="col-auto">
            <form id="odkCalculate" method="post" action="odkCalculate">
                <input type="hidden" name="odk_id" value="{$data.odk_id}">
                <button id="btn-calculate" type="submit" class="btn btn-danger">{t}Calculer le formulaire{/t}</button>
                {$csrf}
            </form>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <!-- Tab box -->
            <ul class="nav nav-tabs" id="odkTab" role="tablist">
                <li class="nav-item ">
                    <a class="nav-link active" id="tabGeneral" data-bs-toggle="tab" role="tab" aria-controls="navGeneral" aria-selected="true" href="#navGeneral">
                        {t}Informations générales - formulaire{/t}&nbsp;{$data.odk_name} {$data.odk_version}
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="tabsampletypes" href="#navsampletypes" data-bs-toggle="tab" role="tab" aria-controls="navsampletypes" aria-selected="false">
                        {t}Types d'échantillons ciblés{/t}
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="tabcomp" href="#navcomp" data-bs-toggle="tab" role="tab" aria-controls="navcomp" aria-selected="false">
                        {t}Informations complémentaires{/t}
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="tabsurvey" href="#navsurvey" data-bs-toggle="tab" role="tab" aria-controls="navsurvey" aria-selected="false" {if count($lines)==0}disabled{/if}>
                        {t}Lignes du formulaire{/t}
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="tabchoice" href="#navchoice" data-bs-toggle="tab" role="tab" aria-controls="navchoice" aria-selected="false" {if count($lines)==0}disabled{/if}>
                        {t}Choix{/t}
                    </a>
                </li>
            </ul>
            <!-- description des boites-->
            <div class="tab-content col-12" id="tabcontent">
                <!-- donnees generales-->
                <div class="tab-pane active in" id="navGeneral" role="tabpanel" aria-labelledby="tabGeneral">
                    <div class="row d-flex justify-content-center">
                        <div class="col-auto">
                            <button class="btn btn-primary" onclick="window.location.href='odkChange?odk_id={$data.odk_id}'" ;>{t}Modifier{/t}</button>
                        </div>
                    </div>
                    <div class="row">

                        <div class="form-display">
                            <dl class="dl-horizontal">
                                <dt>{t}Projet ODK :{/t}</dt>
                                <dd>{$data.odk_project}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Collection cible :{/t}</dt>
                                <dd>{$data.collection_name}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Description :{/t}</dt>
                                <dd>{$data.odk_description}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Campagne de prélèvement :{/t}</dt>
                                <dd>{$data.odk_campaign}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Sous-échantillonnage autorisé :{/t}</dt>
                                <dd>{if $data.with_subsampling == 1}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Version :{/t}</dt>
                                <dd>{$data.odk_version}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Formulaire créé par :{/t}</dt>
                                <dd>{$data.odk_author}</dd>
                            </dl>
                        </div>
                    </div>
                </div>
                <!--sample and event types-->
                <div class="tab-pane fade" id="navsampletypes" role="tabpanel" aria-labelledby="tabsampletypes">
                    {include file="odk/odkSampleList.tpl"}
                </div>
                <div class="tab-pane fade" id="navcomp" role="tabpanel" aria-labelledby="tabcomp">
                    <div class="row">
                        <form id="odkComp" class="form-horizontal" method="post" action="odkWriteComp">
                            <input type="hidden" name="odk_id" value="{$data.odk_id}">
                            <div class="row d-flex justify-content-center">
                                <div class="col-auto">
                                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                                </div>
                            </div>
                            <div class="row">
                                <fieldset>
                                    <legend>{t}Identifiants secondaires{/t}</legend>
                                    <div class="row align-items-center">
                                        {foreach from=$identifiers item=identifier name=lst}
                                        <div class="col-md-3 offset-md-1">
                                            <input type="checkbox" name="identifiers[]" class="form-check-input" id="identifiers{$smarty.foreach.lst.index}" value="{$identifier.identifier_type_id}" {if $identifier.checked==1}checked{/if}>
                                            <label for="identifiers{$smarty.foreach.lst.index}" class="form-check-label">
                                                {$identifier.identifier_type_name} ({$identifier.identifier_type_code})
                                            </label>
                                        </div>
                                        {/foreach}
                                    </div>
                                </fieldset>

                                <fieldset>
                                    <legend>{t}Stations{/t}</legend>
                                    <div class="row align-items-center">
                                        {foreach from=$stations item=station name=lst}
                                        <div class="col-md-3 offset-md-1">
                                            <input type="checkbox" name="stations[]" class="form-check-input" id="stations{$smarty.foreach.lst.index}" value="{$station.sampling_place_id}" {if $station.checked==1}checked{/if}>
                                            <label for="stations{$smarty.foreach.lst.index}" class="form-check-label">
                                                {$station.sampling_place_name}
                                            </label>
                                        </div>
                                        {/foreach}
                                    </div>
                                </fieldset>

                                <fieldset>
                                    <legend>{t}Référents des échantillons{/t}</legend>
                                    <div class="row align-items-center">
                                        {foreach from=$referents item=referent name=lst}
                                        <div class="col-md-3 offset-md-1">
                                            <input type="checkbox" name="referents[]" class="form-check-input" id="referents{$smarty.foreach.lst.index}" value="{$referent.referent_id}" {if $referent.checked==1}checked{/if}>
                                            <label for="referents{$smarty.foreach.lst.index}" class="form-check-label">
                                                {$referent.referent_name} {$referent.referent_first_name}
                                            </label>
                                        </div>
                                        {/foreach}
                                    </div>
                                </fieldset>

                            </div>
                            {$csrf}
                        </form>
                    </div>
                </div>
                <div class="tab-pane fade" id="navsurvey" role="tabpanel" aria-labelledby="tabsurvey">
                    {include file="odk/odkLine.tpl"}
                </div>
                <div class="tab-pane fade" id="navchoice" role="tabpanel" aria-labelledby="tabchoice">
                    {include file="odk/odkChoice.tpl"}
                </div>
            </div>
        </div>
    </div>
</div>