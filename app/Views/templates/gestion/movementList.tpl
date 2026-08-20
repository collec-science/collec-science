<div class="container">
    <div class="row">
        <div class="col-auto">
            <h2>{t}Liste des mouvements{/t}</h2>
        </div>
        <div class="col-auto">
            {$help}
        </div>
    </div>
    <form class="form-horizontal " id="movement_search" action="movementList" method="GET">
        <input id="moduleBase" type="hidden" name="moduleBase" value="movement">
        <input id="isSearch" type="hidden" name="isSearch" value="1">
        <div class="row">
            <label for="login" class="col-2 form-label">{t}Login à rechercher :{/t}</label>
            <div class="col-4">
                <input id="login" name="login" class="form-control" value="{$movementSearch.login}">
            </div>
            <div class="col-2 offset-3">
                <button type="submit" class="btn btn-success">{t}Rechercher{/t}</button>
            </div>
        </div>
        <div class="row">
            <label for="date_start" class="col-2 form-label">{t}Du :{/t}</label>
            <div class="col-4">
                <input class="datepicker form-control" name="date_start" id="date_start" value="{$movementSearch.date_start}">
            </div>
            <label for="date_end" class="col-2 form-label">{t}Au :{/t}</label>
            <div class="col-4">
                <input class="datepicker form-control" name="date_end" id="date_end" value="{$movementSearch.date_end}">
            </div>
        </div>
        {$csrf}
    </form>
    <div class="row">
        <div class="col-12">
            {if $movementSearch.isSearch > 0}
            <table id="movementList" class="table table-bordered table-hover datatable-export display" data-order='[[1,"desc"],[3,"asc"]]'>
                <thead>
                    <tr>
                        <th>{t}Login{/t}</th>
                        <th>{t}Date{/t}</th>
                        <th>{t}Type de mouvement{/t}</th>
                        <th>{t}UID{/t}</th>
                        <th>{t}Identifiant métier{/t}</th>
                        <th>{t}Type{/t}</th>
                        <th>{t}Emplacement{/t}</th>
                        <th>{t}Raison{/t}</th>
                        <th>{t}Commentaire{/t}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $data as $row}
                    <tr>
                        <td>{$row.login}</td>
                        <td>{$row.movement_date}</td>
                        <td>{if $row.movement_type_id == 1}
                            <span class="green">{t}Déplacement{/t}</span>{else}
                            <span class="red">{t}Sortie du stock{/t}</span>
                            {/if}
                        </td>
                        <td>
                            {if $row.object_type_name == 'sample'}
                            <a href="sampleDisplay?uid={$row.uid}">
                                {else}
                                <a href="containerDisplay?uid={$row.uid}">
                                    {/if}
                                    {$row.uid}
                                </a>
                        </td>
                        <td>{$row.identifier}</td>
                        <td>{$row.type_name}</td>
                        <td>{if $row.movement_type_id == 1}
                            {if strlen($row.storage_location) > 0}
                            {$row.storage_location}&nbsp;
                            {/if}
                            C{$row.column_number}L{$row.line_number}
                            {/if}
                        </td>
                        <td>{$row.movement_reason_name}</td>
                        <td>{$row.movement_comment}</td>
                    </tr>
                    {/foreach}
                </tbody>
                {/if}
            </table>
        </div>
    </div>
</div>