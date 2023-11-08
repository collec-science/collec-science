# Automatiser l'envoi de mails

L'application permet d'envoyer automatiquement des mails à intervalle régulier vers des boites identifiées, pour indiquer :

- les événements concernant les échantillons dont la date d'exécution va arriver ;
- les échantillons qui vont être obsolètes (date d'expiration proche).

Deux types de paramètres doivent être renseignés pour pouvoir activer cette fonctionnalité, et un script doit également être programmé dans le serveur pour déclencher l'opération.

Les paramètres d'envoi sont définis par collection, ce qui permet de définir des destinataires différents pour chacune. Les mails contiennent la liste des échantillons concernés.

L'application n'est actuellement pas configurée pour traiter les événements qui concernent des contenants.

## Activer la génération des mail de façon globale

Dans les paramètres généraux de l'application, (*Administration > Paramètres de l'application*), renseignez la valeur  __notificationDelay__ à 7 (valeur supérieure à 0). C'est le nombre de jours entre deux envois.

Ajoutez ensuite une programmation dans le serveur, en étant connecté *root* :

~~~bash
echo "0 8 * * * /var/www/collec-science/collec-science/collectionsGenerateMail.sh" | crontab -u www-data -
chmod +x /var/www/collec-science/collec-science/collectionsGenerateMail.sh
~~~

Vérifiez que le chemin d'accès au fichier exécuté (*collectionGenerateMail.sh*) soit correct. S'il n'est pas bon, vous devrez également éditer ce fichier et modifier le chemin (ligne 2 du fichier).

Le script s'exécutera tous les jours, à 8 heures. Si la date présente dans le champ __notificationLastDate__ est plus ancienne que le délai indiqué précédemment, le programme recherchera les échantillons dans les collections concernées et enverra les mails s'il en trouve.

## Configurer les collections pour activer l'envoi des mails

Dans *Paramètres > Collections*, passez en mode modification de la collection pour laquelle vous souhaitez activer l'envoi de mails. Positionnez-vous alors dans l'onglet *Notifications*, et renseignez les informations suivantes :

- cochez l'activation des notifications
- indiquez la liste des mails des destinataires, séparés par une virgule
- indiquez le nombre de jours avant les dates d'échéances, une valeur à 0 désactivant la recherche des échantillons concernés (date d'échéance des événements ou d'expiration des échantillons).

## Déclencher un envoi de mails manuellement

Si vous souhaitez (re)lancer l'envoi des mails :

- dans les paramètres généraux de l'application (*Administration > Paramètres de l'application*), supprimez la date qui peut être présente dans le champ ~notificationLastDate~ ;
- appelez la page [index.php?module=collectionsGenerateMail](index.php?module=collectionsGenerateMail)

Aucune information ne sera affichée à l'écran (page blanche). Vous pourrez revenir dans les paramètres de l'application pour vérifier que le champ __notificationLastDate__ a bien été mis à jour.
