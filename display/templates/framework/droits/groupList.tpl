{* Administration > ACL - groupes de logins > *}
<h2>{t}Liste des groupes de logins{/t}</h2>
	<div class="row">
	<div class="col-md-6">
<a href="index.php?module=groupChange&aclgroup_id=0">
{t}Nouveau groupe racine...{/t}
</a>

<table id="groupListe" class="table table-bordered table-hover " >
<thead>
<tr>
<th>{t}Nom du groupe{/t}</th>
<th>{t}Nombre de logins déclarés{/t}</th>
<th>{t}Rajouter un groupe fils{/t}</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$data}
<tr>
<td>
<a href="index.php?module=groupChange&aclgroup_id={$data[lst].aclgroup_id}&aclgroup_id_parent={$data[lst].aclgroup_id_parent}">
{for $boucle = 1 to $data[lst].level}
&nbsp;&nbsp;&nbsp;
{/for}
{$data[lst].groupe}
</a>
</td>
<td class="center">{$data[lst].nblogin}</td>
<td class="center">
<a href="index.php?module=groupChange&aclgroup_id=0&aclgroup_id_parent={$data[lst].aclgroup_id}">
<img src="{$display}/images/droits/list-add.png" height="20">
</a>
</tr>
{/section}
</tbody>
</table>
</div>
</div>