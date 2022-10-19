{t}Bonjour{/t}
<br><br>
{t 1=$login 2=$name 3=$appName}%2 a créé son compte avec le login %1 dans l'application %3. Le compte est actuellement inactif.{/t}
<br>
{if !empty($organization)}
{t 1=$organization}La personne est rattachée à l'organisation %1.{/t}
<br>
{/if}
{t}Pour activer le compte, connectez-vous à l'application :{/t}
<br>
<a href={$link}>{$link}</a>
