<h2>Détail d'un échantillon</h2>
<div class="row">
<div class="col-sm-12">
<a href="index.php?module=sampleList"><img src="display/images/list.png" height="25">Retour à la liste</a>
{if $droits.gestion == 1}
&nbsp;
<a href="index.php?module=sampleChange&uid=0">
<img src="display/images/new.png" height="25">
Nouvel échantillon
</a>
{if $modifiable == 1}
&nbsp;
<a href="index.php?module=sampleChange&uid={$data.uid}">
<img src="display/images/edit.gif" height="25">Modifier...
</a>
{/if}
<!-- Entrée ou sortie -->
{if count($parents) > 0}
<span id="output">
<a href="index.php?module=storagesampleOutput&storage_id=0&uid={$data.uid}" id="output" title="Sortir l'échantillon du stock">
<img src="display/images/output.png" height="25">Sortie</a></span>
{else}
<span id="input">
<a href="index.php?module=storagesampleInput&storage_id=0&uid={$data.uid}" id="input" title="Entrer l'échantillon dans le stock">
<img src="display/images/input.png" height="25">Entrée
</a>
</span>
{/if}
{/if}
&nbsp;
<a href="#echantillons">
<img src="display/images/sample.png" height="25">Échantillons rattachés
</a>
&nbsp;
<a href="#bookings">
<img src="display/images/crossed-calendar.png" height="25">Réservations
</a>

<div class="row">

<fieldset class="col-sm-4">
<legend>Informations générales</legend>
<div class="form-display">
<dl class="dl-horizontal">
<dt>UID et référence :</dt>
<dd>{$data.uid} {$data.identifier}</dd>
</dl>
<dl class="dl-horizontal">
<dt>Projet :</dt>
<dd>{$data.project_name}</dd>
</dl>
<dl class="dl-horizontal">
<dt>Type :</dt>
<dd>{$data.sample_type_name}</dd>
</dl>
<dl class="dl-horizontal">
<dt>Statut :</dt>
<dd>{$data.object_status_name}</dd>
</dl>
<dl class="dl-horizontal">
<dt title="Date de création de l'échantillon">Date de création de l'échantillon :</dt>
<dd>{$data.sample_date}</dd>
</dl>
<dl class="dl-horizontal">
<dt title="Date d'import dans la base de données">Date d'import dans la base de données :</dt>
<dd>{$data.sample_creation_date}</dd>
</dl>
{if $data.parent_uid > 0}
<dl class="dl-horizontal">
<dt title="Échantillon parent">Échantillon parent :</dt>
<dd><a href="index.php?module=sampleDisplay&uid={$data.parent_uid}">
{$data.parent_uid} {$data.parent_identifier}
</a>
</dd>
</dl>
{/if}
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
{if strlen($data.wgs84_x) > 0 && strlen($data.wgs84_y) > 0}
{include file="gestion/objectMapDisplay.tpl"}
{/if}
</fieldset>

<div class="col-sm-8">

<fieldset>
<legend>Événements</legend>
{include file="gestion/eventList.tpl"}
</fieldset>
<fieldset>
<legend>Mouvements</legend>
{include file="gestion/storageList.tpl"}
</fieldset>

</div>

</div>


<fieldset class="col-sm-12" id="booking">
<legend>Réservations</legend>
{include file="gestion/bookingList.tpl"}
</fieldset>

<fieldset class="col-sm-12" id="echantillons">
<legend>Échantillons rattachés</legend>
{if $droits.gestion == 1 && $modifiable == 1}
<a href="index.php?module=sampleChange&uid=0&parent_uid={$data.uid}">
<img src="display/images/new.png" height="25">
Nouvel échantillon rattaché...
</a>
{/if}
{include file="gestion/sampleListDetail.tpl"}
</fieldset>
</div>
</div>