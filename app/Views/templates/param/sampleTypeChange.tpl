<h2>{t}Création - Modification d'un type d'échantillon{/t}</h2>
<div class="row">
      <div class="col-md-6">
            <a href="sampleTypeList">{t}Retour à la liste{/t}</a>

            <form class="form-horizontal " id="sampleTypeForm" method="post" action="sampleTypeWrite">
                  <input type="hidden" name="moduleBase" value="sampleType">
                  <input type="hidden" name="sample_type_id" value="{$data.sample_type_id}">
                  <div class="form-group">
                        <label for="sampleTypeName" class="control-label col-md-4"><span class="red">*</span> 
                              {t}Nom :{/t}</label>
                        <div class="col-md-8">
                              <input id="sampleTypeName" type="text" class="form-control" name="sample_type_name"
                                    value="{$data.sample_type_name}" autofocus required>
                        </div>
                  </div>

                  <div class="form-group">
                        <label for="container_type_id" class="control-label col-md-4">{t}Type de contenant :{/t}</label>
                        <div class="col-md-8">
                              <select id="container_type_id" name="container_type_id" class="form-control">
                                    <option value="" {if $data.container_type_id=="" }selected{/if}>
                                          {t}Choisissez...{/t}
                                    </option>
                                    {section name=lst loop=$container_type}
                                    <option value="{$container_type[lst].container_type_id}" {if
                                          $container_type[lst].container_type_id==$data.container_type_id}selected{/if}>
                                          {$container_type[lst].container_type_name}
                                    </option>
                                    {/section}
                              </select>
                        </div>
                  </div>

                  <div class="form-group">
                        <label for="operation_id" class="control-label col-md-4">
                              {t}Protocole / opération :{/t}
                        </label>
                        <div class="col-md-8">
                              <select id="operation_id" name="operation_id" class="form-control">
                                    <option value="" {if $data.operation_id=="" }selected{/if}>
                                          {t}Choisissez...{/t}
                                    </option>
                                    {section name=lst loop=$operation}
                                    <option value="{$operation[lst].operation_id}" {if
                                          $operation[lst].operation_id==$data.operation_id}selected{/if}>
                                          {$operation[lst].protocol_year} {$operation[lst].protocol_name}
                                          {$operation[lst].protocol_version} {$operation[lst].operation_name}
                                          {$operation[lst].operation_version}
                                    </option>
                                    {/section}
                              </select>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="sampleTypeDescription" class="control-label col-md-4">
                              {t}Description :{/t}</label>
                        <div class="col-md-8">
                              <textarea class="form-control" rows="3" name="sample_type_description"
                                    id="sampleTypeDescription">{$data.sample_type_description}</textarea>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="metadata_id" class="control-label col-md-4">
                              {t}Modèle de métadonnées :{/t}
                        </label>
                        <div class="col-md-8">
                              <select id="metadata_id" name="metadata_id" class="form-control">
                                    <option value="" {if $data.metadata_id=="" }selected{/if}>
                                          {t}Choisissez...{/t}
                                    </option>
                                    {section name=lst loop=$metadata}
                                    <option value="{$metadata[lst].metadata_id}" {if
                                          $metadata[lst].metadata_id==$data.metadata_id}selected{/if}>
                                          {$metadata[lst].metadata_name}
                                    </option>
                                    {/section}
                              </select>
                        </div>
                  </div>

                  <fieldset>
                        <legend>{t}Sous-échantillonnage{/t}</legend>

                        <div class="form-group">
                              <label for="multiple_type_id" class="control-label col-md-4">
                                    {t}Nature :{/t}
                              </label>
                              <div class="col-md-8">
                                    <select id="multiple_type_id" name="multiple_type_id" class="form-control">
                                          <option value="" {if $data.multiple_type_id=="" }selected{/if}>
                                                {t}Choisissez...{/t}</option>
                                          {section name=lst loop=$multiple_type}
                                          <option value="{$multiple_type[lst].multiple_type_id}" {if
                                                $multiple_type[lst].multiple_type_id==$data.multiple_type_id}selected{/if}>
                                                {$multiple_type[lst].multiple_type_name}
                                          </option>
                                          {/section}
                                    </select>
                              </div>
                        </div>
                        <div class="form-group">
                              <label for="multiple_unit" class="control-label col-md-4">
                                    {t}Unité de base :{/t}
                              </label>
                              <div class="col-md-8">
                                    <input id="multiple_unit" type="text" class="form-control" name="multiple_unit"
                                          value="{$data.multiple_unit}" placeholder="{t}écaille, mètre, cm3...{/t}">
                              </div>
                        </div>

                        <div class="form-group">
                              <label for="identifier_generator_js" class="control-label col-md-4">
                                    {t}Code javascript de génération de l'identifiant :{/t}</label>
                              <div class="col-md-8">
                                    <input id="identifier_generator_js" type="text" class="form-control"
                                          name="identifier_generator_js" value="{$data.identifier_generator_js}"
                                          placeholder='$("#collection_id option:selected").text()+"-"+$("#uid").val()'>
                              </div>
                        </div>

                  </fieldset>

                  <div class="form-group center">
                        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                        {if $data.sample_type_id > 0 }
                        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                        {/if}
                  </div>
                  {$csrf}
            </form>
      </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>

