  <div class="container">
    <p class="text-muted hidden-xs hidden-sm">
    {t}Copyright © 2016-2020 - Tous droits réservés. Auteur : Éric Quinton, pour INRAE - Logiciel diffusé sous licence AGPL{/t}
<br>
{t}Pour tout problème :{/t} <a href="{$appliAssist}">{$appliAssist}</a>
</p>
 <ul class="nav pull-right scroll-top scrolltotop">
  <li><a href="#" title="Scroll to top"><i class="glyphicon glyphicon-chevron-up"></i></a></li>
</ul>
{if strlen($developpementMode) > 1}
<div class="text-warning">{$developpementMode}</div>
{/if}
  </div>