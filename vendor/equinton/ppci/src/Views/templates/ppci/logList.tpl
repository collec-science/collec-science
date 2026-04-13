<div class="row">
    <div class="col-12 col-8">
        <div class="row">
            <form class="form-horizontal protoform" id="log_search" action="logList" method="POST">
                <input id="isSearch" type="hidden" name="isSearch" value="1">
                <div class="row">
                    <label for="logmodule" class="col-2 form-label">{t}Nom du module :{/t}</label>
                    <div class="col-10">
                        <select id="logmodule" name="logmodule" class="form-control">
                            <option value="" {if $logmodule ==""}selected{/if}></option>
                            {foreach $modules as $module}
                            <option value="{$module.val}" {if $module.val == $logmodule}selected{/if}>{$module.val}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="row">
                    <label for="loglogin" class="col-2 form-label">{t}Login concerné :{/t}</label>
                    <div class="col-6">
                        <select id="loglogin" name="loglogin" class="form-control">
                            <option value="" {if $loglogin ==""}selected{/if}></option>
                            {foreach $logins as $login}
                                <option value="{$login.val}" {if $login.val == $loglogin}selected{/if}>{$login.val}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-2 offset-1">
                        <input type="submit" class="btn btn-success" value="{t}Rechercher{/t}">
                    </div>
                </div>
                <div class="row">
                    <label for="date_from" class="col-2 form-label">{t}du :{/t}</label>
                    <div class="col-2">
                        <input class="datepicker form-control" id="date_from" name="date_from" value="{$date_from}">
                    </div>
                    <label for="date_to" class="col-1 form-label">{t}au :{/t}</label>
                    <div class="col-2">
                        <input class="datepicker form-control" id="date_to" name="date_to" value="{$date_to}">
                    </div>

                </div>
            {$csrf}
</form>
        </div>
        {if !empty($logs)}
            <div class="row">
                <table class="table table-bordered table-hover datatable display" data-order='[[0,"desc"]]'>
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
                                <td class="nowrap">{$log.log_date}</td>
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
