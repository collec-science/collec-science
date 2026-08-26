<div class="container">
    <div class="row align-items-center">
        <div class="col-auto">
            <a href="odkList">
                <img src="display/images/list.png" height="25">
                {t}Retour à la liste{/t}
            </a>
        </div>
        {if $rights.param == 1}
        <div class="col-auto">
            <a href="odkChange?odk_id={$data.odk_id}">
                <img src="display/images/edit.gif" height="25">
                {t}Modifier...{/t}
            </a>
        </div>
        {/if}
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
                    <a class="nav-link" id="tabstations" href="#navstations" data-bs-toggle="tab" role="tab" aria-controls="navnotifications" aria-selected="false">
                        {t}Groupes et notifications{/t}
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="tabreferents" href="#navreferents" data-bs-toggle="tab" role="tab" aria-controls="navDocs" aria-selected="false">
                        {t}Référents{/t}
                    </a>
                </li>
            </ul>
            <!-- description des boites-->
            <div class="tab-content col-12" id="tabcontent">
                <!-- donnees generales-->
                <div class="tab-pane active in" id="navGeneral" role="tabpanel" aria-labelledby="tabGeneral">
                    <div class="row">
                        <div class="col-8 col-6">
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
                </div>
                <!--sample and event types-->
                <div class="tab-pane fade" id="navsampletypes" role="tabpanel" aria-labelledby="tabsampletypes">
                    <div class="row">
                        <!--List of sample types-->
                        <table class="table table-bordered table-hover datatable-nopaging-nosearching" id="odkSamples">
                            <thead>
                                <tr>
                                    <th>{t}Type d'échantillon{/t}</th>
                                    <th>{t}Ordre d'affichage{/t}</th>
                                    <th>{t}Nombre d'images{/t}</th>
                                    <th>{t}Nombre de vidéos{/t}</th>
                                    <th>{t}Nombre de prises sonores{/t}</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $samples as $sample}
                                <tr {if $sample.odk_sampletype_id==$sampletypeCurrent}class="itemSelected" {/if}>
                                    <td>
                                        <a href="odkDisplay?odk_id={$data.odk_id}&odk_sampletype_id={$sample.sampletype_id}">
                                            {$sample.sample_type_name}
                                        </a>
                                    </td>
                                    <td class="center">{$sample.sampletype_order}</td>
                                    <td class="center">{$sample.image_number}</td>
                                    <td class="center">{$sample.video_number}</td>
                                    <td class="center">{$sample.sound_number}</td>
                                </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                    <fieldset class="row">
                        <legend>{t}Ajout ou modification{/t}</legend>
                        <form class="form-horizontal " id="odkSampletypeForm" method="post">
                            <input type="hidden" name="moduleBase" value="odkSampletype">
                            <input type="hidden" name="action" value="Write">
                            <input type="hidden" name="odk_id" value="{$data.odk_id}">
                            <input type="hidden" name="odk_sampletype_id" value="{$sampletype.odk_sampletype_id}">


EN COURS !

                            <div class="row d-flex justify-content-center">
                                <div class="col-auto">
                                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                                </div>
                                {if $data.odk_sampletype_id > 0 }
                                <div class="col-auto">
                                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                                </div>
                                {/if}
                            </div>
                            {$csrf}
                        </form>
                    </fieldset>
                </div>
            </div>
        </div>
    </div>
</div>