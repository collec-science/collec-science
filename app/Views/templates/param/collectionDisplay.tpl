<script>
    $(document).ready(function () {
        /* Management of tabs */
        var activeTab = "";
        var myStorage = window.localStorage;
        try {
            activeTab = myStorage.getItem("collectionDisplay");
        } catch (Exception) {
        }
        try {
            if (activeTab.length > 0) {
                $("#" + activeTab).tab('show');
            }
        } catch (Exception) { }
        $('.nav-tabs > li > a').hover(function () {
            //$(this).tab('show');
        });
        $('.nav-link').on('shown.bs.tab', function () {
            myStorage.setItem("collectionDisplay", $(this).attr("id"));
        });
    });
</script>
<a href="collectionList">
    <img src="display/images/list.png" height="25">
    {t}Retour à la liste{/t}
</a>
<div class="row">
    <div class="col-lg-12">
        <!-- Tab box -->
        <ul class="nav nav-tabs" id="collectionTab" role="tablist">
            <li class="nav-item active">
                <a class="nav-link collectionTab" id="tabGeneral" data-toggle="tab" role="tab"
                    aria-controls="navGeneral" aria-selected="true" href="#navGeneral">
                    {t}Informations générales{/t}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link collectionTab" id="tabsampletypes" href="#navsampletypes" data-toggle="tab"
                    role="tab" aria-controls="navsampletypes" aria-selected="false">
                    {t}Types d'échantillons et d'évenements rattachés{/t}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link collectionTab" id="tabnotifications" href="#navnotifications" data-toggle="tab"
                    role="tab" aria-controls="navnotifications" aria-selected="false">
                    {t}Groupes et notifications{/t}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="tabDocs" href="#navDocs" data-toggle="tab" role="tab" aria-controls="navDocs"
                    aria-selected="false">
                    {t}Documents associés{/t}
                </a>
            </li>
        </ul>
        <!-- description des boites-->
        <div class="tab-content col-lg-12" id="tabcontent">
            <!-- donnees generales-->
            <div class="tab-pane active in" id="navGeneral" role="tabpanel" aria-labelledby="tabGeneral">
                {if $rights.param == 1}
                <div class="row">
                    <a href="collectionChange?collection_id={$data.collection_id}">
                        <img src="display/images/edit.gif" height="25">
                        {t}Modifier...{/t}
                    </a>
                </div>
                {/if}
                <div class="row">
                    <div class="col-md-8 col-lg-6">
                        <div class="form-display">
                            <dl class="dl-horizontal">
                                <dt>{t}Nom de la collection :{/t}</dt>
                                <dd>{$data.collection_name}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Nom public :{/t}</dt>
                                <dd>{$data.collection_displayname}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Description :{/t}</dt>
                                <dd class="textareaDisplay">{$data.collection_description}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Mots clés :{/t}</dt>
                                <dd>{$data.collection_keywords}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Référent de la collection :{/t}</dt>
                                <dd>{$data.referent_name}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Les identifiants des échantillons doivent être uniques :{/t}</dt>
                                <dd>{if $data.sample_name_unique=='t'}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Flux de modification entrants autorisés :{/t}</dt>
                                <dd>{if $data.allowed_import_flow=='t'}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Flux d'interrogation externes autorisés :{/t}</dt>
                                <dd>{if $data.allowed_export_flow=='t'}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Collection publique ?{/t}</dt>
                                <dd>{if $data.public_collection=='t'}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Licence de diffusion :{/t}</dt>
                                <dd>{$data.license_name} ({$license.license_url})</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Collection sans gestion de la localisation des échantillons ?{/t}</dt>
                                <dd>{if $data.no_localization=='t'}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Le stockage de documents attachés aux échantillons est-il possible hors base de données ?{/t}</dt>
                                <dd>{if $data.external_storage_enabled=='t'}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
                            </dl>
                            {if $data.external_storage_enabled=='t'}
                            <dl class="dl-horizontal">
                                <dt>{t}Chemin d'accès aux fichiers externes :{/t}</dt>
                                <dd>{$data.external_storage_root}</dd>
                            </dl>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
            <!--sample and event types-->
            <div class="tab-pane fade" id="navsampletypes" role="tabpanel" aria-labelledby="tabsampletypes">
                <div class="row">
                    <div class="col-md-8 col-lg-6">
                        <div class="form-display">
                            <fieldset>
                                <legend>{t}Types d'échantillons rattachés{/t}</legend>
                            </fieldset>
                            <div class="row">
                                {foreach $sampletypes as $row}
                                <div class="col-md-6">
                                    {$row.sample_type_name}
                                </div>
                                {/foreach}
                            </div>

                            <fieldset>
                                <legend>{t}Types d'événements rattachés{/t}</legend>
                            </fieldset>
                            <div class="row">
                                {foreach $eventtypes as $row}
                                <div class="col-md-6">
                                    {$row.event_type_name}
                                </div>
                                {/foreach}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- notifications -->
            <div class="tab-pane fade" id="navnotifications" role="tabpanel" aria-labelledby="tabnotifications">
                <div class="row">
                    <div class="col-md-8 col-lg-6">
                        <div class="form-display">
                            <fieldset>
                                <legend>{t}Groupes autorisés à modifier les échantillons{/t}</legend>
                                {foreach $groups as $row}
                                <div class="col-md-6">
                                    {$row.groupe}
                                </div>
                                {/foreach}
                            </fieldset>
                            <fieldset>
                                <legend>{t}Notifications automatiques{/t}</legend>
                                <dl class="dl-horizontal">
                                    <dt>{t}Notifications activées ?{/t}</dt>
                                    <dd>{if $data.notification_enabled=='t'}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
                                </dl>
                                <dl class="dl-horizontal">
                                    <dt>{t}Mails des destinataires :{/t}</dt>
                                    <dd>{$data.notification_mails}</dd>
                                </dl>
                                <dl class="dl-horizontal">
                                    <dt>{t}Délai avant l'expiration des échantillons, en jours :{/t}</dt>
                                    <dd>{$data.expiration_delay}</dd>
                                </dl>
                                <dl class="dl-horizontal">
                                    <dt>{t}Délai avant la date d'échéance d'un événement, en jours :{/t}</dt>
                                    <dd>{$data.event_due_delay}</dd>
                                </dl>
                            </fieldset>
                        </div>
                    </div>
                </div>
            </div>
            <!-- documents-->
            <div class="tab-pane fade" id="navDocs" role="tabpanel" aria-labelledby="tabDocs">
                <div class="row">
                    <div class="col-lg-6 col-md-8">
                        {include file="gestion/documentList.tpl"}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>