{* Paramètres > Collections > Nouveau *}
<h2>{t}Création - Modification d'une collection{/t}</h2>
<div class="row">
      <div class="col-md-6">
            <a href="index.php?module=collectionList">{t}Retour à la liste{/t}</a>

            <form class="form-horizontal protoform" id="collectionForm" method="post" action="index.php">
                  <input type="hidden" name="moduleBase" value="collection">
                  <input type="hidden" name="action" value="Write">
                  <input type="hidden" name="collection_id" value="{$data.collection_id}">
                  <div class="form-group">
                        <label for="collectionName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
                        <div class="col-md-8">
                              <input id="collectionName" type="text" class="form-control" name="collection_name" value="{$data.collection_name}" autofocus required>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="collectionDisplayname"  class="control-label col-md-4"> {t}Nom public, communiqué à l'extérieur :{/t}</label>
                        <div class="col-md-8">
                              <input id="collectionDisplayname" type="text" class="form-control" name="collection_displayname" value="{$data.collection_displayname}" >
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="collectionDisplayname"  class="control-label col-md-4"> {t}Mots clés, séparés par une virgule :{/t}</label>
                        <div class="col-md-8">
                              <input id="collectionKeywords" type="text" class="form-control" name="collection_keywords" value="{$data.collection_keywords}" >
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="referentId"  class="control-label col-md-4">{t}Référent de la collection :{/t}</label>
                        <div class="col-md-8">
                              <select id="referentId" name="referent_id" class="form-control">
                                    <option value="" {if $data.referent_id == ""}selected{/if}>Choisissez...</option>
                                    {foreach $referents as $referent}
                                          <option value="{$referent.referent_id}" {if $data.referent_id == $referent.referent_id}selected{/if}>
                                          {$referent.referent_name}
                                          </option>
                                    {/foreach}
                              </select>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="columns"  class="control-label col-md-4">{t}Flux de modification entrants autorisés :{/t}</label>
                        <div class="col-md-8">
                              <div class="radio">
                                    <label>
                                          <input type="radio" name="allowed_import_flow" id="aif_1" value="0" {if $data.allowed_import_flow == 0}checked{/if}>
                                          {t}non{/t}
                                    </label>
                                    <label>
                                          <input type="radio" name="allowed_import_flow" id="aif_2" value="1" {if $data.allowed_import_flow == 1}checked{/if}>
                                          {t}oui{/t}
                                    </label>
                              </div>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="allowed_export_flow"  class="control-label col-md-4">{t}Flux d'interrogation externes autorisés :{/t}</label>
                        <div class="col-md-8">
                              <div class="radio" id="allowed_export_flow">
                                    <label>
                                          <input type="radio" name="allowed_export_flow" id="aef_1" value="0" {if $data.allowed_export_flow == 0}checked{/if}>
                                          {t}non{/t}
                                    </label>
                                    <label>
                                          <input type="radio" name="allowed_export_flow" id="aef_2" value="1" {if $data.allowed_export_flow == 1}checked{/if}>
                                          {t}oui{/t}
                                    </label>
                              </div>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="public_collection"  class="control-label col-md-4">{t}Collection publique ?{/t}</label>
                        <div class="col-md-8">
                              <div class="radio" id="public_collection">
                                    <label>
                                          <input type="radio" name="public_collection" id="pub1" value="0" {if $data.public_collection == 0}checked{/if}>
                                          {t}non{/t}
                                    </label>
                                    <label>
                                          <input type="radio" name="public_collection" id="pub2" value="1" {if $data.public_collection == 1}checked{/if}>
                                          {t}oui{/t}
                                    </label>
                              </div>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="license_id" class="control-label col-md-4">{t}Licence de diffusion :{/t}</label>
                        <div class="col-md-8">
                              <select id="license_id" name="license_id" class="form-control">
                                    <option value="" {if $data.license_id == ""}selected{/if}>{t}Choisissez...{/t}</option>
                                    {foreach $licenses as $license}
                                    <option value="{$license.license_id}" {if $data.license_id == $license.license_id}selected{/if}>{$license.license_name} ({$license.license_url})</option>
                                    {/foreach}
                              </select>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="no_localization"  class="control-label col-md-4">{t}Collection sans gestion de la localisation des échantillons ?{/t}</label>
                        <div class="col-md-8">
                              <div class="radio">
                                    <label>
                                          <input type="radio" name="no_localization" id="no_localization1" value="1" {if $data.no_localization == "1"}checked{/if}>
                                          {t}oui{/t}
                                    </label>
                                    <label>
                                          <input type="radio" name="no_localization" id="no_localization0" value="0" {if $data.no_localization == 0}checked{/if}>
                                          {t}non{/t}
                                    </label>
                              </div>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="external_storage_enabled"  class="control-label col-md-4">{t}Le stockage de documents attachés aux échantillons est-il possible hors base de données ?{/t}</label>
                        <div class="col-md-8">
                              <div class="radio">
                                    <label>
                                          <input type="radio" name="external_storage_enabled" id="external_storage_enabled1" value="1" {if $data.external_storage_enabled == "1"}checked{/if}>
                                          {t}oui{/t}
                                    </label>
                                    <label>
                                          <input type="radio" name="external_storage_enabled" id="external_storage_enabled0" value="0" {if $data.external_storage_enabled == 0}checked{/if}>
                                          {t}non{/t}
                                    </label>
                              </div>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="external_storage_root"  class="control-label col-md-4"> {t}Chemin d'accès aux fichiers externes :{/t}</label>
                        <div class="col-md-8">
                              <input id="external_storage_root" type="text" class="form-control" name="external_storage_root" value="{$data.external_storage_root}" >
                        </div>
                  </div>

                  <div class="form-group">
                        <label for="groupes"  class="control-label col-md-4">{t}Groupes :{/t}</label>
                        <div class="col-md-7">
                              {section name=lst loop=$groupes}
                                    <div class="col-md-2 col-sm-offset-3">
                                          <div class="checkbox">
                                                <label>
                                                      <input type="checkbox" name="groupes[]" value="{$groupes[lst].aclgroup_id}" {if $groupes[lst].checked == 1}checked{/if}>
                                                {$groupes[lst].groupe}
                                                </label>
                                          </div>
                                    </div>
                              {/section}
                        </div>
                  </div>

                  <div class="form-group center">
                        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                        {if $data.collection_id > 0 }
                              <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                        {/if}
                  </div>
            </form>
      </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
