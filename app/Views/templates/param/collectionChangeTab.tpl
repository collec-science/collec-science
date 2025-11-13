<script>
    $( document ).ready( function () {
        $( ".notificationEnabled" ).change( function () {
            $( ".notificationField" ).prop( "disabled", $( "#ne0" ).prop( "checked" ) );
        } );
        $( ".notificationField" ).prop( "disabled", $( "#ne0" ).prop( "checked" ) );
        		/* Management of tabs */
		var myStorage = window.localStorage;
		var activeTab = "";
        try {
        activeTab = myStorage.getItem("collectionChangeTab");
        } catch (Exception) {
        }
		try {
			if (activeTab.length > 0) {
				$("#"+activeTab).tab('show');
			}
		} catch (Exception) { }
		 $('.nav-link').on('shown.bs.tab', function () {
			myStorage.setItem("collectionChangeTab", $(this).attr("id"));
		});
        $("#sampletypecheck").change(function () { 
            if ($("#sampletypecheck").prop("checked")) {
                $(".sampletypecheck").prop("checked",true);
            } else {
                $(".sampletypecheck").prop("checked",false);
            }
        });
    } );
</script>

<h2>{t}Création - Modification d'une collection{/t}</h2>
<div class="row">
    <div class="col-md-10 col-lg-8">
        <a href="collectionList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a> {$help}

        <form class="form-horizontal " id="collectionForm" method="post" action="collectionWrite">
            <input type="hidden" name="moduleBase" value="collection">
            <input type="hidden" name="collection_id" value="{$data.collection_id}">
            <div class="row">
                <div class="form-group center">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                    {if $data.collection_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                    {/if}
                </div>
            </div>
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
                    <a class="nav-link collectionTab" id="tabeventtypes" href="#naveventtypes" data-toggle="tab"
                        role="tab" aria-controls="naveventtypes" aria-selected="false">
                        {t}Types d'événements rattachés{/t}
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link collectionTab" id="tabnotifications" href="#navnotifications" data-toggle="tab"
                        role="tab" aria-controls="navnotifications" aria-selected="false">
                        {t}Notifications{/t}
                    </a>
                </li>
            </ul>
            <!-- description des boites-->
            <div class="tab-content col-lg-12 form-horizontal" id="tabContent">
                <!-- donnees generales-->
                <div class="tab-pane active in" id="navgeneral" role="tabpanel" aria-labelledby="tabgeneral">
                    <div class="form-group">
                        <label for="collectionName" class="control-label col-md-4">
                            <span class="red">*</span> {t}Nom :{/t}
                        </label>
                        <div class="col-md-8">
                            <input id="collectionName" type="text" class="form-control" name="collection_name"
                                value="{$data.collection_name}" autofocus required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="collectionDisplayname" class="control-label col-md-4">
                            {t}Nom public, communiqué à l'extérieur :{/t}
                        </label>
                        <div class="col-md-8">
                            <input id="collectionDisplayname" type="text" class="form-control"
                                name="collection_displayname" value="{$data.collection_displayname}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="collectionDisplayname" class="control-label col-md-4">
                            {t}Mots clés, séparés par une virgule :{/t}
                        </label>
                        <div class="col-md-8">
                            <input id="collectionKeywords" type="text" class="form-control" name="collection_keywords"
                                value="{$data.collection_keywords}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="referentId" class="control-label col-md-4">
                            {t}Référent de la collection :{/t}
                        </label>
                        <div class="col-md-8">
                            <select id="referentId" name="referent_id" class="form-control">
                                <option value="" {if $data.referent_id=="" }selected{/if}>Choisissez...</option>
                                {foreach $referents as $referent}
                                <option value="{$referent.referent_id}" {if
                                    $data.referent_id==$referent.referent_id}selected{/if}>
                                    {$referent.referent_name}
                                </option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="sau0" class="control-label col-md-4">
                            {t}Les identifiants des échantillons doivent être uniques :{/t}
                        </label>
                        <div class="col-md-8">
                            <div class="radio">
                                <label>
                                    <input type="radio" name="sample_name_unique" id="sau0" value="f" {if
                                        $data.sample_name_unique!=1}checked{/if}>
                                    {t}non{/t}
                                </label>
                                <label>
                                    <input type="radio" name="sample_name_unique" id="sau1" value="t" {if
                                        $data.sample_name_unique== 't'}checked{/if}>
                                    {t}oui{/t}
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="columns" class="control-label col-md-4">
                            {t}Flux de modification entrants autorisés :{/t}
                        </label>
                        <div class="col-md-8">
                            <div class="radio">
                                <label>
                                    <input type="radio" name="allowed_import_flow" id="aif_1" value="f" {if
                                        $data.allowed_import_flow!=1}checked{/if}>
                                    {t}non{/t}
                                </label>
                                <label>
                                    <input type="radio" name="allowed_import_flow" id="aif_2" value="t" {if
                                        $data.allowed_import_flow== 't'}checked{/if}>
                                    {t}oui{/t}
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="allowed_export_flow" class="control-label col-md-4">
                            {t}Flux d'interrogation externes autorisés :{/t}
                        </label>
                        <div class="col-md-8">
                            <div class="radio" id="allowed_export_flow">
                                <label>
                                    <input type="radio" name="allowed_export_flow" id="aef_1" value="f" {if
                                        $data.allowed_export_flow!=1}checked{/if}>
                                    {t}non{/t}
                                </label>
                                <label>
                                    <input type="radio" name="allowed_export_flow" id="aef_2" value="t" {if
                                        $data.allowed_export_flow== 't'}checked{/if}>
                                    {t}oui{/t}
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="public_collection" class="control-label col-md-4">
                            {t}Collection publique ?{/t}
                        </label>
                        <div class="col-md-8">
                            <div class="radio" id="public_collection">
                                <label>
                                    <input type="radio" name="public_collection" id="pub1" value="f" {if
                                        $data.public_collection!=1}checked{/if}>
                                    {t}non{/t}
                                </label>
                                <label>
                                    <input type="radio" name="public_collection" id="pub2" value="t" {if
                                        $data.public_collection== 't'}checked{/if}>
                                    {t}oui{/t}
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="license_id" class="control-label col-md-4">
                            {t}Licence de diffusion :{/t}
                        </label>
                        <div class="col-md-8">
                            <select id="license_id" name="license_id" class="form-control">
                                <option value="" {if $data.license_id=="" }selected{/if}>{t}Choisissez...{/t}
                                </option>
                                {foreach $licenses as $license}
                                <option value="{$license.license_id}" {if
                                    $data.license_id==$license.license_id}selected{/if}>
                                    {$license.license_name} ({$license.license_url})</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="no_localization" class="control-label col-md-4">
                            {t}Collection sans gestion de la localisation des échantillons ?{/t}
                        </label>
                        <div class="col-md-8">
                            <div class="radio">
                                <label>
                                    <input type="radio" name="no_localization" id="no_localization0" value="f" {if
                                        $data.no_localization != 't'}checked{/if}>
                                    {t}non{/t}
                                </label>
                                <label>
                                    <input type="radio" name="no_localization" id="no_localization1" value="t" {if
                                        $data.no_localization== 't' }checked{/if}>
                                    {t}oui{/t}
                                </label>
                                
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="external_storage_enabled" class="control-label col-md-4">
                            {t}Le stockage de documents attachés aux échantillons est-il possible hors base de données ?{/t}
                        </label>
                        <div class="col-md-8">
                            <div class="radio">
                                <label>
                                    <input type="radio" name="external_storage_enabled" id="external_storage_enabled0"
                                       value="f" {if $data.external_storage_enabled!=1}checked{/if}>
                                    {t}non{/t}
                                </label>
                                <label>
                                    <input type="radio" name="external_storage_enabled" id="external_storage_enabled1"
                                        value="t" {if $data.external_storage_enabled=="1" }checked{/if}>
                                    {t}oui{/t}
                                </label>
                                
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="external_storage_root" class="control-label col-md-4">
                            {t}Chemin d'accès aux fichiers externes :{/t}
                        </label>
                        <div class="col-md-8">
                            <input id="external_storage_root" type="text" class="form-control"
                                name="external_storage_root" value="{$data.external_storage_root}">
                        </div>
                    </div>
                </div>
                <!--groupes-->
                <div class="tab-pane fade" id="navgroups" role="tabpanel" aria-labelledby="tabgroups">
                    <div class="form-group">
                        <label for="groupes" class="control-label col-md-4">
                            {t}Groupes :{/t}
                        </label>
                        <div class="col-md-7">
                            {section name=lst loop=$groupes}
                            <div class="col-md-2 col-sm-offset-3">
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" name="groupes[]" value="{$groupes[lst].aclgroup_id}" {if
                                            $groupes[lst].checked== 1}checked{/if}>
                                        {$groupes[lst].groupe}
                                    </label>
                                </div>
                            </div>
                            {/section}
                        </div>
                    </div>
                </div>
                <!--sample types-->
                <div class="tab-pane fade" id="navsampletypes" role="tabpanel" aria-labelledby="tabsampletypes">
                    <div class="form-group">
                        <label for="sampletypes" class="control-label col-md-4">
                            {t}Types d'échantillons spécifiques de la collection :{/t}
                            <br>
                            {t}(dé)sélectionnez tous :{/t}
                            <input type="checkbox" id="sampletypecheck">
                        </label>
                        <div class="col-md-7">
                            {section name=lst loop=$sampletypes}
                            <div class="col-md-6 ">
                                <div class="checkbox">
                                    <label>
                                        <input class="sampletypecheck" type="checkbox" name="sampletypes[]"
                                            value="{$sampletypes[lst].sample_type_id}" {if
                                            $sampletypes[lst].checked== 1}checked{/if}>
                                        {$sampletypes[lst].sample_type_name}
                                    </label>
                                </div>
                            </div>
                            {/section}
                        </div>
                    </div>
                </div>
                <!-- event types -->
                <div class="tab-pane fade" id="naveventtypes" role="tabpanel" aria-labelledby="tabeventtypes">
                    <div class="form-group">
                        <label for="eventtypes" class="control-label col-md-4">
                            {t}Types d'événements spécifiques de la collection :{/t}
                        </label>
                        <div class="col-md-7">
                            {section name=lst loop=$eventtypes}
                            <div class="col-md-6 ">
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" name="eventtypes[]"
                                            value="{$eventtypes[lst].event_type_id}" {if
                                            $eventtypes[lst].checked== 1}checked{/if}>
                                        {$eventtypes[lst].event_type_name}
                                    </label>
                                </div>
                            </div>
                            {/section}
                        </div>
                    </div>
                </div>
                <!-- notifications -->
                <div class="tab-pane fade" id="navnotifications" role="tabpanel" aria-labelledby="tabnotifications">
                    <div class="form-group">
                        <label for="ne0" class="control-label col-md-4">
                            {t}Activer les notifications ?{/t}
                        </label>
                        <div class="col-md-8">
                            <div class="radio">
                                <label>
                                    <input type="radio" class="notificationEnabled" name="notification_enabled"
                                        id="ne0" value="f" {if $data.notification_enabled!=1}checked{/if}>
                                    {t}non{/t}
                                </label>
                                <label>
                                    <input type="radio" class="notificationEnabled" name="notification_enabled"
                                        id="ne1" value="t" {if $data.notification_enabled== 't'}checked{/if}>
                                    {t}oui{/t}
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="notification_mails" class="col-md-4 control-label">
                            <span class="red">*</span>
                            {t}Mails des destinataires des notifications, séparés par une virgule :{/t}
                        </label>
                        <div class="col-md-8">
                            <input type="text" class="form-control notificationField" id="notification_mails"
                                name="notification_mails" value="{$data.notification_mails}" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="expiration_delay" class="col-md-4 control-label">
                            {t}Délai avant l'expiration des échantillons, en jours (0 : pas de notification) :{/t}
                        </label>
                        <div class="col-md-8">
                            <input type="text" class="form-control notificationField" id="expiration_delay"
                                name="expiration_delay" value="{$data.expiration_delay}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="event_due_delay" class="col-md-4 control-label">
                            {t}Délai avant la date d'échéance d'un événement, en jours (0 : pas de notification) :{/t}
                        </label>
                        <div class="col-md-8">
                            <input type="text" class="form-control notificationField" id="event_due_delay"
                                name="event_due_delay" value="{$data.event_due_delay}">
                        </div>
                    </div>
                </div>
            </div>
        {$csrf}</form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>