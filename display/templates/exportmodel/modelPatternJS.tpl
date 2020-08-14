<script>
    function patternForm( data ) {
        $( "#alpacaPattern" ).alpaca( {
            "data": data,
            "view": "bootstrap-edit-horizontal",
            "schema": {
                "title": "Model description",
                "type": "array",
                "items": {
                    "title": "Description of a table",
                    "type": "object",
                    "properties": {
                        "tableName": {
                            "title": "Name of the table",
                            "type": "string",
                            "required": true
                        },
                        "tableAlias": {
                            "title": "Alias of the table (if depends of multiple parents)",
                            "type": "string"
                        },
                        "technicalKey": {
                            "title": "Primary key",
                            "type": "string"
                        },
                        "isEmpty": {
                            "title": "Table empty (Parameter table filled with other table records)?",
                            "type": "boolean",
                            "default": false
                        },
                        "businessKey": {
                            "title": "Business key",
                            "type": "string",
                        },
                        "parentKey": {
                            "title": "Foreign key (to link to the parent table)",
                            "type": "string"
                        },
                        "istable11": {
                            "title": "Relation of type 1-1 with the parent (shared key)",
                            "type": "boolean",
                            "default": false
                        },
                        "children": {
                            "title": "Liste of alias of related tables",
                            "type": "array",
                            "items": {
                                "type": "object",
                                "properties": {
                                    "aliasName": {
                                        "title": "Alias of the table",
                                        "type": "string"
                                    },
                                    "isStrict": {
                                        "title": "Strict relation (the children records depends only of the current record) ?",
                                        "type": "boolean",
                                        "default": true
                                    }
                                }
                            }
                        },
                        "parents": {
                            "title": "Liste of parents tables",
                            "type": "array",
                            "items": {
                                "type": "object",
                                "properties": {
                                    "aliasName": {
                                        "title": "Table alias",
                                        "type": "string"
                                    },
                                    "fieldName": {
                                        "title": "Column name in the current table",
                                        "type": "string"
                                    }
                                }
                            }
                        },
                        "istablenn": {
                            "title": "Table of type n-n",
                            "type": "boolean",
                            "default": false
                        },
                        "tablenn": {
                            "type": "object",
                            "properties": {
                                "secondaryParentKey": {
                                    "title": "Name of the second foreign key",
                                    "type": "string"
                                },
                                "tableAlias": {
                                    "title": "Alias of the second table",
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