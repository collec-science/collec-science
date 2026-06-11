<div class="container-fluid">
    <div class="row">
        <h2>{$title}</h2>
    </div>
    <div class="row">
        <table class="datatable-nopaging display table table-bordered table-hover">
            <thead>
                <th>{t}Nom de la variable{/t}</th>
                <th>{t}Contenu{/t}</th>
            </thead>
            <tbody>
                {foreach from=$data key="k" item="v"}
                <tr>
                    <td>{$k}</td>
                    <td>{$v}</td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>