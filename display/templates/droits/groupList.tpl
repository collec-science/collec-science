<h2>{$LANG["login"][33]}</h2>
	<div class="row">
	<div class="col-md-6">
<a href="index.php?module=groupChange&aclgroup_id=0">
{$LANG["login"][34]}
</a>

<table id="groupListe" class="table table-bordered table-hover " >
<thead>
<tr>
<th>{$LANG["login"][35]}</th>
<th>{$LANG["login"][36]}</th>
<th>{$LANG["login"][37]}</th>
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
<img src="display/images/droits/list-add.png" height="20">
</a>
</tr>
{/section}
</tbody>
</table>
</div>
</div>