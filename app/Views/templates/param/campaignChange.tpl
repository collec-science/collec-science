<a href="campaignList"><img src="display/images/list.png" height="25">
    {t}Retour à la liste{/t}
</a>
{if $data.campaign_id > 0}
&nbsp;<a href="campaignDisplay?campaign_id={$data.campaign_id}"><img src="display/images/display.png"
        height="25">
        {t}Retour au détail{/t}
    </a>
{/if}
<h3>{t}Création/modification d'une campagne{/t}</h3>
<div class="row">
    <div class="col-md-8">
        <form class="form-horizontal " id="campaignChange" method="post" action="campaignWrite">
            <input type="hidden" name="moduleBase" value="campaign">
            <input type="hidden" name="campaign_id" value="{$data.campaign_id}">
            <div class="form-group">
                <label for="campaign_name" class="control-label col-md-4"><span class="red">*</span> 
                    {t}Nom de la campagne :{/t}
                </label>
                <div class="col-md-8">
                    <input id="campaign_name" type="text" class="form-control" name="campaign_name"
                        value="{$data.campaign_name}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="campaign_description" class="control-label col-md-4">
                    {t}Description de la campagne :{/t}
                </label>
                <div class="col-md-8">
                    <textarea class="form-control" name="campaign_description" id="campaign_description">{$data.campaign_description}</textarea>
                </div>
            </div>
            <div class="form-group">
                <label for="referent_id" class="control-label col-md-4">
                    {t}Responsable ou référent de la campagne :{/t}
                </label>
                <div class="col-md-8">
                    <select id="referent_id" name="referent_id" class="form-control">
                        <option value="" {if $data.referent_id=="" }selected{/if}>{t}Choisissez{/t}</option>
                        {foreach $referents as $referent}
                        <option value="{$referent.referent_id}" {if
                            $referent.referent_id==$data.referent_id}selected{/if}>
                            {$referent.referent_name}
                        </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="campaign_from" class="control-label col-md-4">{t}Date de début :{/t}</label>
                <div class="col-md-8">
                    <input id="campaign_from" type="text" class="form-control datepicker" name="campaign_from"
                        value="{$data.campaign_from}">
                </div>
            </div>
            <div class="form-group">
                <label for="campaign_to" class="control-label col-md-4">{t}Date de fin :{/t}</label>
                <div class="col-md-8">
                    <input id="campaign_to" type="text" class="form-control datepicker" name="campaign_to"
                        value="{$data.campaign_to}">
                </div>
            </div>
            <div class="form-group">
                <label for="uuid" class="control-label col-md-4">{t}UID universel (UUID) :{/t}</label>
                <div class="col-md-8">
                    <input id="expiration_date" class="form-control uuid" name="uuid" value="{$data.uuid}">
                </div>
            </div>
            <div class="form-group">
                <label for="groupes" class="control-label col-md-4">
                    {t}Droits de modification attribués aux groupes :{/t}
                </label>
                <div class="col-md-7">
                    {section name=lst loop=$groupes}
                    <div class="col-md-2 col-sm-offset-3">
                        <div class="checkbox">
                            <label>
                                <input type="checkbox" name="groupes[]" value="{$groupes[lst].aclgroup_id}" 
                                {if $groupes[lst].checked==1}checked{/if}>
                                {$groupes[lst].groupe}
                            </label>
                        </div>
                    </div>
                    {/section}
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.campaign_id > 0}
                <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        {$csrf}</form>
    </div>
</div>