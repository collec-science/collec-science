{* Objets > Contenants > Rechercher > UID d'un contenant > section "Répartition des objets dans le contenant" si visible > *}
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
            <th class="center">{t}Ligne/colonne{/t}</th>
            {for $col=1 to $nbcolonnes}
                <th class="center">{$col}</th>
            {/for}
        </tr>
        {foreach $containerOccupation as $line}
            <tr>
                <td class="center"><b>{$ln}</b></td>
                {$ln = $ln + $incr}
                {foreach $line as $cell}
                    {$nb = 0}
                    <td class="center">
                        {foreach $cell as $obj}
                            {if $obj["uid"] > 0}
                                {if $nb > 0}<br>{/if}
                                {$nb = $nb +1}
                                <a href="index.php?module={if $obj['type'] == 'C'}container{else}sample{/if}Display&uid={$obj['uid']}">{$obj["uid"]} {$obj["identifier"]}</a>
                            {else}
                                &nbsp;
                            {/if}
                        {/foreach}
                    </td>
                {/foreach}
            </tr>
        {/foreach}
    </table>
{/if}