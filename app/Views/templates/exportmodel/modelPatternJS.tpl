<script>
    function patternForm( data ) {
        $( "#alpacaPattern" ).alpaca( {
            "data": data,
            "view": "bootstrap-edit-horizontal",
            "schema": {
                "title": "{t}Description du modèle{/t}",
                "type": "array",
                "items": {
                    "title": "{t}Description de la table{/t}",
                    "type": "object",
                    "properties": {
                        "tableName": {
                            "title": "{t}Nom de la table{/t}",
                            "type": "string",
                            "required": true
                        },
                        "tableAlias": {
                            "title": "{t}Alias de la table (si elle dépend de multiples parents){/t}",
                            "type": "string"
                        },
                        "technicalKey": {
                            "title": "{t}Clé primaire ou technique{/t}",
                            "type": "string"
                        },
                        "isEmpty": {
                            "title": "{t}Table vide (le contenu est alimenté par les tables qui lui sont liées, table de paramètres) ?{/t}",
                            "type": "boolean",
                            "default": false
                        },
                        "businessKey": {
                            "title": "{t}Clé métier{/t}",
                            "type": "string",
                        },
                        "parentKey": {
                            "title": "{t}Clé étrangère (pour être reliée à la table parente){/t}",
                            "type": "string"
                        },
                        "istable11": {
                            "title": "{t}Relation de type 1-1 avec la table parente (clé partagée) ?{/t}",
                            "type": "boolean",
                            "default": false
                        },
                        "children": {
                            "title": "{t}Liste des alias des tables liées{/t}",
                            "type": "array",
                            "items": {
                                "type": "object",
                                "properties": {
                                    "aliasName": {
                                        "title": "{t}Alias de la table{/t}",
                                        "type": "string"
                                    },
                                    "isStrict": {
                                        "title": "{t}Relation stricte (les enregistrements sont liés à ceux de la table parente) ?{/t}",
                                        "type": "boolean",
                                        "default": true
                                    }
                                }
                            }
                        },
                        "parents": {
                            "title": "{t}Liste des tables parentes{/t}",
                            "type": "array",
                            "items": {
                                "type": "object",
                                "properties": {
                                    "aliasName": {
                                        "title": "{t}Alias de la table{/t}",
                                        "type": "string"
                                    },
                                    "fieldName": {
                                        "title": "{t}Nom de la colonne portant la relation dans la table courante{/t}",
                                        "type": "string"
                                    }
                                }
                            }
                        },
                        "istablenn": {
                            "title": "{t}Table de type n-n ?{/t}",
                            "type": "boolean",
                            "default": false
                        },
                        "tablenn": {
                            "type": "object",
                            "properties": {
                                "secondaryParentKey": {
                                    "title": "{t}Nom de la seconde clé étrangère{/t}",
                                    "type": "string"
                                },
                                "tableAlias": {
                                    "title": "{t}Alias de la seconde table{/t}",
                                    "type": "string"
                                }
                            },
                            "dependencies": "istablenn"
                        }
                    }
                },
                "dependencies": {
                    "istablenn": [ "tablenn" ]
                }
            },
            "options": {
                "fields": {
                    "tablenn": {
                        "dependencies": {
                            "istablenn": true
                        }
                    }
                }
            },
            "postRender": function ( control ) {
                var value = control.getValue();
                $( "#pattern").val( JSON.stringify( value, null, null ) );
                control.on( "mouseout", function () {
                    var value = control.getValue();
                    $( "#pattern" ).val( JSON.stringify( value, null, null ) );
                } );
                control.on( "change", function () {
                    var value = control.getValue();
                    $( "#pattern" ).val( JSON.stringify( value, null, null ) );
                } );
            }
        } )
    };
</script>