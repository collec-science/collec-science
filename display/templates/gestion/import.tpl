{* Objet > Import de masse > *}
<h2>{t}Import d'échantillons ou de contenants à partir d'un fichier CSV{/t}</h2>
<!-- Lancement de l'import -->
{if $controleOk == 1}
<div class="row col-md-8">
      <form id="importForm" method="post" action="index.php">
            <input type="hidden" name="module" value="importImport">
            <input type="hidden" name="onlyCollectionSearch" value="{$onlyCollectionSearch}">
            {t}Contrôles OK.{/t} {t 1=$filename}Vous pouvez réaliser l'import du fichier (%1) :{/t}
            <button type="submit" class="btn btn-danger">{t}Déclencher l'import{/t}</button>
      </form>
</div>
{/if}

<!-- Affichage des erreurs decouvertes -->
{if $erreur == 1}
<div class="row col-md-12">
      <table id="containerList" class="table table-bordered table-hover datatable ">
            <thead>
                  <tr>
                        <th>{t}N° de ligne{/t}</th>
                        <th>{t}Anomalie(s) détectée(s){/t}</th>
                  </tr>
            </thead>
            <tbody>
                  {section name=lst loop=$erreurs}
                  <tr>
                        <td class="center">{$erreurs[lst].line}</td>
                        <td>{$erreurs[lst].message}</td>
                  </tr>
                  {/section}
            </tbody>
      </table>
</div>
{/if}

<!-- Selection du fichier a importer -->
<div class="row">
      <div class="col-md-6">
            <form class="form-horizontal protoform" id="controlForm" method="post" action="index.php"
                  enctype="multipart/form-data">
                  <input type="hidden" name="module" value="importControl">
                  <div class="form-group">
                        <label for="upfile" class="control-label col-md-4"><span class="red">*</span> {t}Nom du fichier
                              à importer (CSV) :{/t}</label>
                        <div class="col-md-8">
                              <input type="file" name="upfile" required>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="separator" class="control-label col-md-4">{t}Séparateur utilisé :{/t}</label>
                        <div class="col-md-8">
                              <select id="separator" name="separator">
                                    <option value="," {if $separator=="," }selected{/if}>{t}Virgule{/t}</option>
                                    <option value=";" {if $separator==";" }selected{/if}>{t}Point-virgule{/t}</option>
                                    <option value="tab" {if $separator=="tab" }selected{/if}>{t}Tabulation{/t}</option>
                              </select>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="utf8_encode" class="control-label col-md-4">{t}Encodage du fichier :{/t}</label>
                        <div class="col-md-8">
                              <select id="utf8_encode" name="utf8_encode">
                                    <option value="0" {if $utf8_encode==0}selected{/if}>UTF-8</option>
                                    <option value="1" {if $utf8_encode==1}selected{/if}>ISO-8859-x</option>
                              </select>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="onlyCollectionSearch" class="control-label col-md-4">{t}Rechercher les échantillons parents uniquement dans la collection des enfants :{/t}</label>
                        <div class="col-md-8">
                              <select id="onlyCollectionSearch" name="onlyCollectionSearch">
                                    <option value="0" {if $onlyCollectionSearch==0}selected{/if}>{t}non{/t}</option>
                                    <option value="1" {if $onlyCollectionSearch==1}selected{/if}>{t}oui{/t}</option>
                              </select>
                        </div>
                  </div>
                  <div class="form-group center">
                        <button type="submit" class="btn btn-primary">{t}Vérifier le fichier{/t}</button>
                  </div>
            </form>
      </div>
