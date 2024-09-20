{* Paramètres > Opérations > Nouveau > *}
<h2>{t}Création - Modification d'une operation{/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="operationList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal " id="operationForm" method="post" action="operationWrite">
<input type="hidden" name="moduleBase" value="operation">
<input type="hidden" name="operation_id" value="{$data.operation_id}">
<div class="form-group">
<label for="protocolId"  class="control-label col-md-4"><span class="red">*</span> {t}Protocole :{/t}</label>
<div class="col-md-8">
<select id="protocolId" name="protocol_id" class="form-control" autofocus>
{section name=lst loop=$protocol}
<option value="{$protocol[lst].protocol_id}" {if $data.protocol_id == $protocol[lst].protocol_id}selected{/if}>
{$protocol[lst].protocol_year} {$protocol[lst].protocol_name} {$protocol[lst].protocol_version}
</option>
{/section}
</select>
</div>
</div>

<div class="form-group">
<label for="operationName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom de l'opération :{/t}</label>
<div class="col-md-8">
<input id="operationName" type="text" class="form-control" name="operation_name" value="{$data.operation_name}" required>
</div>
</div>

<div class="form-group">
<label for="operationVersion"  class="control-label col-md-4"><span class="red">*</span> {t}Version de l'opération :{/t}</label>
<div class="col-md-8">
<input id="operationVersion" type="text" class="form-control" name="operation_version" value="{$data.operation_version}" required>
</div>
</div>

<div class="form-group">
<label for="operationOrder"  class="control-label col-md-4">{t}N° d'ordre :{/t}</label>
<div class="col-md-8">
<input id="operationOrder" type="number" class="form-control" name="operation_order" value="{$data.operation_order}">
</div>
</div>


<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.operation_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
 
{$csrf}</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>