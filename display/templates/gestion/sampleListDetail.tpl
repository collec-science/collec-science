<!--  Liste des échantillons pour affichage-->
<table id="containerList" class="table table-bordered table-hover datatable " >
<thead>
<tr>
<th>UID</th>
<th>Identifiant ou nom</th>
<th>Projet</th>
<th>Type</th>
<th>Date</th>
<th>Date de création dans la base</th>
</tr>
</thead>
<tbody>
{section name=lst loop=$samples}
<tr>
<td class="text-center">
<a href="index.php?module=sampleDisplay&uid={$samples[lst].uid}" title="Consultez le détail">
{$samples[lst].uid}
</a>
</td>
<td>
<a href="index.php?module=sampleDisplay&uid={$samples[lst].uid}" title="Consultez le détail">
{$samples[lst].identifier}
</a>
</td>
<td>{$samples[lst].project_name}</td>
<td>{$samples[lst].sample_type_name}</td>
<td>{$samples[lst].sample_date}</td>
<td>{$samples[lst].sample_creation_date}</td>
</tr>
{/section}
</tbody>
</table>
