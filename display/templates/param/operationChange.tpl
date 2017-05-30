<h2>Modification d'une operation</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=operationList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="operationForm" method="post" action="index.php" >
<input type="hidden" name="moduleBase" value="operation">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="operation_id" value="{$data.operation_id}">
<div class="form-group">
<label for="protocolId"  class="control-label col-md-4">Protocole<span class="red">*</span> :</label>
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
<label for="operationName"  class="control-label col-md-4">Nom de l'opération<span class="red">*</span> :</label>
<div class="col-md-8">
<input id="operationName" type="text" class="form-control" name="operation_name" value="{$data.operation_name}" required>
</div>
</div>

<div class="form-group">
<label for="operationOrder"  class="control-label col-md-4">N° d'ordre :</label>
<div class="col-md-8">
<input id="operationOrder" type="number" class="form-control" name="operation_order" value="{$data.operation_order}">
</div>
</div>


<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{$LANG["message"].19}</button>
      {if $data.operation_id > 0 }
      <button class="btn btn-danger button-delete">{$LANG["message"].20}</button>
      {/if}
 </div>
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>