<h2>{t}Nouvel utilisateur{/t}</h2>
{t 1=$login 2=$name 3=$appName}%2 a créé son compte avec le login %1 dans l'application %3. Le compte est actuellement inactif.{/t}
<br>
{if !empty($organization)}
{t 1=$organization}La personne est rattachée à l'organisation %1.{/t}
<br>
{/if}
{t}Pour activer le compte, connectez-vous à l'application :{/t}
<br>
<a href={$link}>{$link}</a>
<br>
<p></p>
<div class="messagebas">
{t}Vous recevez ce message parce que vous êtes administrateur de l'application.{/t}
</div>
