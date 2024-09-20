<h2>{t}Réinitialisation du mot de passe{/t}</h2>
{t 1=$prenom 2=$nom}Bonjour %1 %2,{/t}
<br><br>
{t 1=$applicationName}Vous avez demandé à réinitialiser votre mot de passe pour l'application %1. Si ce n'était pas le cas, contactez l'administrateur de l'application.{/t}
<br>
{t}Pour réinitaliser votre mot de passe, recopiez le lien suivant dans votre navigateur :{/t}
<br>
<a href='{$link}'>{$link}</a>
<br>
{t 1=$expiration}Le lien restera valable jusqu'au %1.{/t}
