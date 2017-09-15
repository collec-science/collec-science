<div class="center-block">
<div class="col-xs-4 center">
<a href="index.php?module=containerList">
<img src="{$display}/images/box.png" height="50">
<br>
{$LANG["menu"].61}
</a>
</div>
<div class="col-xs-4 col-xs-offset-1 center">
<a href="index.php?module=sampleList">
<img src="{$display}/images/sample.png" height="50">
<br>
{$LANG["menu"].69}
</a>
</div>
</div>

{if $droits.gestion == 1}
<div class="row top10">&nbsp;</div>
<div class="center-block">
<div class="col-xs-3 center">
<a href="index.php?module=fastInputChange">
<img src="{$display}/images/input.png" height="50">
<br>
{$LANG["menu"].73}
</a>
</div>
<div class="col-xs-3 col-xs-offset-1 center">
<a href="index.php?module=storageBatchOpen">
<img src="{$display}/images/barcode-scanner.png" height="50">
<br>
{$LANG["menu"].94}
</a>
</div>
<div class="col-xs-3 col-xs-offset-1 center">
<a href="index.php?module=fastOutputChange">
<img src="{$display}/images/output.png" height="50">
<br>
{$LANG["menu"].75}
</a>
</div>
</div>
{/if}