</div>
<div class="row">
<div class="col-md-6">
<div class="bg-info">
{t}Ce module permet d'importer des échantillons ou des contenants, et de créer le cas échéant les mouvements d'entrée.{/t}
<br>
{t}Il n'accepte que des fichiers au format CSV. La ligne d'entête doit comprendre exclusivement les colonnes suivantes :{/t}
<br>
<ul>
      <li>{t}Pour importer des contenants :{/t}
            <ul>
                  <li><b>container_identifier</b> : {t}l'identifiant du contenant (obligatoire){/t}</li>
                  <li><b>container_type_id / container_type_name</b> : {t}le numéro informatique du type de contenant ou son nom (obligatoire){/t}</li>
                  <li><b>container_status_id / container_status_name</b> : {t}le numéro informatique du statut du contenant ou son nom (obligatoire){/t}</li>
                  <li><b>container_uuid</b> : {t}UID Universel du contenant (UUID){/t}</li>
                  <li><b>container_comment</b> : {t}Commentaire libre sur le contenant{/t}</li>
                  <li><b>container_location</b> : {t}l'emplacement de rangement du contenant dans son contenant (texte libre){/t}</li>
                  <li><b>container_column</b> : {t}n° de la colonne de stockage dans le contenant{/t}</li>
                  <li><b>container_line</b> : {t}n° de la ligne de stockage dans le contenant{/t}</li>
                  <li><b>container_parent_uid</b> : {t}l'UID du contenant où le contenant courant est rangé{/t}</li>
                  <li><b>container_parent_identifier</b> : {t}identifiant métier du contenant où le contenant courant est rangé (doit être créé préalablement, ou figurer plus haut dans le fichier - l'identifiant doit être unique){/t}</li>
            </ul>
      </li>
      <li>{t}Pour importer des échantillons :{/t}
            <ul>
                  <li><b>sample_identifier</b> : {t}l'identifiant de l'échantillon (obligatoire){/t}</li>
                  <li><b>collection_id / collection_name</b> : {t}le numéro informatique de la collection ou son nom (obligatoire){/t}</li>
                  <li><b>sample_type_id / sample_type_name</b> : {t}le numéro informatique du type d'échantillon ou son nom (obligatoire){/t}</li>
                  <li><b>sample_status_id / sample_status_name</b> : {t}le numéro du statut de l'échantillon ou son nom(obligatoire){/t}</li>
                  <li><b>campaign_id / campaign_name / campaign_uuid</b> : {t}le numéro informatique de la campagne de prélèvement, son nom ou son UUID{/t}</li>
                  <li><b>sampling_place_id / sampling_place_name</b> : {t}le numéro informatique de l'endroit où l'échantillon a été prélevé ou son nom{/t}</li>
                  <li><b>country_code</b>: {t}le code du pays de collecte, sur deux positions{/t}</li>
                  <li><b>country_origin_code</b>: {t}le code du pays de provenance, sur deux positions{/t}</li>
                  <li><b>referent_id / referent_name</b> : {t}le numéro informatique du référent ou son nom, sous la forme "nom prénom"{/t}</li>
                  <li><b>wgs84_x</b> : {t}la longitude GPS en WGS84 (degrés décimaux, séparateur décimal : point){/t}</li>
                  <li><b>wgs84_y</b> : {t}la latitude GPS en WGS84 (degrés décimaux, séparateur décimal : point){/t}</li>
                  <li><b>sampling_date</b> : {t}la date de création/échantillonnage de l'échantillon, au format dd/mm/yyyy{/t}</li>
                  <li><b>expiration_date</b> : {t}la date d'expiration de l'échantillon, au format dd/mm/yyyy{/t}</li>
                  <li><b>sample_multiple_value</b> : {t}le nombre total de sous-échantillons (ou le volume total, ou le pourcentage...) contenu dans l'échantillon
                  si le type d'échantillons utilisé le permet (valeur numérique, séparateur décimal : point){/t}</li>
                  <li><b>sample_comment</b> : {t}Commentaire libre sur l'échantillon{/t}</li>
                  <li><b>sample_parent_uid</b> : {t}UID du parent (création d'échantillons rattachés){/t}</li>
                  <li><b>sample_parent_identifier</b> : {t}identifiant métier du parent (doit être créé avant l'échantillon courant ou figurer plus haut dans le fichier, et l'identifiant doit être unique){/t}</li>
                  <li><b>dbuid_origin</b> : {t}Identifiant technique dans la base de données d'origine (de préférence sous la forme : nom_base:id){/t}</li>
                  <li><b>sample_uuid</b> :  {t}UID Universel de l'échantillon (UUID){/t}</li>
                  <li><b>container_parent_uid</b> : {t}l'UID du contenant où l'échantillon ou le contenant est rangé{/t}</li>
                  <li><b>container_parent_identifier</b> : {t}identifiant métier du contenant où l'échantillon est rangé (doit être créé préalablement, ou figurer plus haut dans le fichier - l'identifiant doit être unique){/t}</li>
                  <li><b>sample_location</b> : {t}l'emplacement de rangement de l'échantillon dans le contenant (texte libre){/t}</li>
                  <li><b>sample_column</b> : {t}n° de la colonne de stockage dans le contenant{/t}</li>
                  <li><b>sample_line</b> : {t}n° de la ligne de stockage dans le contenant{/t}</li>
                  <li>
                        <b>sample_metadata_json</b> : {t escape=no}les métadonnées rattachées à l'échantillon (au format json, p. e. : &#123;"taxon":"Alosa alosa"&#125;){/t}
                        <ul>
                              <li>{t}il est également possible de définir les métadonnées avec un attribut par colonne. Dans ce cas, la colonne doit être nommée md_nomAttribut, par exemple : md_taxon. La valeur de la colonne md_xxx écrasera celle de l’attribut xxx présent dans la colonne sample_metadata_json{/t}
                              <li>{t escape=no}Dans le cas de multi-valeurs, celles-ci doivent être séparées par une virgule dans la colonne md_ (exemple : valeur1,valeur2), et entourées de crochets dans la colonne sample_metadata_json (exemple : &#123;"valeurs":&#91;valeur1,valeur2&#93;&#125;){/t}</li>
                        </ul>
                  </li>
            </ul>
      </li>
</ul>
<ul>


</ul>
{t escape=no}Les codes informatiques peuvent être consultés à partir du menu <i>Paramètres</i>.{/t}
<br>

<br>
{t}Pour les identifiants complémentaires :{/t}
<ul>
      <li>{t}repérez les codes dans le menu des paramètres > Types d'identifiants{/t}</li>
      <li>{t}vous ne pouvez indiquer qu'un code par ligne (mais plusieurs types de codes possibles){/t}</li>
      <li>{t}ils seront associés à l'échantillon et au contenant, si les deux sont indiqués dans la même ligne{/t}</li>
</ul>
<br>
{t}L'import sera réalisé ainsi :{/t}
<ol>
      <li>{t escape=no}si <i>sample_identifier</i> est renseigné : création de l'échantillon{/t}</li>
      <li>{t escape=no}si <i>container_identifier</i> est renseigné : création du contenant{/t}</li>
      <li>{t escape=no}si <i>container_identifier</i> et <i>container_parent_uid</i> sont renseignés : création du mouvement d'entrée du contenant{/t}</li>
      <li>{t}si l'échantillon et le contenant ont été créés, création du mouvement d'entrée de l'échantillon dans le
            contenant{/t}</li>
      <li>{t escape=no}si l'échantillon est créé, que <i>container_parent_uid</i> est renseigné, et que <i>container_identifier</i> n'est pas rempli, création du mouvement d'entrée de l'échantillon dans le contenant indiqué{/t}</li>
</ol>
</div>
</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
