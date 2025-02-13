<script>
    function generateMetadataForm(schema, data) {
        var metadata = document.getElementById('metadata');
        metadata.innerHTML = "";
        var inputs = new Array("number", "string", "url", "date", "array");
        schema.forEach(function (field, id) {
            var newId = "md_" + field.name;
            /**
             * Create div and label
             */
            var newDiv = document.createElement("div");
            newDiv.id = "div" + newId;
            newDiv.classList.add("form-group");
            metadata.appendChild(newDiv);
            var newLabel = document.createElement("label");
            newLabel.htmlFor = newId;
            newLabel.classList.add("control-label", "col-md-4");
            var labelContent = field.name;
            if (field.measureUnit) {
                labelContent += '&nbsp;(' + field.measureUnit + ')';
            }
            newLabel.innerHTML = labelContent;
            if (field.required) {
                var mandatory = document.createElement("span");
                mandatory.classList.add("red");
                mandatory.innerHTML = "*";
                newLabel.append(mandatory);
            }
            newDiv.appendChild(newLabel);

            /**
             * add secondary div for field
             */
            var divInput = document.createElement("div");
            divInput.classList.add("col-md-8");
            newDiv.appendChild(divInput);

            /**
             * add input or other
             */
            var isUnique = true;
            if (inputs.indexOf(field.type)) {
                var newInput = document.createElement("input");
                if (data[field.name]) {
                    newInput.value = data[field.name];
                } else if (field.defaultValue) {
                    newInput.value = field.defaultValue;
                }
            } else if (field.type == "select") {

            }
            if (field.type == "textarea") {
                var newInput = document.createElement("textarea");
                if (data[field.name]) {
                    newInput.innerHTML = data[field.name];
                } else if (field.defaultValue) {
                    newInput.innerHTML = field.defaultValue;
                }
            }
            if (isUnique) {
                if (field.required) {
                    newInput.required = true;
                }
                newInput.id = newId;
                newInput.name = newId;
            }
            newInput.classList.add("form-control");

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