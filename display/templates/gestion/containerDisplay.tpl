<h2>Détail d'un conteneur</h2>
<a href="index.php?module=containerList"><img src="display/images/list.png" height="25">Retour à la liste</a>
{if $droits.gestion == 1}
&nbsp;
<a href="index.php?module=containerChange&container_id={$data.container_id}">
<img src="display/images/edit.gif" height="25">Modifier...
</a>
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
<dd>{$data.container_family_name} {$data.container_family_type}</dd>
</dl>
<dl class="dl-horizontal">
<dt>Produit utilisé :</dt>
<dd>{$data.storage_product} {$data.clp_classification}</dd>
</dl>

</div>
</fieldset>
</div>