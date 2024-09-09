<script>
      $(document).ready(function() {
            var lon = "{$data.sampling_place_x}";
            var lat = "{$data.sampling_place_y}";
            if (lon.length > 0 && lat.length > 0){
                  setPosition(lat, lon);
            }
      });
</script>
<h2>{t}Création - Modification d'un lieu de prélèvement{/t}</h2>
<div class="row">
      <div class="col-md-6">
            <a href="samplingPlaceList">{t}Retour à la liste{/t}</a>

            <form class="form-horizontal " id="samplingPlaceForm" method="post" action="samplingPlaceWrite">
                  <input type="hidden" name="moduleBase" value="samplingPlace">
                  <input type="hidden" name="sampling_place_id" value="{$data.sampling_place_id}">
                  <div class="form-group">
                        <label for="samplingPlaceName" class="control-label col-md-4"><span class="red">*</span> {t}Nom
                              :{/t}</label>
                        <div class="col-md-8">
                              <input id="samplingPlaceName" type="text" class="form-control" name="sampling_place_name"
                                    value="{$data.sampling_place_name}" autofocus required>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="samplingPlaceCode" class="control-label col-md-4">{t}Code métier :{/t}</label>
                        <div class="col-md-8">
                              <input id="samplingPlaceCode" type="text" class="form-control" name="sampling_place_code"
                                    value="{$data.sampling_place_code}">
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="collection_id" class="control-label col-md-4">{t}Collection de rattachement
                              :{/t}</label>
                        <div class="col-md-8">
                              <select id="collection_id" name="collection_id" class="form-control">
                                    <option value="" {if $data["collection_id"]=="" } selected{/if}>{t}Choisissez...{/t}
                                    </option>
                                    {foreach $collections as $collection}
                                    <option value="{$collection.collection_id}" {if
                                          $collection.collection_id==$data.collection_id} selected {/if}>
                                          {$collection.collection_name}
                                    </option>
                                    {/foreach}
                              </select>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="wgs84_x" class="control-label col-md-4">{t}Longitude :{/t}</label>
                        <div class="col-md-8">
                              <input id="wgs84_x" type="text" class="form-control" name="sampling_place_x"
                                    value="{$data.sampling_place_x}">
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="wgs84_y" class="control-label col-md-4">{t}Latitude :{/t}</label>
                        <div class="col-md-8">
                              <input id="wgs84_y" type="text" class="form-control" name="sampling_place_y"
                                    value="{$data.sampling_place_y}">
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="country_id" class="control-label col-md-4">{t}Pays :{/t}</label>
                        <div class="col-md-8">
                              <select id="country_id" name="country_id" class="form-control">
                                    <option value="" {if $data["country_id"]=="" } selected{/if}>{t}Choisissez...{/t}
                                    </option>
                                    {foreach $countries as $country}
                                    <option value="{$country.country_id}" {if $country.country_id==$data.country_id}
                                          selected {/if}>
                                          {$country.country_name}
                                    </option>
                                    {/foreach}
                              </select>
                        </div>
                  </div>

                  <div class="form-group center">
                        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                        {if $data.sampling_place_id > 0 }
                        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                        {/if}
                  </div>
                  {$csrf}
            </form>
      </div>
      <div class="col-md-6 geographic">
            {include file="gestion/objectMapDisplay.tpl"}
      </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
