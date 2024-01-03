<script>
    $(document).ready (function () { 
         /* Management of tabs */
    var myStorage = window.localStorage;
        var activeTab = "";
        try {
            var storageName = "datasetTemplateTab";
            activeTab = myStorage.getItem( storageName );
        } catch ( Exception ) {
        }
        try {
            if ( activeTab.length > 0 ) {
                $( "#" + activeTab ).tab( 'show' );
            }
        } catch ( Exception ) { }
        $( '.datasetTab' ).on( 'shown.bs.tab', function () {
            myStorage.setItem( storageName, $( this ).attr( "id" ) );
        } );
    });
   
</script>

<h2>{t}Affichage du modèle de dataset{/t} <i>{$data.dataset_template_name}</i></h2>
<div class="row">
    <div class="col-lg-12">
        <a href="index.php?module=datasetTemplateList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
    </div>
</div>
<!-- Tab box -->
<div class="row">
    <div class="col-lg-12">
        <ul class="nav nav-tabs" id="datasetTab" role="tablist">
            <li class="nav-item active">
                <a class="nav-link datasetTab" id="tabgeneral" data-toggle="tab" role="tab" aria-controls="navgeneral"
                    aria-selected="true" href="#navgeneral">
                    {t}Informations générales{/t}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link datasetTab" id="tabcols" href="#navcols" data-toggle="tab" role="tab"
                    aria-controls="navcols" aria-selected="false">
                    {t}Liste des informations exportées{/t}
                </a>
            </li>
        </ul>
        <!-- description of tabs-->
        <div class="tab-content" id="tabContent">
            <div class="tab-pane active in" id="navgeneral" role="tabpanel" aria-labelledby="tabgeneral">
                <div class="row">
                    <a href="index.php?module=datasetTemplateChange&dataset_template_id={$data.dataset_template_id}">
                        <img src="display/images/edit.gif" height="25">
                        {t}Modifier...{/t}
                    </a>
                </div>
                <div class="row">
                    <div class="form-display col-lg-6 col-md-8">
                        <dl class="dl-horizontal">
                            <dt>{t}Format du fichier généré :{/t}</dt>
                            <dd>{$data.export_format_name}</dd>
                        </dl>
                        <dl class="dl-horizontal">
                            <dt>{t}Type de dataset :{/t}</dt>
                            <dd>{$data.dataset_type_name}</dd>
                        </dl>
                        <dl class="dl-horizontal">
                            <dt>{t}Nom du fichier généré :{/t}</dt>
                            <dd>{$data.filename}</dd>
                        </dl>
                        <dl class="dl-horizontal">
                            <dt>{t}Séparateur (fichiers csv) :{/t}</dt>
                            <dd>{$data.separator}</dd>
                        </dl>
                        <dl class="dl-horizontal">
                            <dt>{t}Récupération du document le plus récent ?{/t}</dt>
                            <dd>{if $data.only_last_document == 1}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
                        </dl>
                        <fieldset>
                            <legend>{t}Fichiers XML{/t}</legend>
                            <dl class="dl-horizontal">
                                <dt>{t}Entête du fichier :{/t}</dt>
                                <dd>{$data.xmlroot}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Nom des nœuds de chaque item :{/t}</dt>
                                <dd>{$data.xmlnodename}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Transformation XSL appliquée sur le fichier XML généré :{/t}</dt>
                                <dd>
                                    <textarea class="texteareaDisplay col-md-12" rows="5"
                                        readonly>{$data.xslcontent}</textarea>
                                </dd>
                            </dl>
                        </fieldset>
                    </div>
                </div>

            </div>
            <div class="tab-pane fade" id="navcols" role="tabpanel" aria-labelledby="tabcols">
                <a
                    href="index.php?module=datasetColumnChange&dataset_column_id=0&dataset_template_id={$data.dataset_template_id}">
                    <img src="display/images/new.png" height="25">
                    {t}Nouvelle colonne{/t}
                </a>
                <div class="row">
                    <div class="col-lg-10">
                        {include file="export/datasetColumnTable.tpl"}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>