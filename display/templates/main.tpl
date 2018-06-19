<div class="center-block hidden-xs hidden-sm ">
<div class="col-md-3 center">
<a href="index.php?module=containerList">
<img src="{$display}/images/box.png" height="50">
<br>
{t}Liste des contenants{/t}
</a>
</div>
<div class="col-md-3 col-md-offset-1 center">
<a href="index.php?module=sampleList">
<img src="{$display}/images/sample.png" height="50">
<br>
{t}Liste des échantillons{/t}
</a>
</div>
<div class="col-md-3 col-md-offset-1 center">
<a href="index.php?module=smallMovementChange">
<img src="{$display}/images/tablet.png" height="50">
<br>
{t}Mouvements petit terminal{/t}
</a>
</div>
</div>

<div class="center-block hidden-md hidden-lg">
<div class="center">
<a href="index.php?module=smallMovementChange">
<img src="{$display}/images/tablet.png" height="50">
<br>
{t}Mouvements petit terminal{/t}
</a>
</div>
</div>

{if $droits.gestion == 1}
<div class="row top10">&nbsp;</div>
<div class="hidden-xs hidden-sm center-block">
<div class="col-md-3 center">
<a href="index.php?module=fastInputChange">
<img src="{$display}/images/input.png" height="50">
<br>
{t}Entrer ou déplacer dans un contenant{/t}
</a>
</div>
<div class="col-md-3 col-md-offset-1 center">
<a href="index.php?module=movementBatchOpen">
<img src="{$display}/images/barcode-scanner.png" height="50">
<br>
{t}Entrer ou déplacer / Sortir par lots{/t}
</a>
</div>
<div class="col-md-3 col-md-offset-1 center">
<a href="index.php?module=fastOutputChange">
<img src="{$display}/images/output.png" height="50">
<br>
{t}Sortir du stock{/t}
</a>
</div>
</div>
{/if}
