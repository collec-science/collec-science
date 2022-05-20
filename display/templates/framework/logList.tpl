<div class="row">
    <div class="col-md-12 col-lg-8">
        <div class="row">
            <form class="form-horizontal protoform" id="log_search" action="index.php" method="POST">
                <input id="moduleBase" type="hidden" name="moduleBase" value="log">
                <input id="action" type="hidden" name="action" value="List">
                <input id="isSearch" type="hidden" name="isSearch" value="1">
                <div class="form-group">
                    <label for="logmodule" class="col-md-2 control-label">{t}Nom du module :{/t}</label>
                    <div class="col-md-10">
                        <select id="logmodule" name="logmodule" class="form-control">
                            <option value="" {if $logmodule ==""}selected{/if}></option>
                            {foreach $modules as $module}
                            <option value="{$module.val}" {if $module.val == $logmodule}selected{/if}>{$module.val}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="loglogin" class="col-md-2 control-label">{t}Login concerné :{/t}</label>
                    <div class="col-md-6">
                        <select id="loglogin" name="loglogin" class="form-control">
                            <option value="" {if $loglogin ==""}selected{/if}></option>
                            {foreach $logins as $login}
                                <option value="{$login.val}" {if $login.val == $loglogin}selected{/if}>{$login.val}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-md-2 col-md-offset-1">
                        <input type="submit" class="btn btn-success" value="{t}Rechercher{/t}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="date_from" class="col-md-2 control-label">{t}du :{/t}</label>
                    <div class="col-md-2">
                        <input class="datepicker form-control" id="date_from" name="date_from" value="{$date_from}">
                    </div>
                    <label for="date_to" class="col-md-1 control-label">{t}au :{/t}</label>
                    <div class="col-md-2">
                        <input class="datepicker form-control" id="date_to" name="date_to" value="{$date_to}">
                    </div>

                </div>
            </form>
        </div>
        {if count($logs) > 0}
            <div class="row">
                <table class="table table-bordered table-hover datatable" data-order='[[0,"desc"]]'>
                    <thead>
                        <tr>
                        <th>{t}Date{/t}</th>
                        <th>{t}Module{/t}</th>
                        <th>{t}Commentaires{/t}</th>
                        <th>{t}Login{/t}</th>
                        <th>{t}Adresse IP{/t}</th>
                    </tr>
                    </thead>
                    <tbody>
                        {foreach $logs as $log}
                            <tr>
                                <td>{$log.log_date}</td>
                                <td>{$log.nom_module}</td>
                                <td>{$log.commentaire}</td>
                                <td>{$log.login}</td>
                                <td>{$log.ipaddress}</td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        {/if}
    </div>
</div>
