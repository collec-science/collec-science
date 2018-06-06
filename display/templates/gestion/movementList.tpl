{* Mouvements > Liste des mouvements > *}
<div class="row">
<div class="col-md-6">
<form class="form-horizontal protoform" id="movement_search" action="index.php" method="GET">
<input id="moduleBase" type="hidden" name="moduleBase" value="movement">
<input id="action" type="hidden" name="action" value="List">
<input id="isSearch" type="hidden" name="isSearch" value="1">
<div class="form-group">
<label for="login" class="col-md-2 control-label">{t}Login à rechercher :{/t}</label>
<div class="col-md-4">
<input id="login" name="login" class="form-control" value="{$movementSearch.login}">
</div>
<div class="col-md-2 col-md-offset-3">
<input type="submit" class="btn btn-success" value="{t}Rechercher{/t}">
</div>
</div>
<div class="form-group">
<label for="date_start" class="col-md-2 control-label">{t}Du :{/t}</label>
<div class="col-md-4">
<input class="datepicker form-control" name="date_start" id="date_start" value="{$movementSearch.date_start}">
</div>
<label for="date_end" class="col-md-2 control-label">{t}Au :{/t}</label>
<div class="col-md-4">
<input class="datepicker form-control" name="date_end" id="date_end" value="{$movementSearch.date_end}">
</div>
</div>
</form>
</div>
</div>
<div class="row">
<div class="col-md-12">
{if $movementSearch.isSearch > 0}
<table id="movementList" class="table table-bordered table-hover datatable-export" data-order='[[1,"desc"],[3,"asc"]]' >
<thead>
<tr>
<th>{t}Login{/t}</th>
<th>{t}Date{/t}</th>
<th>{t}Type de
mouvement{/t}</th>
<th>{t}UID{/t}</th>
<th>{t}Identifiant
métier{/t}</th>
<th>{t}Type{/t}</th>
<th>{t}Emplacement{/t}</th>
</tr>
</thead>
<tbody>
{foreach $data as $row}
<tr>
<td>{$row.login}</td>
<td>{$row.movement_date}</td>
<td>{*$row.movement_type_name*}{if $row.movement_type_id == 1}
<span class="green">{t}Déplacement{/t}</span>{else}
<span class="red">{t}Sortie du stock{/t}</span>
{/if}</td>
<td>{$row.uid}</td>
<td>{$row.identifier}</td>
<td>{$row.type_name}</td>
<td>{if $row.movement_type_id == 1}
{if strlen($row.storage_location) > 0}
{$row.storage_location}&nbsp;
{/if}
C{$row.column_number}L{$row.line_number}
{/if}
</td>
</tr>
{/foreach}
</tbody>
{/if}
</table>
</div>
</div>
