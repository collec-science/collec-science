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
                            "title": "Nom du champ (sans espace, sans accent, en minuscule)",
                            "type": "string",
                            "required": true
                        },
                        "type": {
                            "title": "Type du champ",
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
                            "title": "Choix possibles",
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
                         	"title":"champ utilisé pour rechercher un échantillon ?",
                         	"emptySelectFirst":true,
                         	/*"required":true*/
                       },
                       /* "enum": {
                        	"title":"Liste de valeurs possibles (radio-boutons ou cases à cocher)",
                        	"type": "array"
                        },*/
                        "required": {
                        	"title":"Le champ est-il obligatoire ?"
                        },
                        "helperChoice": {
                        	"title":"Affichage d'un message d'aide ?"
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
                        "measureUnit" :{
                            "title": "Unité de mesure (ou modalités) - N/A si non applicable",
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
                            "optionLabels": ["Nombre","Texte (une ligne)","Texte (multi-ligne)","Checkbox","Liste à choix multiple","Radio-boutons"],
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
                            "label" : "Importer un fichier CSV",
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
                            "rightLabel": "Obligatoire"
                        },
                        "helperChoice": {
                            "type": "checkbox",
                            "rightLabel": "Message d'aide"
                        },
                        "helper": {
                            "helper": "Vous pouvez copier ici la description et l'unité de mesure",
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

