<script>
    function patternForm(data) {
        $("#alpacaPattern").alpaca({
            "data": data,
            "view": "bootstrap-edit-horizontal",
            "schema": {
                "title":"{t}Description du modèle{/t}",
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "tableName": {
                            "title": "{t}Nom de la table{/t}",
                            "type": "string",
                            "required": true
                        },
                        "tableAlias": {
                            "title": "{t}Alias de la table (si elle dépend de plusieurs parents){/t}",
                            "type": "string"
                        },
                        "technicalKey": {
                            "title": "{t}Clé primaire{/t}",
                            "type": "string"
                        },
                        "isEmpty": {
                            "title":"{t}Table fournie vide (table de paramètres renseignée par les valeurs  fournies dans les autres enregistrements) ?{/t}",
                            "type": "boolean",
                            "default" : false
                        },
                        "businessKey": {
                            "title": "{t}Clé métier{/t}",
                            "type": "string",
                        },
                        "parentKey": {
                            "title": "{t}Nom de la clé étrangère (table parente){/t}",
                            "type": "string"
                        },
                        "istable11": {
                            "title": "{t}Relation de type 1-1 avec le parent (clé partagée){/t}",
                            "type": "boolean",
                            "default": false
                        },
                        "booleanFields": {
                            "title": "{t}Liste des champs de type booléen{/t}",
                            "type": "array",
                            "items": {
                                "type": "string"
                            }
                        },
                        "children": {
                            "title": "{t}Liste des alias des tables liées{/t}",
                            "type": "array",
                            "items" : {
                                "type": "object",
                                "properties": {
                                    "aliasName": {
                                        "title":"{t}Alias de la table{/t}",
                                        "type":"string"
                                    },
                                    "isStrict": {
                                        "title":"{t}Relation stricte (les enregistrements enfants sont totalement dépendants de l'enregistrement courant) ?{/t}",
                                        "type":"boolean",
                                        "default":true
                                    }
                                }
                            }
                        },
                        "parameters": {
                            "title":"{t}Liste des tables de paramètres associées{/t}",
                            "type":"array",
                            "items": {
                                "type":"object",
                                "properties": {
                                    "aliasName": {
                                        "title": "{t}Alias de la table{/t}",
                                        "type": "string"
                                    },
                                    "fieldName":{
                                        "title":"{t}Nom de la colonne dans la table courante{/t}",
                                        "type":"string"
                                    }
                                }
                            }
                        },
                        "istablenn":{
                            "title": "{t}Table de type n-n{/t}",
                            "type":"boolean",
                            "default":false
                        },
                        "tablenn":{
                            "type":"object",
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
                            "dependencies":"istablenn"
                        }
                    }
                },
                "dependencies": {
                    "istablenn": ["tablenn"]
                }
            },
            "options": {
                "fields":{
                    "tablenn": {
                        "dependencies": {
                            "istablenn": true
                        }
                    }
                }
            },
            "postRender": function (control) {
                var value = control.getValue();
                $("#pattern").val(JSON.stringify(value, null, null));
                control.on("mouseout", function () {
                    var value = control.getValue();
                    $("#pattern").val(JSON.stringify(value, null, null));
                });
                control.on("change", function () {
                    var value = control.getValue();
                    $("#pattern").val(JSON.stringify(value, null, null));
                });
            }
        });
    }
</script>