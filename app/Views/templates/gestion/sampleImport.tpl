<script>
      $(document).ready(function () {
            var myStorage = window.localStorage;
            var defaults = {};
            try {
                  defaults = JSON.parse(myStorage.getItem("sampleImportParameters"));
                  Object.keys(defaults).forEach(key => {
                        $("#" + key).val(defaults[key]);
                  });
            } catch (Exception) {
            }
            $("#sampleStage1").submit(function () {
                  defaults = {
                        "separator": $("#separator").val(),
                        "encoding": $("#utf8_encode").val()
                  };
                  myStorage.setItem("massImportParameters", JSON.stringify(defaults));
            });
      });
</script>
<h2>{t}Import d'échantillons provenant d'une base externe à partir d'un fichier CSV{/t}</h2>

<div class="row col-md-6">
      <form class="form-horizontal" id="sampleStage1" method="post" action="sampleImportStage2"
            enctype="multipart/form-data">
            <div class="form-group">
                  <label for="upfile" class="control-label col-md-4"><span class="red">*</span>
                        {t}Nom du fichier à importer (CSV) :{/t}</label>
                  <div class="col-md-8">
                        <input type="file" name="upfile" required class="form-control">
                  </div>
            </div>
            <div class="form-group">
                  <label for="separator" class="control-label col-md-4">{t}Séparateur utilisé :{/t}</label>
                  <div class="col-md-8">
                        <select id="separator" name="separator" class="form-control">
                              <option value="," {if $separator=="," }selected{/if}>{t}Virgule{/t}</option>
                              <option value=";" {if $separator==";" }selected{/if}>{t}Point-virgule{/t}</option>
                              <option value="tab" {if $separator=="tab" }selected{/if}>{t}Tabulation{/t}</option>
                        </select>
                  </div>
            </div>
            <div class="form-group">
                  <label for="utf8_encode" class="control-label col-md-4">{t}Encodage du fichier :{/t}</label>
                  <div class="col-md-8">
                        <select id="utf8_encode" name="utf8_encode" class="form-control">
                              <option value="0" {if $utf8_encode==0}selected{/if}>UTF-8</option>
                              <option value="1" {if $utf8_encode==1}selected{/if}>ISO-8859-x</option>
                        </select>
                  </div>
            </div>
            <div class="form-group center">
                  <button type="submit" class="btn btn-primary">{t}Vérifier le fichier{/t}</button>
            </div>
            {$csrf}
      </form>


      <span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
</div>

{if $stage > 1}
<fieldset class="row col-md-12">
      <legend>{t}Tableau de correspondance entre les libellés fournis et ceux de la base de données locale{/t}</legend>
      <form class="form-horizontal " id="sampleStage2" method="post" action="sampleImportStage3"
            enctype="multipart/form-data">
            <input type="hidden" name="realfilename" value="{$realfilename}">
            <input type="hidden" name="separator" value="{$separator}">
            <input type="hidden" name="utf8_encode" value="{$utf8_encode}">
            <div class="form-group">
                  <label for="filename" class="control-label col-md-4">{t}Fichier en cours de traitement :{/t}</label>
                  <div class="col-md-8">
                        <input type="text" id="filename" class="form-control" readonly name="filename"
                              value="{$filename}">
                  </div>
            </div>
            {foreach $names as $kname=>$name}
            <fieldset>
                  <legend>{$kname}</legend>
                  {foreach $name as $val}
                  <div class="form-group">
                        <label for="{$kname}-{$val}" class="control-label col-md-4">{$val}</label>
                        <div class="col-md-8">
                              <select id="{$kname}-{$val}" name="{$kname}-{$val}" class="form-control">
                                    {foreach $dataClass[$kname] as $svalue}
                                    <option value="{$svalue[$kname]}" {if
                                          strtoupper($svalue[$kname])==strtoupper($val)}selected{/if}>{$svalue[$kname]}
                                    </option>
                                    {/foreach}
                              </select>
                        </div>
                  </div>
                  {/foreach}
            </fieldset>
            {/foreach}
            <div class="form-group center">
                  <button type="submit" class="btn btn-danger">{t}Déclencher l'import{/t}</button>
            </div>
            {$csrf}
      </form>
</fieldset>
{/if}

