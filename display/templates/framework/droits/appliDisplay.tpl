{* Administration > ACL droits > Nom de l'appli > *}
<a href="index.php?module=appliList">{t}Retour à la liste des applications{/t}</a>
<h2>{t}Liste des droits disponibles pour l'application{/t}
<a href="index.php?module=appliChange&aclappli_id={$data.aclappli_id}">
{$data.appli} {if $data.applidetail}({$data.applidetail}){/if}
</a>
</h2>
<div class="col-md-6">
<a href="index.php?module=appliChange&aclappli_id={$data.aclappli_id}">
<img src="{$display}/images/edit.gif" height="25">
{t}Modifier...{/t}
</a>
<a href="index.php?module=acoChange&aclaco_id=0&aclappli_id={$data.aclappli_id}">
<img src="{$display}/images/new.png" height="25">
{t}Nouveau droit...{/t}
</a>
<table id="acoliste" class="table table-bordered table-hover datatable">
<thead>
<tr>
<th>{t}Nom du droit d'accès{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$dataAco}
<tr>
<td>
<a href="index.php?module=acoChange&aclaco_id={$dataAco[lst].aclaco_id}&aclappli_id={$data.aclappli_id}">
{$dataAco[lst].aco}
</a>
</td>
</tr>
{/section}
</tbody>
</table>
</div>