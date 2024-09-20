<h2>{t}Les nouveautés...{/t}</h2>
<div class="col-lg-8">
<div class="row">
{section name=n loop=$news}
{if      $news[n].type == 'version'}
  <h3>{$news[n].content}</h3>
{elseif  $news[n].type == 'category'}
  <h4>{$news[n].content}</h4>
{elseif  $news[n].type == 'subitem'}
  - {$news[n].content}<br/>{* pourrait être des <li> *}
{elseif  $news[n].type == 'empty'}

{else}{* $news[n].type == 'item' *}
  {$news[n].content}<br/>
{/if}
{/section}
</div>
</div>