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
                <a class="nav-link collectionTab" id="tabgeneral" data-toggle="tab" role="tab"
                    aria-controls="navgeneral" aria-selected="true" href="#navgeneral">
                    {t}Informations générales{/t}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link collectionTab" id="tabgroups" href="#navgroups" data-toggle="tab" role="tab"
                    aria-controls="navgroups" aria-selected="false">
                    {t}Groupes d'utilisateurs autorisés{/t}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link collectionTab" id="tabsampletypes" href="#navsampletypes" data-toggle="tab"
                    role="tab" aria-controls="navsampletypes" aria-selected="false">
                    {t}Types d'échantillons rattachés{/t}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link collectionTab" id="tabeventtypes" href="#naveventtypes" data-toggle="tab" role="tab"
                    aria-controls="naveventtypes" aria-selected="false">
                    {t}Types d'événements rattachés{/t}
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link collectionTab" id="tabnotifications" href="#navnotifications" data-toggle="tab"
                    role="tab" aria-controls="navnotifications" aria-selected="false">
                    {t}Notifications{/t}
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
            <div class="tab-pane active in" id="navGeneral" role="tabpanel" aria-labelledby="tabgeneral">
                {if $rights.param == 1}
                <div class="row">
                    <a href="collectionChange?collection_id={$data.collection_id}">
                        <img src="display/images/edit.gif" height="25">
                        {t}Modifier...{/t}
                    </a>
                </div>
                {/if}
            </div>
            <!--groupes-->
            <div class="tab-pane fade" id="navgroups" role="tabpanel" aria-labelledby="tabgroups">
            </div>
            <!--sample types-->
            <div class="tab-pane fade" id="navsampletypes" role="tabpanel" aria-labelledby="tabsampletypes">
            </div>
            <!-- event types -->
            <div class="tab-pane fade" id="naveventtypes" role="tabpanel" aria-labelledby="tabeventtypes">
            </div>
            <!-- notifications -->
            <div class="tab-pane fade" id="navnotifications" role="tabpanel" aria-labelledby="tabnotifications">
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