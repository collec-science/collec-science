<div class="row">
    <div class="col-md-6">
        <a href="{$moduleListe}">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
        <a href="{$moduleParentOnly}Display?uid={$object.uid}&activeTab={$activeTab}">
            <img src="display/images/display.png" height="25">
            {t}Retour au détail{/t} ({$object.uid} {$object.identifier})
        </a>
    </div>
</div>
{if $rights.manage == 1}
<div class="row">
    <div class="col-md-6">
        <a href="{$moduleParentOnly}eventChange?event_id={$data.event_id}&uid={$data.uid}">
            <img src="display/images/edit.gif" height="25">
            {t}Modifier{/t}
        </a>
    </div>
</div>
{/if}
<div class="row">
    <h2>{t}Détail de l'événement{/t}</h2>
    <div class="form-display col-md-6">
        <dl class="dl-horizontal">
            <dt>{t}Type d'événement :{/t}</dt>
            <dd>{$data.event_type_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Date prévisionnelle de réalisation :{/t}</dt>
            <dd>{$data.due_date}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Date de l'événement :{/t}</dt>
            <dd>{$data.event_date}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Reste disponible :{/t}</dt>
            <dd>{$data.still_available}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Commentaire :{/t}</dt>
            <dd>{$data.event_comment}</dd>
        </dl>
    </div>
</div>
<div class="row">
    {include file="gestion/documentList.tpl"}
</div>