<div class="row">
      <div class="col-sm-12">
            <div class="bg-info">
                  {t}Ce module permet, à partir d'un fichier CSV :{/t}
                  <br>
                  <ul>
                        <li>{t}d'importer des échantillons provenant d'une base externe{/t}</li>
                        <li>{t}de mettre à jour des échantillons qui ont été modifiés avec une application tierce (LibreOffice, par exemple). Voici les opérations à réaliser pour cette opération :{/t}
                              <ul>
                                    <li>{t}depuis le module de recherche des échantillons, sélectionnez ceux à modifier{/t}</li>
                                    <li>{t}générez le fichier CSV à partir du bouton [Export vers une autre base]{/t}
                                    </li>
                                    <li>{t}modifiez les informations à partir d'un tableur (privilégiez LibreOffice plutôt que Excel){/t}</li>
                                    <li>{t}réimportez le fichier modifié à partir de ce module{/t}</li>
                              </ul>
                        </li>
                  </ul>
                  <br>
                  {t}Si l'échantillon existe, il est mis à jour, sinon il est créé. La recherche des échantillons s'effectue selon l'ordre suivant :{/t}
                  <br>
                  <ul>
                        <li>UUID: {t}identifiant normalisé unique au niveau mondial{/t}</li>
                        <li>dbuid_origin: {t}identifiant d'origine de l'échantillon (il est généré automatiquement pendant l'opération d'exportation){/t}</li>
                  </ul>
                  {t}Liste des colonnes possibles :{/t}
                  <br>
                  <ul>
                        <li><b>dbuid_origin*</b> : {t escape=no}identifiant <b>unique</b> dans la base de données d'origine, sous la forme : code_base:id{/t}</li>
                        <li><b>identifier</b> : {t}identifiant métier{/t}</li>
                        <li><b>uuid</b> : {t}UUID, code normalisé et unique au niveau mondial (généré avec des processus cryptographiques){/t}</li>
                        <li><b>sample_type_name*</b> : {t}type d'échantillon{/t}</li>
                        <li><b>collection_name*</b> : {t}nom de la collection de rattachement{/t}</li>
                        <li><b>object_status_name</b> : {t}statut courant{/t}</li>
                        <li><b>referent_name</b> : {t}nom du référent{/t}</li>
                        <li><b>wgs84_x</b> : {t}longitude GPS en WGS84 (degrés décimaux){/t}</li>
                        <li><b>wgs84_y</b> : {t}latitude GPS en WGS84 (degrés décimaux){/t}</li>
                        <li><b>location_accuracy</b> : {t}Précision (en mètres) de la localisation de l'échantillon{/t}
                        </li>
                        <li><b>sample_creation_date</b> : {t 1="YYYY-MM-DD HH:MM:SS"}date de création de l'échantillon dans la base de données d'origine, sous la forme %1{/t}</li>
                        <li><b>sampling_date</b> : {t 1="YYYY-MM-DD HH:MM:SS"}date de référence de l'échantillon dans la base de données d'origine, sous la forme %1{/t}</li>
                        <li><b>expiration_date</b> : {t}date d'expiration ou de fin de validité de l'échantillon{/t}
                        </li>
                        <li><b>multiple_value</b> : {t}nombre ou quantité de sous-échantillons disponibles{/t}</li>
                        <li><b>campaign_name</b> : {t}nom de la campagne de prélèvement{/t}</li>
                        <li><b>sampling_place_name</b> : {t}lieu de prélèvement de l'échantillon{/t}</li>
                        <li><b>country_code</b> : {t}code du pays, sur deux caractères{/t}</li>
                        <li><b>comment</b> : {t}Commentaire sur l'échantillon{/t}</li>
                        <li><b>metadata</b> : {t}liste des métadonnées associées, au format JSON. Il est également possible de définir des métadonnées au format texte, en respectant les règles suivantes :{/t}
                              <ul>
                                    <li>{t}un champ par métadonnée{/t}</li>
                                    <li>{t escape=no}chaque champ doit être préfixé par <b>md_</b> pour pouvoir être reconnu comme tel par le logiciel{/t}</li>
                                    <li>{t escape=no}le champ ne doit pas être présent dans la colonne <i>metadata</i>{/t}
                              </ul>
                        </li>
                        <li><b>identifiers</b> : {t}liste des identifiants secondaires, sous la forme :{/t}
                              code1:val1,code2:val2</li>
                        <li><b>dbuid_parent</b> : {t escape=no}dans le cas d'un échantillon dérivé, identifiant du parent sous la forme code_base:identifiant. Cette valeur correspond à la valeur <i>dbuid_origin</i> de l'échantillon parent.{/t}
                              {t}Ce dernier doit avoir été importé préalablement pour que la relation puisse être créée{/t}
                        </li>
                  </ul>
                  {t}Les champs obligatoires sont signalés par une étoile (*).{/t}
            </div>
      </div>
</div>