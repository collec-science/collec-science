<script>
    $( document ).ready( function () {
        $( ".checkUidSelect" ).change( function () {
            $( '.checkUid' ).prop( 'checked', this.checked );
        } );
        /* Management of tabs */
        var myStorage = window.localStorage;
        var activeTab = "";
        try {
            var storageName = "lotExportTab";
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
        $( "#checkedButtonUid" ).on( "keypress click", function ( event ) {
            var conf = confirm( "{t}Attention : cette opération est définitive. Est-ce bien ce que vous voulez faire ?{/t}" );
            if ( conf == true ) {
                $( this.form ).prop( 'target', '_self' ).submit();
            } else {
                event.preventDefault();
            }
        } );
    } );
</script>

<h2>Affichage d'un lot d'export</h2>
<div class="row">
    <a href="lotList"><img src="display/images/list.png" height="25">
        {t}Retour à la liste des lots d'export{/t}
    </a>
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
                    {t}Liste des échantillons exportés{/t}
                </a>
            </li>
        </ul>
        <!-- description of tabs-->
        <div class="tab-content" id="tabContent">
            <div class="tab-pane active in" id="navgeneral" role="tabpanel" aria-labelledby="tabgeneral">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-display">
                            <dl class="dl-horizontal">
                                <dt>{t}Collection :{/t}</dt>
                                <dd>{$data.collection_name}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Date de création{/t}</dt>
                                <dd>{$data.lot_date}</dd>
                            </dl>
                            <dl class="dl-horizontal">
                                <dt>{t}Nombre d'échantillons :{/t}</dt>
                                <dd>{$data.sample_number}</dd>
                            </dl>
                            <div class="center">
                                <form id="lotForm" action="lotdelete" method="POST">
                                    <input type="hidden" name="moduleBase" value="lot">
                                    <input type="hidden" name="lot_id" value="{$data.lot_id}">
                                    <button class="btn btn-danger button-delete">
                                        {t}Supprimer{/t}
                                    </button>
                                {$csrf}</form>
                            </div>
                        </div>

                        <div class="row">
                            <a href="exportChange?export_id=0&lot_id={$data.lot_id}">
                                {t}Nouvel export...{/t}</a>
                        </div>
                        <div class="row">
                            <table class="table table-bordered table-hover datatable" data-order='[[1,"desc"]]'>
                                <thead>
                                    <tr>
                                        <th class="center"><img src="display/images/edit.gif" height="25"></th>
                                        <th>{t}Date du dernier export{/t}</th>
                                        <th>{t}Modèle d'export{/t}</th>
                                        <th>{t}Générer l'export{/t}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $exports as $export}
                                    <tr>
                                        <td class="center">
                                            <a
                                                href="exportChange?export_id={$export.export_id}&lot_id={$export.lot_id}">
                                                <img src="display/images/edit.gif" height="25">
                                            </a>
                                        </td>
                                        <td>{$export.export_date}</td>
                                        <td>{$export.export_template_name}</td>
                                        <td class="center">
                                            <a
                                                href="exportExec?export_id={$export.export_id}&lot_id={$export.lot_id}">
                                                <img src="display/images/exec.png" height="25">
                                            </a>
                                        </td>
                                    </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tab-pane fade" id="navcols" role="tabpanel" aria-labelledby="tabcols">
                <form action="lotDeleteSamples" method="post">
                    <input type="hidden" name="lot_id" value="{$data.lot_id}">
                    <div class="row">
                        <div class="col-lg-6 col-md-8">
                            <table class="table table-bordered table-hover datatable " data-order='[[1,"asc"]]'>
                                <thead>
                                    <tr>
                                        <th class="center">
                                            {t}Sélectionnez{/t}
                                            <input type="checkbox" id="checkUid" class="checkUidSelect checkUid">
                                        </th>
                                        <th class="center">{t}uid{/t}</th>
                                        <th>{t}Identifiant métier{/t}</th>
                                        <th>{t}Type d'échantillon{/t}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $samples as $sample}
                                    <tr>
                                        <td class="center">
                                            <input type="checkbox" class="checkUid" name="samples[]"
                                                value="{$sample.sample_id}">
                                        </td>
                                        <td class="center">
                                            <a href="sampleDisplay?uid={$sample.uid}">{$sample.uid}</a>
                                        </td>
                                        <td>{$sample.identifier}</td>
                                        <td>{$sample.sample_type_name}</td>
                                    </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row">

                        <div class="col-md-6 form-horizontal">
                            {t}Supprimez les échantillons sélectionnés de la liste :{/t}
                            <button id="checkedButtonUid" class="btn btn-danger">
                                {t}Supprimer{/t}
                            </button>
                        </div>
                    </div>
                {$csrf}</form>
            </div>
        </div>
    </div>
</div>