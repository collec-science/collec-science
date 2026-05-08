<div class="container">
    <h2>{t}Modification du droit d'une application (module de gestion des droits){/t}</h2>
    <div class="row">
        <a href="appliList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste des applications{/t}
        </a>
        &nbsp;<a href="appliDisplay?aclappli_id={$dataAppli.aclappli_id}">
            {t}Retour à{/t} {$dataAppli.appli} {if $dataAppli.applidetail}({$dataAppli.applidetail}){/if}
        </a>
    </div>
    <div class="row">
        <form id="acoForm" class="form-horizontal protoform" method="post" action="index.php">
            <input type="hidden" name="aclaco_id" value="{$data.aclaco_id}">
            <input type="hidden" name="aclappli_id" value="{$data.aclappli_id}">
            <input type="hidden" name="moduleBase" value="aco">
            <input type="hidden" name="action" value="Write">
            <div class="row d-flex justify-content-center">
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                </div>
                {if $data.aclappli_id > 0 }
                <div class="col-auto">
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                </div>
                {/if}
            </div>

            <div class="row">
                <label for="aco" class="form-label col-4"><span class="red">*</span> 
                    {t}Nom du droit utilisé dans l'application :{/t}
                </label>
                <div class="col-8"><input type="text" class="form-control" id="aco" name="aco" value="{$data.aco}"
                        autofocus required {if $newRightEnabled==0} readonly{/if}>
                </div>
            </div>
            <div class="row">
                <fieldset class="col-12">
                    <legend>{t}Groupes disposant du droit :{/t}</legend>
                    <div class="row align-items-center">
                        {section name=lst loop=$groupes}
                        <div class="col-3 col-offset-1">
                            <input id="group{$smarty.section.lst.index}" type="checkbox" class="form-check-input" name="groupes[]"
                                value="{$groupes[lst].aclgroup_id}" {if $groupes[lst].checked==1}checked{/if}>
                            <label class="form-check-label" for="group{$smarty.section.lst.index}">
                                {$groupes[lst].groupe}
                            </label>
                        </div>
                        {/section}
                    </div>
                </fieldset>
            </div>

            {$csrf}
        </form>
    </div>
    <div class="row col-12 d-inline">
        <span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
    </div>
</div>