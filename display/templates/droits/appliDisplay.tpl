<a href="index.php?module=appliList">Retour à la liste des applications</a>
<h2>Liste des droits disponibles pour l'application 
<a href="index.php?module=appliChange&aclappli_id={$data.aclappli_id}">
{$data.appli} ({$data.applidetail})
</a>
</h2>
<div class="col-md-6">
<a href="index.php?module=appliChange&aclappli_id={$data.aclappli_id}">
<img src="display/images/edit.gif" height="25">
Modifier...
</a>
<a href="index.php?module=acoChange&aclaco_id=0&aclappli_id={$data.aclappli_id}">
<img src="display/images/new.png" height="25">
Nouveau droit...
</a>
<table id="acoliste" class="table table-bordered table-hover">
<thead>
<tr>
<th>Nom du droit d'accès</th>
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