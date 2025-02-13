<script>
    function generateMetadataForm(schema, data) {
        var metadata = document.getElementById('metadata');
        metadata.innerHTML = "";
        var inputs = new Array("string", "url", "date", "array", "number");
        schema.forEach(function (field, id) {
            var newId = "md_" + field.name;
            /**
             * Create main div 
             */
            var newDiv = document.createElement("div");
            newDiv.id = "div" + newId;
            newDiv.classList.add("form-group");
            metadata.appendChild(newDiv);
            /**
             * create label
             */
            var newLabel = document.createElement("label");
            newLabel.htmlFor = newId;
            newLabel.classList.add("control-label", "col-md-4");
            var labelContent = "";
            if (field.required) {
                var mandatory = document.createElement("span");
                mandatory.classList.add("red");
                mandatory.innerHTML = "*";
                newLabel.append(mandatory);
            }
            var labelContent = field.name;
            if (field.measureUnit) {
                labelContent += '&nbsp;(' + field.measureUnit + ')';
            }
            newLabel.innerHTML = labelContent;
            newDiv.appendChild(newLabel);

            /**
             * add secondary div for field
             */
            var divInput = document.createElement("div");
            divInput.classList.add("col-md-8");
            newDiv.appendChild(divInput);

            /**
             * check if a current value exists or use default value
             */
            var currentValue = "";
            if (field.defaultValue) {
                currentValue = field.defaultValue;
            }
            if (data[field.name]) {
                currentValue = data[field.name];
            }
            /**
             * add input or other
             */
            var isUnique = true;
            if (inputs.includes(field.type)) {
                var newInput = document.createElement("input");
                if (data[field.name]) {
                    newInput.value = data[field.name];
                } else if (field.defaultValue) {
                    newInput.value = field.defaultValue;
                }
            } else if (field.type == "select") {
                var newInput = document.createElement("select");
                if (field.multiple == "yes") {
                    newInput.multiple = true;
                }
                /**
                 * add options
                 */
                if (!field.required) {
                    var newOption = document.createElement("option");
                    if (currentValue == "") {
                        newOption.selected = true;
                    }
                    newOption.value = "";
                    newOption.innerHTML = "{t}Choisissez{/t}";
                    newInput.appendChild(newOption);
                }
                field.choicelist.forEach(function (choice) {
                    var newOption = document.createElement("option");
                    newOption.value = choice;
                    newOption.innerHTML = choice;
                    if (Array.isArray(currentValue)) {
                        if (currentValue.includes(choice)) {
                            newOption.selected = true;
                        }
                    } else if (choice == currentValue) {
                        newOption.selected = true;
                    }
                    newInput.appendChild(newOption);
                });

            } else if (field.type == "textarea") {
                var newInput = document.createElement("textarea");
                if (data[field.name]) {
                    newInput.innerHTML = data[field.name];
                } else if (field.defaultValue) {
                    newInput.innerHTML = field.defaultValue;
                }
            } else if (field.type == "checkbox" || field.type == "radio") {
                isUnique = false;
                var newInput = document.createElement("div");
                field.choicelist.forEach(function (choice) {
                    var divcb = document.createElement("div");
                    divcb.classList.add(field.type);
                    newInput.appendChild(divcb);
                    var cblabel = document.createElement("label");
                    var cbinput = document.createElement("input");
                    cbinput.type = field.type;
                    cbinput.value = choice;
                    if (field.type == "checkbox") {
                        cbinput.name = newId + [];
                        if (Array.isArray(currentValue)) {
                            if (currentValue.includes(choice)) {
                                newOption.checked = true;
                            }
                        } else if (choice == currentValue) {
                            newOption.checked = true;
                        }
                    } else {
                        cbinput.name = newId;
                        if (choice == currentValue) {
                            cbinput.checked = true;
                        }
                    }
                    cblabel.appendChild(cbinput);
                    var cbspan = document.createElement("span");
                    cbspan.innerHTML = choice;
                    cblabel.appendChild(cbspan);
                    divcb.appendChild(cblabel);
                    newInput.appendChild(divcb);
                });
            } else if (field.type == "array") {
                if (Array.isArray(data[field.name])) {
                    data[field.name].forEach(function (val) {
                        var newInput = document.createElement("input");
                        newInput.classList.add("formControl");
                        newInput.name = newId + "[]";
                        newInput.value = val;
                        divInput.appendChild (newInput);
                    });
                } else {
                    if (data[field.name]) {
                        var newInput = document.createElement("input");
                        newInput.classList.add("formControl");
                        newInput.name = newId + "[]";
                        newInput.value = data[field.name];
                        divInput.appendChild (newInput);
                    }
                }
                /**
                 * add a new empty line and generate an event
                 * to add others lines
                 */
                var newInput = document.createElement("input");
                newInput.name = newId + "[]";
                newInput.classList.add("formControl");
                input.addEventListener("keyup", function (e) {

                });
                //document.querySelectorAll(".some-element:last-child"))
            }
            if (isUnique) {
                if (field.required) {
                    newInput.required = true;
                }
                newInput.id = newId;
                if (field.multiple != 'yes') {
                    newInput.name = newId;
                } else {
                    newInput.name = newId + '[]';
                }

                newInput.classList.add("form-control");
                /**
                 * add title
                 */
                if (field.helper) {
                    newInput.title = field.helper;
                }
                /**
                 * add specific classes
                 */
                if (field.type == "date") {
                    newInput.classList.add("datepicker");
                } else if (field.type == "url") {
                    newInput.type = "url";
                } else if (field.type == "number") {
                    newInput.classList.add("taux");
                }
            }


            /**
             * Add description
             */
            var newDescription = document.createElement("div");
            newDescription.classList.add("metadataDescription");
            newDescription.innerHTML = field.description;
            var br = document.createElement("br");
            br.classList.add("brmetadata");
            divInput.appendChild(newInput);
            divInput.appendChild(br);
            divInput.appendChild(newDescription);
        });
    }
</script>