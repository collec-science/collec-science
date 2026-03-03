<h2>{t}Création - Modification d'un type de contenant{/t}</h2>
<div class="row">
      <div class="col-md-6">
            <a href="containerTypeList">{t}Retour à la liste{/t}</a>

            <form class="form-horizontal " id="containerTypeForm" method="post" action="containerTypeWrite">
                  <input type="hidden" name="container_type_id" value="{$data.container_type_id}">
                  <input type="hidden" name="moduleBase" value="containerType">
                  <div class="form-group">
                        <label for="containerTypeName" class="control-label col-md-4"><span class="red">*</span> 
                              {t}Nom :{/t}
                        </label>
                        <div class="col-md-8">
                              <input id="containerTypeName" type="text" class="form-control" name="container_type_name"
                                    value="{$data.container_type_name}" autofocus required>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="container_family_id" class="control-label col-md-4"><span class="red">*</span>
                              {t}Famille :{/t}</label>
                        <div class="col-md-8">
                              <select id="container_family_id" name="container_family_id" class="form-control">
                                    {section name=lst loop=$containerFamily}
                                    <option value="{$containerFamily[lst].container_family_id}" {if
                                          $containerFamily[lst].container_family_id==$data.container_family_id}selected{/if}>
                                          {$containerFamily[lst].container_family_name}
                                    </option>
                                    {/section}
                              </select>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="containerTypeDescription" class="control-label col-md-4">{t}Description
                              :{/t}</label>
                        <div class="col-md-8">
                              <textarea class="form-control" rows="3" name="container_type_description"
                                    id="containerTypeDescription">{$data.container_type_description}</textarea>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="lines" class="control-label col-md-4">
                              {t}Nombre de lignes :{/t}
                        </label>
                        <div class="col-md-8">
                              <input id="lines" name="lines" value="{$data.lines}" class="nombre form-control">
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="columns" class="control-label col-md-4">
                              {t}Nombre de colonnes :{/t}
                        </label>
                        <div class="col-md-8">
                              <input id="columns" name="columns" value="{$data.columns}" class="nombre form-control">
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="columns" class="control-label col-md-4">
                              {t}Position de la première ligne :{/t}
                        </label>
                        <div class="col-md-8">
                              <div class="radio">
                                    <label>
                                          <input type="radio" name="first_line" id="first_line_t" value="T" {if
                                                $data.first_line=="T" }checked{/if}>
                                          {t}En haut{/t}
                                    </label>
                                    <label>
                                          <input type="radio" name="first_line" id="first_line_b" value="B" {if
                                                $data.first_line=="B" }checked{/if}>
                                          {t}En bas{/t}
                                    </label>
                              </div>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="columns" class="control-label col-md-4">
                              {t}Position de la première colonne :{/t}
                        </label>
                        <div class="col-md-8">
                              <div class="radio">
                                    <label>
                                          <input type="radio" name="first_column" id="first_column_l" value="L" {if
                                                $data.first_column=="L" }checked{/if}>
                                          {t}À gauche{/t}
                                    </label>
                                    <label>
                                          <input type="radio" name="first_column" id="first_column_r" value="R" {if
                                                $data.first_column=="R" }checked{/if}>
                                          {t}À droite{/t}
                                    </label>
                              </div>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="line_in_char" class="control-label col-md-4">
                              {t}Lignes identifiées par une lettre ?{/t}
                        </label>
                        <div class="col-md-8">
                              <div class="radio">
                                    <label>
                                          <input type="radio" name="line_in_char" id="line_in_char1" value="1" {if
                                                $data.line_in_char=="t" }checked{/if}>
                                          {t}oui{/t}
                                    </label>
                                    <label>
                                          <input type="radio" name="line_in_char" id="line_in_char0" value="0" {if
                                                $data.line_in_char !="t" }checked{/if}>
                                          {t}non{/t}
                                    </label>
                              </div>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="line_in_char" class="control-label col-md-4">
                              {t}Colonnes identifiées par une lettre ?{/t}
                        </label>
                        <div class="col-md-8">
                              <div class="radio">
                                    <label>
                                          <input type="radio" name="column_in_char" id="column_in_char1" value="1" {if
                                                $data.column_in_char=="t" }checked{/if}>
                                          {t}oui{/t}
                                    </label>
                                    <label>
                                          <input type="radio" name="column_in_char" id="column_in_char0" value="0" {if
                                                $data.column_in_char !="t" }checked{/if}>
                                          {t}non{/t}
                                    </label>
                              </div>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="nb_slots_max" class="control-label col-md-4">
                              {t}Nombre d'emplacements maximum :{/t}
                        </label>
                        <div class="col-md-8">
                              <input id="nb_slots_max" name="nb_slots_max" value="{$data.nb_slots_max}"
                                    class="nombre form-control">
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="nbobject_by_slot" class="control-label col-md-4">
                              {t}Nombre maxi d'objets par emplacement (ligne/colonne) :{/t}
                        </label>
                        <div class="col-md-8">
                              <input id="nbobject_by_slot" name="nbobject_by_slot" value="{$data.nbobject_by_slot}"
                                    class="nombre form-control">
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="storageConditionId" class="control-label col-md-4">
                              {t}Condition de stockage :{/t}
                        </label>
                        <div class="col-md-8">
                              <select id="storageConditionId" name="storage_condition_id" class="form-control">
                                    <option value="" {if $data.storage_condition_id=="" }selected{/if}>
                                          {t}Choisissez...{/t}
                                    </option>
                                    {section name=lst loop=$storageCondition}
                                    <option value="{$storageCondition[lst].storage_condition_id}" {if
                                          $storageCondition[lst].storage_condition_id==$data.storage_condition_id}selected{/if}>
                                          {$storageCondition[lst].storage_condition_name}
                                    </option>
                                    {/section}
                              </select>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="product_id" class="control-label col-md-4">
                              {t}Produit utilisé :{/t}
                        </label>
                        <div class="col-md-8">
                              <select class="form-control" id="product_id" name="product_id">
                                    <option value="" {if $data.product_id=="" }selected{/if}>
                                          {t}Choisissez...{/t}
                                    </option>
                                    {foreach $products as $product}
                                    <option value="{$product.product_id}" {if
                                          $product.product_id==$data.product_id}selected{/if}>
                                          {$product.product_name}
                                    </option>
                                    {/foreach}
                              </select>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="productNew" class="control-label col-md-4">
                              {t}ou nouveau produit :{/t}
                        </label>
                        <div class="col-md-8">
                              <input id="productNew" type="text" class="form-control" name="productNew">
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="risk_id" class="control-label col-md-4">
                              {t}Risque (code CLP) :{/t}
                        </label>
                        <div class="col-md-8">
                              <select class="form-control" id="risk_id" name="risk_id">
                                    <option value="" {if $data.risk_id=="" }selected{/if}>
                                          {t}Choisissez...{/t}
                                    </option>
                                    {foreach $risks as $risk}
                                    <option value="{$risk.risk_id}" {if $risk.risk_id==$data.risk_id}selected{/if}>
                                          {$risk.risk_name}
                                    </option>
                                    {/foreach}
                              </select>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="riskNew" class="control-label col-md-4">
                              {t}ou nouveau risque :{/t}</label>
                        <div class="col-md-8">
                              <input id="riskNew" type="text" class="form-control" name="riskNew">
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="labelId" class="control-label col-md-4">
                              {t}Modèle d'étiquette :{/t}
                        </label>
                        <div class="col-md-8">
                              <select id="labelId" name="label_id" class="form-control">
                                    <option value="" {if $data.label_id=="" }selected{/if}>
                                          {t}Choisissez...{/t}
                                    </option>
                                    {section name=lst loop=$labels}
                                    <option value="{$labels[lst].label_id}" {if
                                          $labels[lst].label_id==$data.label_id}selected{/if}>
                                          {$labels[lst].label_name}
                                    </option>
                                    {/section}
                              </select>
                        </div>
                  </div>
                  <div class="form-group center">
                        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                        {if $data.container_type_id > 0 }
                        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                        {/if}
                  </div>
                  {$csrf}
            </form>
      </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>