<h2>{t}Détail du modèle d'exportation{/t} <i>{$data.export_model_name}</i></h2>
<div class="row">
    <a href="exportModelList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    {if $rights.param == 1}
        &nbsp;
        <a href="exportModelChange&export_model_id={$data.export_model_id}">
            <img src="display/images/edit.gif" height="25">
            {t}Modifier{/t}
        </a>
    {/if}
</div>
<div class="row">
    <div class="col-lg-6 col-md-12">
    <table id="patternList" class="table table-bordered table-hover datatable-nosort"  >
        <thead>
            <tr>
                <th>{t}Table{/t}</th>
                <th>{t}Alias{/t}</th>
                <th>{t}Table fournie vide ?{/t}</th>
                <th>{t}Clé primaire{/t}</th>
                <th>{t}Clé métier{/t}</th>
                <th>{t}Clé étrangère{/t}</th>
                <th>{t}Relation de type 1-1{/t}</th>
                <th colspan="2">{t}Tables filles{/t}</th>
                <th colspan="2">{t}Tables parentes{/t}</th>
                <th>{t}2nde clé étrangère (table n-n){/t}</th>
                <th>{t}Alias de la 2nde table{/t}</th>
            </tr>
            <tr>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th>{t}Alias{/t}</th>
                <th>{t}Relation stricte ?{/t}</th>
                <th>{t}Alias{/t}</th>
                <th>{t}Colonne{/t}</th>
                <th></th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            {foreach $pattern as $row}
                <tr>
                    <td>{$row.tableName}</td>
                    <td>{$row.tableAlias}</td>
                    <td>{if $row.isEmpty == 1}{t}Oui{/t}{/if}</td>
                    <td >{$row.technicalKey}</td>
                    <td >{$row.businessKey}</td>
                    <td >{$row.parentKey}</td>
                    <td class="center">
                        {if $row.istable11 == 1}{t}Oui{/t}{/if}
                    </td>
                    <td>
                        {foreach $row.children as $key=>$child}
                            {if $key > 0}<br>{/if}
                            {$child.aliasName}
                        {/foreach}
                    </td>
                    <td>
                        {foreach $row.children as $key=>$child}
                            {if $key > 0}<br>{/if}
                            {if $child.isStrict == 1}{t}Oui{/t}{/if}
                        {/foreach}
                    </td>
                    <td>
                        {foreach $row.parents as $key=>$child}
                        {if $key > 0}<br>{/if}
                        {$child.aliasName}
                    {/foreach}
                    </td>
                    <td>
                        {foreach $row.parents as $key=>$child}
                            {if $key > 0}<br>{/if}
                            {$child.fieldName}
                        {/foreach}
                    </td>
                    <td>{$row.tablenn.secondaryParentKey}</td>
                    <td>{$row.tablenn.tableAlias}</td>
                </tr>
            {/foreach}
        </tbody>
    </table>
    </div>
</div>
{if $rights.param == 1}
    <div class="row">
        <fieldset class="col-md-6">
            <legend>{t}Exportation de l'ensemble des données concernées par le modèle{/t}</legend>
            <form class="form-horizontal " id="exportModelExec" method="post" action="exportModelExec">
                <input type="hidden" name="moduleBase" value="exportModel">
                <input type="hidden" name="export_model_name" value="{$data.export_model_name}">
                <input type="hidden" name="returnko" value="exportModelDisplay">
                <div class="row">
                        <div class="col-md-12 center">
                            <button id="exportButton" type="submit" class="btn btn-warning">{t}Exporter toutes les données concernées par le modèle{/t}</button>
                        </div>
                    </div>
            {$csrf}</form>
        </fieldset>
    </div>
    <div class="row">
        <fieldset class="col-md-6">
            <legend>{t}Importation de données précédemment exportées{/t}</legend>
            <form class="form-horizontal  col-md-12" id="importExecForm" method="post" action="exportModelImportExec"
        enctype="multipart/form-data">
                <input type="hidden" name="moduleBase" value="exportModel">
                <input type="hidden" name="export_model_id" value="{$data.export_model_id}">
                <input type="hidden" name="export_model_name" value="{$data.export_model_name}">
                <input type="hidden" name="returnko" value="exportModelDisplay">
                <input type="hidden" name="returnok" value="exportModelDisplay">
                <div class="form-group">
                    <label for="FileName" class="control-label col-md-4">
                        <span class="red">*</span> {t}Fichier à importer (format JSON généré par l'opération d'export ci-dessus) :{/t}
                    </label>
                    <div class="col-md-8">
                        <input id="FileName" type="file" class="form-control" name="filename" size="40" required>
                    </div>
                </div>
                <div class="form-group center">
                    <button id="importButton" type="submit" class="btn btn-warning">{t}Importer les données{/t}</button>
                </div>
            {$csrf}</form>
        </fieldset>
    </div>

{/if}
