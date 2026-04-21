<div class="container-fluid">
    <div class="form-display col-md-6">
        {if $rights.manage == 1}
        <form method="GET" id="SampleDisplayFormListPrint" action="samplePrintLabel" target="_blank">
            <input type="hidden" id="uid2" name="uids" value="{$data.uid}">
            <input type="hidden" name="uid" value="{$data.uid}">
            <input type="hidden" name="lastModule" value="sampleDisplay">
            <div class="row justify-content-center">
                <div class="col-auto">
                    <select id="labels2" name="label_id" class="form-select">
                        <option value="" {if $label_id=="" }selected{/if}>{t}Étiquette par défaut{/t}</option>
                        {section name=lst loop=$labels}
                        <option value="{$labels[lst].label_id}" {if $labels[lst].label_id==$label_id}selected{/if}>
                            {$labels[lst].label_name}
                        </option>
                        {/section}
                    </select>
                </div>
                <div class="col-auto">
                    <button id="samplelabels2" class="btn btn-primary">{t}Étiquettes{/t}</button>
                </div>
                {if !empty($printers)}
                <div class="col-auto">
                    <select id="printers2" name="printer_id" class="form-select">
                        {section name=lst loop=$printers}
                        <option value="{$printers[lst].printer_id}">
                            {$printers[lst].printer_name}
                        </option>
                        {/section}
                    </select>
                </div>
                <div class="col-auto">
                    <button id="sampledirect2" class="btn btn-primary">{t}Impression directe{/t}</button>
                </div>
                {/if}
            </div>
            {$csrf}
        </form>
        {/if}
        <div class="row">
            <dl class="dl-horizontal">
                <dt>{t}UID et identifiant métier :{/t}</dt>
                <dd>{$data.uid} {$data.identifier}</dd>
            </dl>
            {if count ($objectIdentifiers) > 0}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="identifier-type">{t}Identifiants complémentaires :{/t}</dt>
                <dd>
                    {$i = 0}
                    {foreach $objectIdentifiers as $oi}
                    {if $i > 0}<br>{/if}
                    {$oi.identifier_type_name} {if
                    !empty($oi.identifier_type_code)}({$oi.identifier_type_code}){/if}:&nbsp;{$oi.object_identifier_value}
                    {$i = $i + 1}
                    {/foreach}
                </dd>
            </dl>
            {/if}
            {if strlen($data.dbuid_origin) > 0}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="dbuid">{t}DB et UID d'origine :{/t}</dt>
                <dd>{$data.dbuid_origin}</dd>
            </dl>
            {/if}
            <dl class="dl-horizontal">
                <dt>{t}Collection :{/t}</dt>
                <dd title="{$data.collection_description}">{$data.collection_name}</dd>
            </dl>
            {if (!empty($data.referent_id))}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="referent">{t}Référent :{/t}</dt>
                <dd id="referent_name" title="{t}Cliquez pour la description complète{/t}"><a href="#">{$data.referent_firstname} {$data.referent_name}</a></dd>
            </dl>
            {/if}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="sample_type">{t}Type :{/t}</dt>
                <dd>{$data.sample_type_name}
                    {if strlen($data.container_type_name) > 0}
                    <br>
                    {t}Contenant associé :{/t} {$data.container_type_name}
                    {/if}
                    {if strlen($data.risk_name) > 0}
                    <br>
                    {t}Risque :{/t} {$data.risk_name}
                    {/if}
                    {if strlen($data.product_name) > 0}
                    <br>
                    {t}Produit utilisé :{/t} {$data.product_name}
                    {/if}
                </dd>
            </dl>
            {if $data.operation_id > 0}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="protocol">{t}Protocole et opération :{/t}</dt>
                <dd>{$data.protocol_year} {$data.protocol_name} {$data.protocol_version} / {$data.operation_name}
                    {$data.operation_version}
                </dd>
            </dl>
            {/if}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="status">{t}Statut :{/t}</dt>
                <dd>{$data.object_status_name}
                    {if $data.trashed == 't'}
                    <span class="red">&nbsp;{t}Échantillon mis à la corbeille{/t}</span>
                    {/if}
                    {if $data.object_status_id == 6}
                    &nbsp;{t}le{/t}&nbsp;{$data.borrowing_date}
                    &nbsp;{t}à{/t}&nbsp;
                    <a href="borrowerDisplay?borrower_id={$data.borrower_id}">
                        {$data.borrower_name}
                    </a>

                    <br>
                    {t}Retour prévu le{/t}&nbsp;{$data.expected_return_date}
                    {/if}
                </dd>
            </dl>

            <dl class="dl-horizontal">
                <dt>{t}Date de création de l'échantillon (d'échantillonnage) :{/t}</dt>
                <dd>{$data.sampling_date}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Date d'import dans la base de données :{/t}
                </dt>
                <dd>{$data.sample_creation_date}</dd>
            </dl>
            {if strlen($data.expiration_date) > 0}
            <dl class="dl-horizontal">
                <dt title="{t}Date d'expiration de l'échantillon{/t}">{t}Date d'expiration :{/t}</dt>
                <dd>{$data.expiration_date}</dd>
            </dl>
            {/if}
            <dl class="dl-horizontal">
                <dt title="{t}Date technique de dernière modification de l'échantillon{/t}">{t}Date de modification :{/t}</dt>
                <dd>{$data.change_date}</dd>
            </dl>
            {if $data.multiple_type_id > 0}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="subsample" title="{t 1=$data.multiple_unit}Quantité de sous-échantillons (%1){/t}">{t
                    1=$data.multiple_unit}Qté de sous-échantillons (%1) :{/t}</dt>
                <dd>{$data.multiple_value}</dd>
            </dl>
            {/if}
            {if $data.parent_uid > 0}
            <dl class="dl-horizontal">
                <dt title="{t}Échantillon parent{/t}">{t}Échantillon parent :{/t}</dt>
                <dd>
                    <a href="sampleDisplay?uid={$data.parent_uid}">
                        {$data.parent_uid} {$data.parent_identifier}
                    </a>
                </dd>
            </dl>
            {/if}
            {if !empty($sampleparents)}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="composite">{t}Parents (échantillon composé){/t}</dt>
                <dd>
                    {foreach $sampleparents as $p}
                    <a href="sampleDisplay?uid={$p.uid}">
                        {$p.uid}&nbsp;{$p.identifier}
                    </a><br>
                    {/foreach}
                </dd>
            </dl>
            {/if}
            {if $data.no_localization != 't'}
            {if $data.campaign_id > 0}
            <dl class="dl-horizontal">
                <dt>{t}Campagne de prélèvement :{/t}</dt>
                <dd title="{$data.campaign_description}"><a href="campaignDisplay?campaign_id={$data.campaign_id}">
                        {$data.campaign_name}
                    </a>
                </dd>
            </dl>
            {/if}
            {if $data.sampling_place_id > 0}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="sampling_place">{t}Lieu de prélèvement :{/t}</dt>
                <dd>{$data.sampling_place_name}</dd>
            </dl>
            {/if}
            {if $data.country_id > 0}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="country">{t}Pays de collecte :{/t}</dt>
                <dd>{$data.country_name}</dd>
            </dl>
            {/if}
            {if $data.country_origin_id > 0}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="country_origin">{t}Pays de provenance :{/t}</dt>
                <dd>{$data.country_origin_name}</dd>
            </dl>
            {/if}
            {if strlen($data.wgs84_x) > 0 || strlen($data.wgs84_y) > 0}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="sample_latlong">{t}Latitude :{/t}</dt>
                <dd>{$data.wgs84_y}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Longitude :{/t}</dt>
                <dd>{$data.wgs84_x}</dd>
            </dl>
            {if $data.location_accuracy > 0}
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="accuracy">{t}Précision de la localisation (en mètres) :{/t}</dt>
                <dd>{$data.location_accuracy}</dd>
            </dl>
            {/if}
            {/if}
            {/if}
            <dl class="dl-horizontal">
                <dt>{t}Commentaire :{/t}</dt>
                <dd class="textareaDisplay">{$data.object_comment}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Emplacement :{/t}</dt>
                <dd>
                    {section name=lst loop=$parents}
                    <a href="containerDisplay?uid={$parents[lst].uid}">
                        {$parents[lst].uid} {$parents[lst].identifier} {$container_type_name}
                    </a>
                    {if not $smarty.section.lst.last}
                    <br>
                    {/if}
                    {/section}
                </dd>
            </dl>
            <dl class="dl-horizontal">
                <dt class="lexical" data-lexical="uuid">{t}UUID :{/t}</dt>
                <dd>{$data.uuid}</dd>
            </dl>
            {if !empty($metadata)}
            <fieldset>
                <legend class="lexical" data-lexical="metadata">{t}Métadonnées associées{/t}</legend>
                {foreach $metadata as $key=>$value}
                <dl class="dl-horizontal">
                    <dt>{t 1=$key}%1 :{/t}</dt>
                    <dd>
                        {if is_array($value) }
                        {foreach $value as $val}
                        {if is_array($val)}
                        {$last = ""}
                        {foreach $val as $val1}
                        {if $val1 != $last}
                        {$val1}<br>
                        {$last = $val1}
                        {/if}
                        {/foreach}
                        {else}
                        {$val}<br>
                        {/if}
                        {/foreach}
                        {else}
                        {if substr($value, 0, 5) == "http:" || substr($value, 0, 6) == "https:"}
                        <a href="{$value}" target="_blank">{$value}</a>
                        {else}
                        {$value}
                        {/if}
                        {/if}
                    </dd>
                </dl>
                {/foreach}
            </fieldset>
            {/if}
        </div>
    </div>
    <div class="col-md-6">
        {if strlen($data.wgs84_x) > 0 && strlen($data.wgs84_y) > 0 && $data.no_localization != 1}
        {include file="gestion/objectMapDisplay.tpl"}
        {/if}
    </div>
</div>