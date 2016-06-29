<h2>Détail d'un conteneur</h2>
<a href="index.php?module=containerList"><img src="display/images/list.png" height="25">Retour à la liste</a>
{if $droits.gestion == 1}
&nbsp;
<a href="index.php?module=containerChange&uid=0">
<img src="display/images/new.png" height="25">
Nouveau conteneur
</a>
&nbsp;
<a href="index.php?module=containerChange&uid={$data.uid}">
<img src="display/images/edit.gif" height="25">Modifier...
</a>
<!-- Entrée ou sortie -->
{if count($parents) > 0}
<span id="output">
<a href="#" id="output">
<img src="display/images/output.png" height="25">Sortie</a></span>
{else}
<span id="input">
<a href="index.php?module=storageContainerInput&storage_id=0&uid={$data.uid}&movement_id=1" id="input">
<img src="display/images/input.png" height="25">Entrée
</a>
</span>
{/if}
{/if}
<div class="row">

<fieldset class="col-md-6">
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
<dd>{$data.storage_product} {$data.clp_classification}</dd>
</dl>
<dl class="dl-horizontal">
<dt>Statut :</dt>
<dd>{$data.container_status_name}</dd>
</dl>

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

</fieldset>
<fieldset class="col-md-6">
<legend>Événements</legend>
{include file="gestion/eventList.tpl"}
</fieldset>

<fieldset class="col-md-12">
<legend>Conteneurs présents</legend>
<a href="index.php?module=containerChange&uid=0&container_parent_uid={$data.uid}">
<img src="display/images/new.png" height="25">
Nouveau conteneur associé
</a>
{include file="gestion/containerListDetail.tpl"}
</fieldset>
<fieldset class="col-md-12">
<legend>Échantillons présents</legend>
{include file="gestion/sampleListDetail.tpl"}
</fieldset>
</div>