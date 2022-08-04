<script type="text/javascript">
    /*
     * fonctions permettant de definir les champs qui doivent figurer dans
     *  un formulaire de saisie des metadonnees
     *
     */

    //variable pour pouvoir trouver à quel champ on ajoute les données
    var idChamp;

    function setChoiceList( file ) {
        confirmed = true;
        if ( file.length > 50 ) {
            confirmed = confirm( "{t}Ce fichier contient plus de 50 entrées. Etes-vous sûr de vouloir l'importer ?{/t}" );
        }
        if ( confirmed ) {
            var numChild;
            //on retrouve le bon champ pour importer les données
            for ( var i = 0; i < $( "#metadata" ).alpaca()[ "children" ].length; i++ ) {
                if ( $( "#metadata" ).alpaca()[ "children" ][ i ][ "id" ] == idChamp ) {
                    numChild = i;
                }
            }
            value = $( "#metadata" ).alpaca().getValue();
            value[ numChild ][ "choiceList" ] = file;
            $( "#metadata" ).alpaca( "destroy" );
            renderForm( value );
        }
    }


    function renderForm( data ) {
        $( "#metadata" ).alpaca( {
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
                            "enum": [ "number", "string", "date", "textarea", "checkbox", "select", "radio", "url", "array" ],
                            "default": "string"
                        },
                        "importFile": {
                            "type": "string",
                            "format": "uri"
                        },
                        "multiple": {
                            "type": "string",
                            "default":"no",
                            "enum": ["yes", "no"],
                            "title": "{t}Sélection multiple possible ?{/t}"
                        },
                        "choiceList": {
                            "title": "{t}Choix possibles{/t}",
                            "type": "array",
                            "items": {
                                "type": "string"
                            }
                        },
                        "isSearchable": {
                            "type": "string",
                            "default": "no",
                            "enum": [ "yes", "no" ],
                            "title": "{t}champ utilisé pour rechercher un échantillon ?{/t}"
                        },
                        "required": {
                            "title": "{t}Le champ est-il obligatoire ?{/t}"
                        },
                        "defaultValue": {
                            "title": "{t}Valeur par défaut{/t}"
                        },
                        "helperChoice": {
                            "title": "{t}Affichage d'un message d'aide ?{/t}"
                        },
                        "helper": {
                            "type": "string",
                            "title": "{t}Message d'aide{/t}"
                        },
                        "description": {
                            "title": "{t}Description du champ{/t}",
                            "type": "string",
                            "required": true
                        },
                        "measureUnit": {
                            "title": "{t}Unité de mesure (ou modalités) - N/A si non applicable{/t}",
                            "type": "string",
                            "required": true,
                            "default": "N/A"
                        }
                    },
                    "dependencies": {
                        "importFile": [ "type" ],
                        "choiceList": [ "type" ],
                        "helper": [ "helperChoice" ],
                        "multiple": [ "type" ]
                    },
                }
            },
            "options": {
                "items": {
                    "fields": {
                        "type": {
                            "optionLabels": [ "{t}Nombre{/t}", "{t}Texte (une ligne){/t}", "{t}Date{/t}", "{t}Texte (multi-ligne){/t}", "{t}Case à cocher{/t}", "{t}Liste à choix multiple{/t}", "{t}Boutons Radio{/t}", "{t}Lien vers un site externe (URL){/t}", "{t}Valeurs multiples{/t}" ],
                            "type": "select",
                            "hideNone": true,
                            "sort": function ( a, b ) {
                                return 0;
                            }
                        },
                        "multiple": {
                            "dependencies": {
                                "type": "select"
                            },
                            "optionLabels":[
                                "{t}oui{/t}",
                                "{t}non{/t}"],
                            "removeDefaultNone": true,
                            "vertical": false
                        },
                        "typeList": {
                            "dependencies": {
                                "type": "Liste"
                            }
                        },

                        "importFile": {
                            "type": "file",
                            "label": "{t}Importer un fichier CSV{/t}",
                            "dependencies": {
                                "type": [ "select", "checkbox", "radio" ]
                            },
                            "selectionHandler": function ( files, data ) {
                                $.get( data[ 0 ], function ( responseText ) {
                                    file = responseText.split( "," );
                                    setChoiceList( file );
                                } );
                                idChamp = this[ "parent" ][ "id" ];
                            }
                        },
                        "choiceList": {
                            "dependencies": {
                                "type": [ "select", "checkbox", "radio" ]
                            }
                        },
                        "isSearchable": {
                            "removeDefaultNone": true,
                            "optionLabels": [ "{t}oui{/t}", "{t}non{/t}" ],
                            "vertical":false
                        },
                        "required": {
                            "type": "checkbox",
                            "rightLabel": "{t}Obligatoire{/t}"
                        },
                        "defaultValue": {
                            "type": "text"
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
                        "description": {
                            "type": "textarea",
                            "rows": 3
                        },
                        "measureUnit": {
                            "type": "textarea",
                            "rows": 3
                        }
                    }
                }
            },
            "postRender": function ( control ) {
                var value = control.getValue();
                $( "#metadataField" ).val( JSON.stringify( value, null, null ) );

                control.on( "mouseout", function () {
                    var value = control.getValue();
                    $( "#metadataField" ).val( JSON.stringify( value, null, null ) );
                } );

                control.on( "change", function () {
                    var value = control.getValue();
                    $( "#metadataField" ).val( JSON.stringify( value, null, null ) );
                } );
            }
        } );
    }
</script>
