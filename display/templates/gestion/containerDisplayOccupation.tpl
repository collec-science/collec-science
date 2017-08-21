{if $nblignes > 1 || $nbcolonnes > 1}
{if $first_line == "T"}
{$ln = 1}
{$incr = 1}
{else}
{$ln = $nblignes}
{$incr = -1}
{/if}
<table class="table table-bordered">
<tr>
<th class="center">Ligne/colonne</th>
{for $col=1 to $nbcolonnes}
<th class="center">{$col}</th>
{/for}
</tr>
{foreach $containerOccupation as $line}
<tr>
<td class="center"><b>{$ln}</b></td>
{$ln = $ln + $incr}
{foreach $line as $obj}
<td class="center">
{if $obj["uid"] > 0}
<a href="index.php?module={if $obj['type'] == 'C'}container{else}sample{/if}Display&uid={$obj['uid']}">{$obj["identifier"]}</a>
{else}
&nbsp;
{/if}
</td>
{/foreach}
</tr>
{/foreach}

</table>

{/if}