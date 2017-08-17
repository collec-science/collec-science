  <div class="container">
    <p class="text-muted">
    {$LANG.message.23}
<br>
{$LANG.message.25}
<a href="{$appliAssist}">{$appliAssist}</a>
 <ul class="nav pull-right scroll-top scrolltotop">
  <li><a href="#" title="Scroll to top"><i class="glyphicon glyphicon-chevron-up"></i></a></li>
</ul>
{if strlen($developpementMode) > 1}
<div class="text-warning">{$developpementMode}</div>
{/if}
  </div>