<div class="row">
      <div class="col-md-12">
            <div class="bg-info">
                  {t}Consignes pour créer le code de génération de l'identifiant :{/t}
                  <ul>
                        <li>{t}il s'agit de code javascript/JQuery, qui doit tenir en une seule instruction{/t}</li>
                        <li>{t}l'opérateur de concaténation est le signe +{/t}
                        <li>{t}la syntaxe de JQuery est basée sur $("#id"), où #id correspond à l'objet recherché{/t}
                        <li>{t}la syntaxe varie en fonction du type de champ dont vous voulez récupérer la valeur :{/t}
                              <ul>
                                    <li>{t}pour les champs simples :{/t} $("#uid").val()</li>
                                    <li>{t}pour récupérer le contenu d'une boite de sélection :{/t} $("#collection_id option:selected").text()</li>
                                    <li>{t}pour récupérer le contenu d'une variable simple issue des métadonnées :{/t}
                                          $("input[name={t}nom_de_la_metadonnee{/t}]").val()</li>
                                    <li>
                                          {t}pour récupérer le contenu d'une métadonnée sélectionnée par bouton-radio :{/t}
                                           $("input[name={t}nom_de_la_metadonnee{/t}]:checked").val()
                                    </li>
                              </ul>
                        </li>
                        <li>{t}Exemple : pour générer cet identifiant : nom_collection-uid-valeur_metadonnee :{/t}
                              <ul>
                                    <li>
                                          $("#collection_id option:selected").text()+"-"+$("#uid").val()+"-"+$("input[name={t}espece{/t}]").val()
                                    </li>
                                    {t}(espece est le champ de métadonnées recherché){/t}
                              </ul>
                        </li>
                        <li>{t}Liste des champs utilisables :{/t}
                              <ul>
                                    <li>{t 1='uid'}%1 : identifiant interne{/t}</li>
                                    <li>{t 1='object_status_id'}%1 : statut de l'échantillon{/t}</li>
                                    <li>{t 1='collection_id'}%1 : nom de la collection{/t}</li>
                                    <li>{t 1='sample_type_id'}%1 : type d'échantillon{/t}</li>
                                    <li>{t 1='sample_creation_date'}%1 : date de création de l'échantillon{/t}</li>
                                    <li>{t 1='sampling_date'}%1 : date d'échantillonnage{/t}</li>
                                    <li>{t 1='expiration_date'}%1 : date d'expiration de l'échantillon{/t}</li>
                                    <li>{t 1='wgs84_x'}%1 : longitude{/t}</li>
                                    <li>{t 1='wgs84_y'}%1 : latitude{/t}</li>
                                    <li>{t}et les variables disponibles dans les champs de métadonnées{/t}</li>
                              </ul>
                        </li>

                  </ul>
            </div>
      </div>
</div>