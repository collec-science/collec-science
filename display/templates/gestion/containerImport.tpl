<h2>{t}Import de containers et d'échantillons inclus provenant d'une base externe à partir d'un fichier JSON{/t}</h2>

<div class="row col-md-6">
    <form class="form-horizontal protoform" id="containerStage1" method="post" action="index.php" enctype="multipart/form-data">
        <input type="hidden" name="module" value="containerImportStage2">
        <div class="form-group">
            <label for="upfile" class="control-label col-md-4"><span class="red">*</span> {t}Nom du fichier à importer (JSON) :{/t}</label>
            <div class="col-md-8">
                <input type="file" name="upfile" required>
            </div>
        </div>
        <div class="form-group">
            <label for="utf8_encode" class="control-label col-md-4">{t}Encodage du fichier :{/t}</label>
            <div class="col-md-8">
                <select id="utf8_encode" name="utf8_encode">
                    <option value="0" {if $utf8_encode == 0}selected{/if}>UTF-8</option>
                    <option value="1" {if $utf8_encode == 1}selected{/if}>ISO-8859-x</option>
                </select>
            </div>
        </div>
        <div class="form-group center">
            <button type="submit" class="btn btn-primary">{t}Vérifier le fichier{/t}</button>
        </div>
    </form>


    <span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
</div>

{if $stage > 1}
    <fieldset class="row col-md-12">
        <legend>{t}Tableau de correspondance entre les libellés fournis et ceux de la base de données locale{/t}</legend>
        <form class="form-horizontal protoform" id="containerStage2" method="post" action="index.php" enctype="multipart/form-data">
            <input type="hidden" name="module" value="containerImportStage3">
            <input type="hidden" name="realfilename" value="{$realfilename}">
            <input type="hidden" name="separator" value="{$separator}">
            <input type="hidden" name="utf8_encode" value="{$utf8_encode}">
            <div class="form-group">
                <label for="filename" class="control-label col-md-4">{t}Fichier en cours de traitement :{/t}</label>
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
                                        <option value="{$svalue[$kname]}" {if strtoupper($svalue[$kname]) == strtoupper($val)}selected{/if}>{$svalue[$kname]}</option>
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
        </form>
    </fieldset>
{/if}

<div class="row">
    <div class="col-sm-12">
        <div class="bg-info">
        {t}Ce module permet d'importer des contenants ainsi que les contenants ou les échantillons qu'ils contiennent, et  qui proviennent d'une base externe.{/t}
        <br>
        {t}Le fichier doit avoir été généré par une autre instance de Collec-Science, et doit être au format JSON, sans avoir été modifié.{/t}
        </div>
    </div>
</div>
