<h2>Import d'échantillons provenant d'une base externe à partir d'un fichier CSV</h2>

<div class="row col-md-6">
<form class="form-horizontal protoform" id="sampleStage1" method="post" action="index.php" enctype="multipart/form-data">
<input type="hidden" name="module" value="sampleImportStage2">
<div class="form-group">
<label for="upfile" class="control-label col-md-4">Nom du fichier à importer (CSV)<span class="red">*</span> :</label>
<div class="col-md-8">
<input type="file" name="upfile" required>
</div>
</div>
<div class="form-group">
<label for="separator" class="control-label col-md-4">Séparateur utilisé :</label>
<div class="col-md-8">
<select id="separator" name="separator">
<option value="," {if $separator == ","}selected{/if}>Virgule</option>
<option value=";" {if $separator == ";"}selected{/if}>Point-virgule</option>
<option value="tab" {if $separator == "tab"}selected{/if}>Tabulation</option>
</select>
</div>
</div>
<div class="form-group">
<label for="utf8_encode" class="control-label col-md-4">Encodage du fichier :</label>
<div class="col-md-8">
<select id="utf8_encode" name="utf8_encode">
<option value="0" {if $utf8_encode == 0}selected{/if}>UTF-8</option>
<option value="1" {if $utf8_encode == 1}selected{/if}>ISO-8859-x</option>
</select>
</div>
</div>
<div class="form-group center">
      <button type="submit" class="btn btn-primary">Télécharger le fichier</button>
</div>
</form>


<span class="red">*</span><span class="messagebas">{$LANG["message"].36}</span>
</div>

{if $stage > 1}
<fieldset class="row col-md-12">
<legend>Tableau de correspondance entre les libellés fournis et ceux de la base de données locale</legend>
<form class="form-horizontal protoform" id="sampleStage2" method="post" action="index.php" enctype="multipart/form-data">
<input type="hidden" name="module" value="sampleImportStage3">
<input type="hidden" name="realfilename" value="{$realfilename}">
<input type="hidden" name="separator" value="{$separator}">
<input type="hidden" name="utf8_encode" value="{$utf8_encode}">
<div class="form-group">
<label for="filename" class="control-label col-md-4">Fichier en cours de traitement :</label>
<div class="col-md-8">
<input type="text" id="filename" class="form-control" readonly name="filename" value="{$filename}">
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
<option value="{$svalue[$kname]}" {if $svalue[$kname] == $val}selected{/if}>{$svalue[$kname]}</option>
{/foreach}
</select>
</div>
</div>
{/foreach}
</fieldset>
{/foreach}
<div class="form-group center">
      <button type="submit" class="btn btn-danger">Déclencher l'import</button>
</div>
</form>
</fieldset>
{/if}

<div class="row">
<div class="col-sm-12">
<div class="bg-info">
Ce module permet d'importer des échantillons provenant d'une base externe, à partir d'un fichier CSV. Liste des colonnes possibles :
<br>
<ul>
<li><b>dbuid_origin*</b> : identifiant <b>unique</b> dans la base de données d'origine, sous la forme : code_base:id</li>
<li><b>identifier</b> : identifiant métier</li>
<li><b>sample_type_name*</b> : type d'échantillon</li>
<li><b>collection_name*</b> : nom de la collection (ou de la collection) de rattachement</li>
<li><b>object_status_name</b> : statut courant</li>
<li><b>wgs84_x</b> : longitude GPS en WGS84 (degrés décimaux)</li>
<li><b>wgs84_y</b> : latitude GPS en WGS84 (degrés décimaux)</li>
<li><b>sample_creation_date</b> : date de création de l'échantillon dans la base de données d'origine, sous la forme YYYY-MM-DD HH:MM:SS</li>
<li><b>sampling_date</b> : date de référence de l'échantillon dans la base de données d'origine, sous la forme YYYY-MM-DD HH:MM:SS</li>
<li><b>expiration_date</b> : date d'expiration ou de fin de validité de l'échantillon</li>
<li><b>multiple_value</b> : Nombre ou quantité de sous-échantillons disponibles</li>
<li><b>sampling_place_name</b> : lieu de prélèvement de l'échantillon</li>
<li><b>metadata</b> : liste des métadonnées associées, au format JSON. Il est également possible de définir des métadonnées au format texte, en respectant les règles suivantes :
<ul>
<li>un champ par métadonnée</li>
<li>chaque champ doit être préfixé par <b>md_</b> pour pouvoir être reconnu comme tel par le logiciel</li>
<li>le champ ne doit pas être présent dans la colonne <i>metadata</i>
</ul>
</li>
<li><b>identifiers</b> : liste des identifiants secondaires, sous la forme : code1:val1,code2:val2</li>
<li><b>dbuid_parent</b> : dans le cas d'un échantillon dérivé, identifiant du parent sous la forme code_base:identifiant. Cette valeur correspond à la valeur <i>dbuid_origin</i> de l'échantillon parent. 
Ce dernier doit avoir été importé préalablement pour que la relation puisse être créee
</li>
</ul>
Les champs obligatoires sont signalés par une étoile (*).
</div>
</div>
</div>
