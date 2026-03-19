<script>
    $(document).ready(function () {
        $("#containerEnable").change( function() {
            if ($(this).is(':checked') ){
                $(".containers").prop("disabled",false);
            } else {
                $(".containers").prop("disabled",true);
            }
            setSubmit();
        });
        $("#sampleEnable").change( function() {
            if ($(this).is(':checked') ){
                $(".samples").prop("disabled",false);
            } else {
                $(".samples").prop("disabled",true);
            }
            setSubmit();
        });
        function getSampletype() {
			var collection_id = $("#sampleCollection").val();
            if (collection_id > 0) {
                $.ajax({
				url: "sampleTypeGetListAjax",
				data: { "collection_id": collection_id }
                })
                .done(function (value) {
                    d = JSON.parse(value);
                    var options = '';
                    for (var i = 0; i < d.length; i++) {
                        options += '<option value="' + d[i].sample_type_id + '"';
                        options += '>' + d[i].sample_type_name;
                        options += '</option>';
                    };
                    $("#sampleTypes").html(options);
                });
            }
			
		}
        function getSamplingPlace() {
			/*
			 * Recuperation de la liste des lieux de prelevement rattaches a la collection
			 */
			var colid = $("#sampleCollection").val();
			var url = "samplingPlaceGetFromCollection";
			var data = { "collection_id": colid };
			$.ajax({ url: url, data: data })
				.done(function (d) {
					if (d) {
						d = JSON.parse(d);
						options = '<option value="" selected></option>';
						for (var i = 0; i < d.length; i++) {
							options += '<option value="' + d[i].sampling_place_name + '">';
                            options += d[i].sampling_place_name;
							options += '</option>';
						};
						$("#samplingPlace").html(options);
					}
				});
		}
        function setSubmit() {
            /**
             * Activation/désactivation du bouton
             */
            if ($("#containerEnable").is(":checked") || $("#sampleEnable").is(":checked")) {
                $("#submit").attr("disabled", false);
            } else {
                $("#submit").attr("disabled", true);
            }
        }
        $("#sampleCollection").change(function() {
            getSampletype();
            getSamplingPlace();
        });
        /**
         * Settings
         */
        $(".containers").attr("disabled", true);
        $(".samples").attr("disabled", true);
        getSampletype(); 
        getSamplingPlace();
        setSubmit();
    });
</script>
<h2>{t}Générer un modèle d'import de masse{/t}</h2>

