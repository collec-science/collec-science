{* Paramètres > Métadonnées > Nouveau > *}

{* anciennement <script type="text/javascript" src="display/javascript/alpaca/js/defineForm.js"></script>*}
<script type="text/javascript">
/*
 * fonctions permettant de definir les champs qui doivent figurer dans
 *  un formulaire de saisie des metadonnees
 * 
 */

//variable pour pouvoir trouver à quel champ on ajoute les données
var idChamp;

function setChoiceList(file){
     confirmed = true;
    if(file.length > 50){
        confirmed = confirm("Ce fichier contient plus de 50 entrées. Etes-vous sûr de vouloir l'importer ?");
    }
    if (confirmed){
        var numChild;
        //on retrouve le bon champ pour importer les données
        for(var i=0; i< $("#metadata").alpaca()["children"].length; i++){
            if ($("#metadata").alpaca()["children"][i]["id"]==idChamp){
                numChild=i;
            }
        }
        value = $("#metadata").alpaca().getValue();
        value[numChild]["choiceList"]=file;
        $("#metadata").alpaca("destroy");
        renderForm(value);
    }
}


function renderForm(data){
        $("#metadata").alpaca({
            "data": data,
            "view": "bootstrap-edit-horizontal",
            "schema": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "name": {
                            "title": "{t}Nom du champ (sans espace, sans accent, en minuscule){/t}",
                            "type": "string",
                            "required": true
                        },
                        "type": {
                            "title": "{t}Type du champ{/t}",
                            "type": "string",
                            "required": true,
                            "enum": ["number","string","textarea","checkbox","select", "radio"],
                            "default": "string"
                        },
                         "importFile":{
                            "type" : "string",
                            "format": "uri"
                        },
                        "choiceList": {
                            "title": "{t}Choix possibles{/t}",
                            "type": "array",
                            "items": {
                                "type": "string"
                            }
                        },
                        "isSearchable": {
                            "type":"radio",
                            "default":"no",
                            "enum":["yes","no"],
                            "optionsLabels":["oui","non"],
                            "title":"{t}champ utilisé pour rechercher un échantillon ?{/t}",
                            "emptySelectFirst":true,
                            /*"required":true*/
                       },
                       /* "enum": {
                            "title":"Liste de valeurs possibles (radio-boutons ou cases à cocher)",
                            "type": "array"
                        },*/
                        "required": {
                            "title":"{t}Le champ est-il obligatoire ?{/t}"
                        },
                        "helperChoice": {
                            "title":"{t}Affichage d'un message d'aide ?{/t}"
                        },
                        "helper" :{
                            "type": "string",
                            "title": "{t}Message d'aide{/t}"
                        },
                        "description" :{
                            "title": "{t}Description du champ{/t}",
                            "type" : "string",
                            "required": true
                        },
                        "measureUnit" :{
                            "title": "{t}Unité de mesure (ou modalités) - N/A si non applicable{/t}",
                            "type" : "string",
                            "required": true
                        }
                    },
                    "dependencies": {
                        "importFile":["type"],
                        "choiceList": ["type"],
                        "helper": ["helperChoice"]
                    }
                }
            },
            "options": {
                "items": {
                    "fields": {
                        "type": {
                            "optionLabels": ["{t}Nombre{/t}","{t}Texte (une ligne){/t}","{t}Texte (multi-ligne){/t}","{t}Case à cocher{/t}","{t}Liste à choix multiple{/t}","{t}Boutons Radio{/t}"],
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
                        "importFile":{
                            "type": "file",
                            "label" : "{t}Importer un fichier CSV{/t}",
                            "dependencies": {
                                "type":["select","checkbox","radio"]
                            },
                            "selectionHandler": function(files,data){
                                $.get(data[0],function(responseText){
                                    file=responseText.split(",");
                                    setChoiceList(file);
                                });
                                idChamp = this["parent"]["id"];
                            }
                        },
                        "choiceList":{
                            "dependencies": {
                                "type":["select","checkbox","radio"]
                            }
                        },
                        "isSearchable": {
                            "removeDefaultNone":true
                        },
                        "required": {
                            "type": "checkbox",
                            "rightLabel": "{t}Obligatoire{/t}"
                        },
                        "helperChoice": {
                            "type": "checkbox",
                            "rightLabel": "{t}Message d'aide{/t}"
                        },
                        "helper": {
                            "helper": "{t}Vous pouvez copier ici la description et l'unité de mesure{/t}",
                            "dependencies": {
                                "helperChoice": true
                            }
                        },
                        "description" :{
                            "type" : "textarea"
                        },
                        "measureUnit" :{
                            "type" : "textarea"
                        }
                    }
                }
            },
            "postRender": function(control) {
                console.log("test postRender");
                var value = control.getValue();
                $("#metadataField").val(JSON.stringify(value, null, null));
                
                 control.on("mouseout",function(){
                    var value = control.getValue();
                    $("#metadataField").val(JSON.stringify(value, null, null));
                });

                control.on("change",function(){
                    var value = control.getValue();
                    $("#metadataField").val(JSON.stringify(value, null, null));
                 });               
            }           
        });
}
</script>

<script type="text/javascript">
function loadSchema(){

}

$(document).ready(function() {

        var metadataParse= $("#metadataField").val();
        if (metadataParse.length > 0) {
            metadataParse = metadataParse.replace(/&quot;/g,'"');
            metadataParse = JSON.parse(metadataParse);
        }
        renderForm(metadataParse);

        $('#metadataForm').submit(function(event) {
        	console.log("write");
        	if ($("#action").val() == "Write") {
        		$('#metadata').alpaca().refreshValidationState(true);
                if(!$('#metadata').alpaca().isValid(true)){
                	alert("{t}La définition des métadonnées n'est pas valide.{/t}");
                	event.preventDefault();
                }
        	}
        });        
    });
</script>

<h2>{t}Création - Modification d'un modèle de métadonnées{/t}</h2>
<div class="row">
<div class="col-md-6">
<a href="index.php?module=metadataList">{t}Retour à la liste{/t}</a>

<form class="form-horizontal protoform" id="metadataForm" method="post" action="index.php" enctype="multipart/form-data">
{if $nbSample > 0}<fieldset disabled>{/if}
<input type="hidden" name="moduleBase" value="metadata">
<input type="hidden" id="action" name="action" value="Write">
<input type="hidden" name="metadata_id" value="{$data.metadata_id}">
<input type="hidden" name="metadata_schema" id="metadataField" value="{$data.metadata_schema}">

<div class="form-group">
<label for="metadataName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom du modèle :{/t}</label>
<div class="col-md-8">
<input id="metadataName" type="text" class="form-control" name="metadata_name" value="{$data.metadata_name}" required autofocus>
</div>
</div>

<fieldset>
<legend>{t}Jeu de métadonnées{/t}</legend>


<div id="metadata"></div>

</fieldset>

{if $nbSample < 1}
<div class="form-group center">
      <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
      {if $data.metadata_id > 0 }
      <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
      {/if}
 </div>
 {/if}
 {if $nbSample > 0}</fieldset>{/if}
</form>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>