<h2>Détail d'un container</h2>
<div class="row">
<div class="col-md-12">
<a href="index.php?module=containerList"><img src="{$display}/images/list.png" height="25">Retour à la liste</a>
{if $droits.gestion == 1}
&nbsp;
<a href="index.php?module=containerChange&uid=0">
<img src="{$display}/images/new.png" height="25">
Nouveau container
</a>
&nbsp;
<a href="index.php?module=containerChange&uid={$data.uid}">
<img src="{$display}/images/edit.gif" height="25">Modifier...
</a>

<!-- Entrée ou sortie -->
<span id="input">
<a href="index.php?module=storagecontainerInput&storage_id=0&uid={$data.uid}" id="input" title="Entrée le container dans le stock">
<img src="{$display}/images/input.png" height="25">Entrée
</a>
</span>

<span id="output">
<a href="index.php?module=storagecontainerOutput&storage_id=0&uid={$data.uid}" id="output" title="Sortir le container du stock">
<img src="{$display}/images/output.png" height="25">Sortie</a></span>

{/if}
&nbsp;
<a href="#containers">
<img src="{$display}/images/box.png" height="25">containers présents
</a>
&nbsp;
<a href="#echantillons">
<img src="{$display}/images/sample.png" height="25">Échantillons présents
</a>
&nbsp;
<a href="#documents">
<img src="{$display}/images/camera.png" height="25">Documents associés
</a>
&nbsp;
<a href="#bookings">
<img src="{$display}/images/crossed-calendar.png" height="25">Réservations
</a>
&nbsp;
<a href="index.php?module=containerDisplay&uid={$data.uid}">
<img src="{$display}/images/refresh.png" title="Rafraîchir la page" height="15">
</a>
</div>
</div>

<div class="row">
<fieldset class="col-md-4">
<legend>Informations générales</legend>
<div class="form-display">
<dl class="dl-horizontal">
<dt>UID et référence :</dt>
<dd>{$data.uid} {$data.identifier}</dd>
</dl>
<dl class="dl-horizontal">
<dt>Type :</dt>
<dd>{$data.container_family_name} - {$data.container_type_name}</dd>
</dl>
<dl class="dl-horizontal">
<dt>Produit utilisé :</dt>
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
<dt>Statut :</dt>
<dd>{$data.object_status_name}</dd>
</dl>
{if strlen($data.wgs84_x) > 0 || strlen($data.wgs84_y) > 0}
<dl class="dl-horizontal">
  <dt>Latitude :</dt>
  <dd>{$data.wgs84_y}</dd>
</dl>
<dl class="dl-horizontal">
  <dt>Longitude :</dt>
  <dd>{$data.wgs84_x}</dd>
</dl>
{/if}
<dl class="dl-horizontal">
<dt>Emplacement :</dt>
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
<legend>Événements</legend>
{include file="gestion/eventList.tpl"}
</fieldset>
<fieldset>
<legend>Mouvements</legend>
{include file="gestion/storageList.tpl"}
</fieldset>
</div>

<fieldset class="col-md-8" id="containers">
<legend>containers présents</legend>
<a href="index.php?module=containerChange&uid=0&container_parent_uid={$data.uid}">
<img src="{$display}/images/new.png" height="25">
Nouveau container associé
</a>
{include file="gestion/containerListDetail.tpl"}
</fieldset>

<fieldset class="col-md-12" id="echantillons">
<legend>Échantillons présents</legend>
{include file="gestion/sampleListDetail.tpl"}
</fieldset>

{if $nblignes > 1 || $nbcolonnes > 1}
<fieldset class="col-md-12" id="occupation">
<legend>Répartition des objets dans le container</legend>
{include file="gestion/containerDisplayOccupation.tpl"}
</fieldset>
{/if}

<fieldset class="col-md-12" id="documents">
<legend>Documents associés</legend>
{include file="gestion/documentList.tpl"}
</fieldset>

<fieldset class="col-md-12" id="bookings">
<legend>Réservations</legend>
{include file="gestion/bookingList.tpl"}
</fieldset>

</div>