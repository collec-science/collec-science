{* Objets > Contenants > Rechercher > UID d'un contenant > *}
<h2>{t}Détail d'un contenant{/t}</h2>
<div class="row">
<div class="col-md-12">
<a href="index.php?module={$moduleListe}"><img src="{$display}/images/list.png" height="25">{t}Retour à la liste{/t}</a>
{if $droits.gestion == 1}
&nbsp;
<a href="index.php?module=containerChange&uid=0">
<img src="{$display}/images/new.png" height="25">
{t}Nouveau container{/t}
</a>
&nbsp;
<a href="index.php?module=containerChange&uid={$data.uid}">
<img src="{$display}/images/edit.gif" height="25">{t}Modifier{/t}
</a>

<!-- Entrée ou sortie -->
<span id="input">
<a href="index.php?module=movementcontainerInput&movement_id=0&uid={$data.uid}" id="input" title="Entrer ou déplacer le contenant dans un autre contenant">
<img src="{$display}/images/input.png" height="25">{t}Entrer ou déplacer...{/t}
</a>
</span>

<span id="output">
<a href="index.php?module=movementcontainerOutput&movement_id=0&uid={$data.uid}" id="output" title="Sortir le contenant du stock">
<img src="{$display}/images/output.png" height="25">{t}Sortir du stock...{/t}</a></span>

{/if}
&nbsp;
<a href="#containers">
<img src="{$display}/images/box.png" height="25">{t}Contenants présents{/t}
</a>
&nbsp;
<a href="#echantillons">
<img src="{$display}/images/sample.png" height="25">{t}Échantillons présents{/t}
</a>
&nbsp;
<a href="#documents">
<img src="{$display}/images/camera.png" height="25">{t}Documents associés{/t}
</a>
&nbsp;
<a href="#bookings">
<img src="{$display}/images/crossed-calendar.png" height="25">{t}Réservations{/t}
</a>
&nbsp;
<a href="index.php?module=containerDisplay&uid={$data.uid}">
<img src="{$display}/images/refresh.png" title="Rafraîchir la page" height="15">
</a>
</div>
</div>

<div class="row">
<fieldset class="col-md-4">
<legend>{t}Informations générales{/t}</legend>
<div class="form-display">
<dl class="dl-horizontal">
<dt>{t}UID et référence :{/t}</dt>
<dd>{$data.uid} {$data.identifier}</dd>
</dl>
<dl class="dl-horizontal">
<dt>{t}Type :{/t}</dt>
<dd>{$data.container_family_name} - {$data.container_type_name}</dd>
</dl>
<dl class="dl-horizontal">
<dt>{t}Produit utilisé :{/t}</dt>
<dd>{$data.storage_condition_name} 
{if strlen($data.storage_product) >0 && strlen($data.storage_condition_name) > 0}
<br>
{/if}
{$data.storage_product} 
{if (strlen($data.storage_product) >0 || strlen($data.storage_condition_name) > 0) && strlen($data.clp_classification) > 0 }
<br>
{/if}
{$data.clp_classification}</dd>
</dl>
<dl class="dl-horizontal">
<dt>{t}Statut :{/t}</dt>
<dd>{$data.object_status_name}</dd>
</dl>
{if strlen($data.wgs84_x) > 0 || strlen($data.wgs84_y) > 0}
<dl class="dl-horizontal">
  <dt>{t}Latitude :{/t}</dt>
  <dd>{$data.wgs84_y}</dd>
</dl>
<dl class="dl-horizontal">
  <dt>{t}Longitude :{/t}</dt>
  <dd>{$data.wgs84_x}</dd>
</dl>
{/if}
<dl class="dl-horizontal">
<dt>{t}Emplacement :{/t}</dt>
<dd>
{section name=lst loop=$parents}
<a href="index.php?module=containerDisplay&uid={$parents[lst].uid}">
{$parents[lst].uid} {$parents[lst].identifier} {$container_type_name}
</a>
{if not $smarty.section.lst.last}
<br>
{/if}
{/section}
</dd>
</dl>

</div>
{include file="gestion/objectIdentifierList.tpl"}

{if strlen($data.wgs84_x) > 0 && strlen($data.wgs84_y) > 0}

{include file="gestion/objectMapDisplay.tpl"}

{/if}
</fieldset>
<div class="col-md-8">
<fieldset>
<legend>{t}Événements{/t}</legend>
{include file="gestion/eventList.tpl"}
</fieldset>
<fieldset>
<legend>{t}Mouvements{/t}</legend>
{include file="gestion/objectMovementList.tpl"}
</fieldset>
</div>

<fieldset class="col-md-8" id="containers">
<legend>{t}Contenants présents{/t}</legend>
<a href="index.php?module=containerChange&uid=0&container_parent_uid={$data.uid}">
<img src="{$display}/images/new.png" height="25">
{t}Nouveau contenant associé{/t}
</a>
{include file="gestion/containerListDetail.tpl"}
</fieldset>

<fieldset class="col-md-12" id="echantillons">
<legend>{t}Échantillons présents{/t}</legend>
{include file="gestion/sampleListDetail.tpl"}
</fieldset>

{if $nblignes > 1 || $nbcolonnes > 1}
<fieldset class="col-md-12" id="occupation">
<legend>{t}Répartition des objets dans le contenant{/t}</legend>
{include file="gestion/containerDisplayOccupation.tpl"}
</fieldset>
{/if}

<fieldset class="col-md-12" id="documents">
<legend>{t}Documents associés{/t}</legend>
{include file="gestion/documentList.tpl"}
</fieldset>

<fieldset class="col-md-12" id="bookings">
<legend>{t}Réservations{/t}</legend>
{include file="gestion/bookingList.tpl"}
</fieldset>

</div>