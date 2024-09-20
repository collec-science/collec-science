<h2>{t}Dernières connexions enregistrées{/t}</h2>
<div class="row">
    <div class="col-md-6">
        <table id="connections" class="table table-bordered table-hover " >
            <thead>
                <tr>
                    <th>{t}Date{/t}</th>
                    <th>{t}Adresse IP{/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $connections as $connection}
                <tr>
                    <td>{$connection["log_date"]}</td>
                    <td>{$connection["ipaddress"]}</td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>
