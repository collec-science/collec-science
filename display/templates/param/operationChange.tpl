<script type="text/javascript">
function renderForm(data){
        $("#metadata").alpaca({
            "data": data,
            "schema": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "nom": {
                            "title": "Nom du champ",
                            "type": "string",
                            "required": true
                        },
                        "type": {
                            "title": "Type du champ",
                            "type": "string",
                            "required": true,
                            "enum": ["number","string","textarea","date","checkbox","time","datetime","select"],
                            "default": "string"
                        },
                        "choiceList": {
                            "title": "Choix possibles",
                            "type": "array",
                            "items": {
                                "type": "string"
                            }
                        },
                        "require": {
                        },
                        "helperChoice": {
                        },
                        "helper" :{
                            "type": "string",
                            "title": "Message d'aide"
                        },
                        "description" :{
                            "title": "Description du champ",
                            "type" : "string",
                            "required": true
                        },
                        "meusureUnit" :{
                            "title": "Unité de mesure (ou modalités)",
                            "type" : "string",
                            "required": true
                        }
                    },
                    "dependencies": {
                        "choiceList": ["type"],
                        "helper": ["helperChoice"]
                    }
                }
            },
            "options": {
                "items": {
                    "fields": {
                        "type": {
                            "optionLabels": ["Nombre","Texte (une ligne)","Texte (multi-ligne)","Date","Checkbox","Temps","Date et Temps","Liste à choix multiple"],
                            "type": "select",
                            "hideNone": true,
                            "sort": function(a, b) { 
                                            return 0; 
                                        }
                        },
                        "typeList":{
                            "dependencies": {
                                "type":"Liste"
                            }
                        },
                        "choiceList":{
                            "dependencies": {
                                "type":"select"
                            }
                        },
                        "require": {
                            "type": "checkbox",
                            "rightLabel": "Obligatoire"
                        },
                        "helperChoice": {
                            "type": "checkbox",
                            "rightLabel": "Message d'aide"
                        },
                        "helper": {
                            "dependencies": {
                                "helperChoice": true
                            }
                        },
                        "description" :{
                            "type" : "textarea"
                        },
                        "meusureUnit" :{
                            "type" : "textarea"
                        }
                    }
                }
            },
            "postRender": function(control) {

                control.on("mouseout",function(){
                var value = control.getValue();
                var metadataField = document.getElementById("metadataField");
                metadataField.setAttribute("value",JSON.stringify(value, null,null));
                });

                control.on("change",function(){
                var value = control.getValue();
                var metadataField = document.getElementById("metadataField");
                metadataField.setAttribute("value",JSON.stringify(value, null,null));
                });

                var value = control.getValue();
                var metadataField = document.getElementById("metadataField");
                metadataField.setAttribute("value",JSON.stringify(value, null,null));
                
                
            }
            
        });
}

function loadSchema(){
    var $metadataFormId = document.getElementById("copySchema").value;
    {section name=lst loop=$metadata}
        if ($metadataFormId == {$metadata[lst].metadata_form_id}){
            var $schemaCopy = "{$metadata[lst].schema}";
            $schemaCopy = $schemaCopy.replace(/&quot;/g,'"');
            $schemaCopy = JSON.parse($schemaCopy);

            $("#metadata").alpaca("destroy");
            renderForm($schemaCopy);
        }
    {/section}
}
</script>


<h2>Modification d'une operation</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=operationList">{$LANG.appli.1}</a>

<form class="form-horizontal protoform" id="operationForm" method="post" action="index.php" >
<input type="hidden" name="moduleBase" value="operation">
<input type="hidden" name="action" value="Write">
<input type="hidden" name="operation_id" value="{$data.operation_id}">
<input type="hidden" name="metadata_form_id" value="{$data.metadata_form_id}">
<input type="hidden" name="metadataField" id="metadataField">
<div class="form-group">
<label for="protocolId"  class="control-label col-md-4">Protocole<span class="red">*</span> :</label>
<div class="col-md-8">
<select id="protocolId" name="protocol_id" class="form-control" autofocus>
{section name=lst loop=$protocol}
<option value="{$protocol[lst].protocol_id}">
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

<div class="form-group">
<div class="col-md-8">
    <legend>Jeu de métadonnées</legend>

    <label for="copySchema"  class="control-label col-md-4">Partir d'un schéma existant :</label>
    <div class="col-md-8">
    <select id="copySchema" name="copySchema" class="form-control" onChange="loadSchema()" autofocus>
    {section name=lst loop=$operations}
    <option value="{$operations[lst].metadata_form_id}">
    {$operations[lst].operation_name}
    </option>
    {/section}
    </select>
    </div>

    <div id="metadata"></div>
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


<script type="text/javascript">
    $(document).ready(function() {

        var $metadataParse="";
        {section name=lst loop=$metadata}
        {if $metadata[lst].metadata_form_id == $data.metadata_form_id}
        $metadataParse = "{$metadata[lst].schema}";
        $metadataParse = $metadataParse.replace(/&quot;/g,'"');
        $metadataParse = JSON.parse($metadataParse);
        {/if}
        {/section}
        
        renderForm($metadataParse);
        
    });
</script>