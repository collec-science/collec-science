{* Paramètres > referents > *}
<h2>{t}Référents{/t}</h2>
	<div class="row">
	<div class="col-md-8">
{if $droits.param == 1}
<a href="index.php?module=referentChange&referent_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="referentList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>{t}Nom du référent{/t}</th>
<th>{t}Id{/t}</th>
<th>{t}Mail{/t}</th>
<th>{t}Téléphone{/t}</th>
<th>{t}Adresse postale{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
{if $droits.param == 1}
<a href="index.php?module=referentChange&referent_id={$data[lst].referent_id}">
{$data[lst].referent_name}
</a>
{else}
{$data[lst].referent_name}
{/if}
</td>
<td>{$data[lst].referent_id}</td>
<td>{$data[lst].referent_email}</td>
<td>{$data[lst].referent_phone}</td>
<td>{$data[lst].address_name}
{if strlen($data[lst].address_line2)>0}
<br>{$data[lst].address_line2}
{/if}
{if strlen($data[lst].address_line3)>0}
<br>{$data[lst].address_line3}
{/if}
{if strlen($data[lst].address_city)>0}
<br>{$data[lst].address_city}
{/if}
{if strlen($data[lst].address_country)>0}
<br>{$data[lst].address_country}
{/if}
</td>

</tr>
{/section}
</tbody>
</table>
</div>
</div>