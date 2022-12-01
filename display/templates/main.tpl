<div class="center-block hidden-xs hidden-sm ">
<div class="col-md-offset-1 col-md-2 center">
<a href="index.php?module=containerList">
<img src="display/images/box.png" height="50">
<br>
{t}Liste des contenants{/t}
</a>
</div>
<div class="col-md-2 center">
<a href="index.php?module=sampleList">
<img src="display/images/sample.png" height="50">
<br>
{t}Liste des échantillons{/t}
</a>
</div>
<div class="col-md-2 center">
<a href="index.php?module=smallMovementChange">
<img src="display/images/tablet.png" height="50">
<br>
{t}Mouvements petit terminal{/t}
</a>
</div>
</div>

<div class="center-block hidden-md hidden-lg">
<div class="center">
<a href="index.php?module=smallMovementChange">
<img src="display/images/tablet.png" height="50">
<br>
{t}Mouvements petit terminal{/t}
</a>
</div>
</div>

{if !empty ($droits) && $droits.gestion == 1}
<div class="row top10">&nbsp;</div>
<div class="hidden-xs hidden-sm center-block">
<div class="col-md-offset-1 col-md-2 center">
<a href="index.php?module=fastInputChange">
<img src="display/images/input.png" height="50">
<br>
{t}Entrer ou déplacer dans un contenant{/t}
</a>
</div>
<div class="col-md-2 center">
<a href="index.php?module=movementBatchOpen">
<img src="display/images/barcode-scanner.png" height="50">
<br>
{t}Entrer ou déplacer / Sortir par lots{/t}
</a>
</div>
<div class="col-md-2 center">
<a href="index.php?module=fastOutputChange">
<img src="display/images/output.png" height="50">
<br>
{t}Sortir du stock{/t}
</a>
</div>
</div>
{/if}
{if !empty($collections) && count($collections) > 0}
<div class="hidden-sm row top10">&nbsp;</div>
<div class="hidden-sm row">
  <div class="col-md-6 col-md-offset-1 col-lg-6 col-lg-offset-2">
    <table class="table table-bordered table-hover datatable-nopaging-nosearching form-display">
    <thead>
      <tr>
      <th class="center">{t}Collection{/t}</th>
      <th>{t}Nombre d'échantillons{/t}</th>
      <th>{t}Date de dernière modification d'un échantillon{/t}</th>
    </tr>
    </thead>
    <tbody>
      {foreach $collections as $col}
        <tr>
          <td class="nowrap">{$col.collection_name}</td>
          <td class="center">{$col.samples_number}</td>
          <td class="center">{$col.last_change}</td>
        </tr>
      {/foreach}
    </tbody>
  </table>
  </div>
</div>
{/if}