<div class="row">
    <div class="col-lg-6">
        <form class="form-horizontal" id="template" action="importTemplateGenerate" method="post">
            <fieldset id="containersFieldset">
                <legend>
                    {t}Importer des contenants : {/t}
                    <input type="checkbox" id="containerEnable" name="containerEnable" value="1">
                </legend>
                 <div class="form-group">
                    <label for="containerCollection" class="col-md-4 control-label">
                        {t}Collection de destination :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="containerCollection" name="containerCollection" class="form-control containers">
                            <option value="" selected></option>
                            {foreach $collections as $collection}
                            <option value="{$collection.collection_name}">
                                {$collection.collection_name}
                            </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="containerFields" class="col-md-4 control-label">
                        {t}Colonnes complémentaires à ajouter :{/t}
                    </label>
                    <div class="col-md-8">
                        <table class="col-md-11">
                            <tr>
                                <td>{t}Rangement du contenant dans un autre contenant :{/t}</td>
                                <td class="center"><input type="checkbox" class="containers form-control" name="containerFields[]" value="containerLocation" ></td>
                            </tr>
                            <tr>
                                <td>{t}UUID connu :{/t}</td>
                                <td class="center"><input type="checkbox" class="containers form-control" name="containerFields[]" value="containerUuid" ></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </fieldset>
            <fieldset id="samplesFieldset">
                <legend>
                    {t}Importer des échantillons : {/t}
                    <input type="checkbox" id="sampleEnable" name="sampleEnable" value="1">
                </legend>
                <div class="form-group">
                    <label for="sampleCollection" class="col-md-4 control-label">
                        {t}Collection de destination :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="sampleCollection" name="sampleCollection" class="form-control containers">
                            {foreach $collections as $collection}
                            <option value="{$collection.collection_id}">
                                {$collection.collection_name}
                            </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="sampleTypes" class="col-md-4 control-label">
                        {t}Types d'échantillons à importer :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="samplesType" class="samples form-control" name="samplesType" multiple 
                        title="{t}Vous pouvez sélectionner plusieurs éléments avec ctrl + clic{/t}"
                        >
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="referent" class="col-md-4 control-label">
                        {t}Référent :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="referent" name="referent" class="samples form-control">
                            <option value="" selected></option>
                            {foreach $referents as $referent}
                            <option value="{$referent_name} {$referent_firstname}">
                                {$referent_name} {$referent_firstname}
                            </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group ">
                    <label for="country_id" class="control-label col-md-4">
                        {t}Pays de collecte :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="country" name="country" class="form-control samples">
                            <option value="" selected>
                            </option>
                            {foreach $countries as $country}
                            <option value="{$country.country_name}">
                                {$country.country_name}
                            </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group ">
                    <label for="countryOrigin" class="control-label col-md-4" >
                        {t}Pays de provenance :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="countryOrigin" name="countryOrigin" class="form-control samples">
                            <option value="" selected></option>
                            {foreach $countries as $country}
                            <option value="{$country.country_name}">
                                {$country.country_name}
                            </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="campaign" class="col-md-4 control-label">
                        {t}Campagne de prélèvement :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="campaign" name="campaign" class="samples form-control">
                            <option value="" selected></option>
                            {foreach $campaigns as $campaign}
                            <option value="{$campaign.campaign_name}">{$campaign.campaign_name}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="samplingPlace" class="col-md-4 control-label">
                        {t}Lieu de prélèvement :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="samplingPlace" name="samplingPlace" class="samples form-control">
                            <option value="" selected></option>
                            {foreach $samplingPlaces as $samplingPlace}
                            <option value="{$samplingPlace.sampling_place_name}">
                                {$samplingPlace.sampling_place_name}
                            </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="sampleFields" class="col-md-4 control-label">
                        {t}Colonnes complémentaires à ajouter :{/t}
                    </label>
                    <div class="col-md-8">
                        <table class="col-md-11">
                            <tr>
                                <td>{t}Date d'expiration de l'échantillon :{/t}</td>
                                <td class="center"><input type="checkbox" class="samples form-control" name="sampleFields[]" value="sampleDateExpiration" ></td>
                            </tr>
                            <tr>
                                <td>{t}Identifiant dans la base de données d'origine :{/t}</td>
                                <td class="center"><input type="checkbox" class="samples form-control" name="sampleFields[]" value="sampleDbuidOrigin" ></td>
                            </tr>
                            <tr>
                                <td>{t}Rangement de l'échantillon dans un contenant :{/t}</td>
                                <td class="center"><input type="checkbox" class="samples form-control" name="sampleFields[]" value="sampleLocation" ></td>
                            </tr>
                            <tr>
                                <td>{t}Échantillon dérivé (ajout du parent) :{/t}</td>
                                <td class="center"><input type="checkbox" class="samples form-control" name="sampleFields[]" value="sampleParent" ></td>
                            </tr>
                            <tr>
                                <td>{t}Échantillon composé (plusieurs parents) :{/t}</td>
                                <td class="center"><input type="checkbox" class="samples form-control" name="sampleFields[]" value="sampleComposite" ></td>
                            </tr>
                            <tr>
                                <td>{t}Localisation GPS :{/t}</td>
                                <td class="center"><input type="checkbox" class="samples form-control" name="sampleFields[]" value="sampleGps" ></td>
                            </tr>
                            <tr>
                                <td>{t}UUID connu :{/t}</td>
                                <td class="center"><input type="checkbox" class="samples form-control" name="sampleFields[]" value="sampleUuid" ></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </fieldset>
            <fieldset id="identifiers">
                <legend>{t}Informations communes aux contenants et aux échantillons{/t}</legend>
					<div class="form-group ">
						<label for="identifiers" class="control-label col-md-4">
							{t}Identifiants complémentaires :{/t}
						</label>
						<div class="col-md-8">
							<select id="identifiers" name="identifiers" class="form-control" multiple
                            title="{t}Vous pouvez sélectionner plusieurs éléments avec ctrl + clic{/t}"
                            >
								<option value="" {if $data.country_origin_id=="" }selected{/if}></option>
								{foreach $identfiers as $identifier}
                                {if !empty($identifier.identifier_type_code)}
								<option value="{$identifier.identifier_type_code}">
									{$identifier.identifier_type_code} ({$identifier.identifier_type_name})
								</option>
                                {/if}
								{/foreach}
							</select>
						</div>
					</div>
            </fieldset>
            <div class="form-group center">
                        <button type="submit" class="btn btn-primary" id="submit">{t}Générer le fichier{/t}</button>
                  </div>
            {$csrf}
        </form>
    </div>
    <div class="col-lg-6 bg-info">
        {t}Ce module permet de générer un modèle de fichier pour réaliser une importation de masse. Le modèle ne contient que les colonnes principales, basées sur les libellés plutôt que sur les numéros informatiques. Vous pourrez le compléter si nécessaire avec les colonnes décrites ci-dessous.{/t}
        <br>
        {t}Voici la liste descolonnes qui sont autorisées dans le fichier :{/t}
        <br>
        <ul>
            <li>{t}Pour importer des contenants :{/t}
                <ul>
                    <li><b>container_identifier</b> : {t}l'identifiant du contenant (obligatoire){/t}</li>
                    <li><b>container_type_id / container_type_name</b> : {t}le numéro informatique du type de contenant ou son nom (obligatoire){/t} <a href="containerTypeList">{t}Types de conteneurs{/t}</a></li>
                    <li><b>container_status_id / container_status_name</b> : {t}le numéro informatique du statut du contenant ou son nom (obligatoire){/t} <a href="objectStatusList">{t}Liste des statuts{/t}</a></li>
                    <li><b>container_uuid</b> : {t}UID Universel du contenant (UUID){/t}</li>
                    <li><b>container_collection_id / container_collection_name</b> : {t}le numéro informatique de la collection ou son nom{/t} <a href="collectionList">{t}Liste des collections{/t}</a></li>
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
                    <li><b>collection_id / collection_name</b> : {t}le numéro informatique de la collection ou son nom (obligatoire){/t} <a href="collectionList">{t}Liste des collections{/t}</a></li>
                    <li><b>sample_type_id / sample_type_name</b> : {t}le numéro informatique du type d'échantillon ou son nom (obligatoire){/t} <a href="sampleTypeList">{t}Types d'échantillons{/t}</a></li>
                    <li><b>sample_status_id / sample_status_name</b> : {t}le numéro du statut de l'échantillon ou son nom(obligatoire){/t} <a href="objectStatusList">{t}Liste des statuts{/t}</a></li>
                    <li><b>campaign_id / campaign_name / campaign_uuid</b> : {t}le numéro informatique de la campagne de prélèvement, son nom ou son UUID{/t} <a href="campaignList">{t}Liste des campagnes{/t}</a></li>
                    <li><b>sampling_place_id / sampling_place_name</b> : {t}le numéro informatique de l'endroit où l'échantillon a été prélevé ou son nom{/t} <a href="samplingPlaceList">{t}Liste des lieux de prélèvement{/t}</a></li>
                    <li><b>country_code</b>: {t}le code du pays de collecte, sur deux positions{/t} <a href="countryList">{t}Liste des pays{/t}</a></li>
                    <li><b>country_name</b>: {t}le nom du pays de collecte, qui doit être strictement identique au libellé affiché dans la table {/t} <a href="countryList">{t}des pays{/t}</a></li>
                    <li><b>country_origin_code</b>: {t}le code du pays de provenance, sur deux positions{/t} <a href="countryList">{t}Liste des pays{/t}</a></li>
                    <li><b>country_origin_name</b>: {t}le nom du pays de provenance, qui doit être strictement identique au libellé affiché dans la table {/t} <a href="countryList">{t}des pays{/t}</a></li>
                    <li><b>referent_id / referent_name</b> : {t}le numéro informatique du référent ou son nom, sous la forme "nom prénom"{/t}</li>
                    <li><b>wgs84_x</b> : {t}la longitude GPS en WGS84 (degrés décimaux, séparateur décimal : point){/t}</li>
                    <li><b>wgs84_y</b> : {t}la latitude GPS en WGS84 (degrés décimaux, séparateur décimal : point){/t}</li>
                    <li><b>sampling_date</b> : {t}la date de création/échantillonnage de l'échantillon, au format dd/mm/yyyy{/t}</li>
                    <li><b>expiration_date</b> : {t}la date d'expiration de l'échantillon, au format dd/mm/yyyy{/t}</li>
                    <li><b>sample_multiple_value</b> : {t}le nombre total de sous-échantillons (ou le volume total, ou le pourcentage...) contenu dans l'échantillon si le type d'échantillons utilisé le permet (valeur numérique, séparateur décimal : point){/t}</li>
                    <li><b>sample_multiple_real</b> : {t}le nombre réel de sous-échantillons (ou le volume total, le pourcentage...) qu'il reste dans l'échantillon au moment de l'importation. Un sous-échantillonnage sera généré (différence entre sample_multiple_value et sample_multiple_real){/t}</li>
                    <li><b>sample_comment</b> : {t}Commentaire libre sur l'échantillon{/t}</li>
                    <li><b>sample_parent_uid</b> : {t}UID du parent (création d'échantillons rattachés){/t}</li>
                    <li><b>sample_parent_identifier</b> : {t}identifiant métier du parent (doit être créé avant l'échantillon courant ou figurer plus haut dans le fichier, et l'identifiant doit être unique){/t}</li>
                    <li><b>composite_parents_uid</b> : {t}liste des uid, séparés par une virgule, des parents utilisés pour créer un échantillon composé. Les parents doivent avoir été créés préalablement ou figurer plus haut dans le fichier{/t}</li>
                    <li><b>composite_parents_identifier</b> : {t}liste des identifiants métiers, séparés par une virgule, des parents utilisés pour créer un échantillon composé. Les parents doivent avoir été créés préalablement ou figurer plus haut dans le fichier, les identifiants doivent être uniques{/t}</li>
                    <li><b>composite_multiple_value</b> : {t}quantité prélevée dans chaque parent pour créer l'échantillon composé. La quantité doit être identique pour chaque parent{/t}</li>
                    <li><b>dbuid_origin</b> : {t}Identifiant technique dans la base de données d'origine (de préférence sous la forme : nom_base:id){/t}</li>
                    <li><b>sample_uuid</b> :  {t}UID Universel de l'échantillon (UUID){/t}</li>
                    <li><b>container_parent_uid</b> : {t}l'UID du contenant où l'échantillon ou le contenant est rangé{/t}</li>
                    <li><b>container_parent_identifier</b> : {t}identifiant métier du contenant où l'échantillon est rangé (doit être créé préalablement, ou figurer plus haut dans le fichier - l'identifiant doit être unique){/t}</li>
                    <li><b>sample_location</b> : {t}l'emplacement de rangement de l'échantillon dans le contenant (texte libre){/t}</li>
                    <li><b>sample_column</b> : {t}n° de la colonne de stockage dans le contenant{/t}</li>
                    <li><b>sample_line</b> : {t}n° de la ligne de stockage dans le contenant{/t}</li>
                    <li>
                        <b>sample_metadata_json</b> : {t escape=no}les métadonnées rattachées à l'échantillon (au format json, p. e. : &#123;"taxon":"Alosa alosa"&#125;) <a href="metadataList">{t}Liste des modèles de métadonnées{/t}</a>{/t}
                        <ul>
                            <li>{t}il est également possible de définir les métadonnées avec un attribut par colonne. Dans ce cas, la colonne doit être nommée md_nomAttribut, par exemple : md_taxon. La valeur de la colonne md_xxx écrasera celle de l’attribut xxx présent dans la colonne sample_metadata_json{/t}
                            <li>{t escape=no}Dans le cas de multi-valeurs, celles-ci doivent être séparées par une virgule dans la colonne md_ (exemple : valeur1,valeur2), et entourées de crochets dans la colonne sample_metadata_json (exemple : &#123;"valeurs":&#91;valeur1,valeur2&#93;&#125;){/t}</li>
                        </ul>
                  </li>
                </ul>
            </li>
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