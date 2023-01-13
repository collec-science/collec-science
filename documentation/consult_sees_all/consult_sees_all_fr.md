# Donner les droits de consultation à tous les utilisateurs

Si un utilisateur ne dispose que du droit de consultation (*consult*), s'il peut visualiser tous les échantillons, il ne peut toutefois pas consulter les métadonnées ou les documents associés (hormis le dernier publié).

Il est toutefois possible d'activer la visualisation des métadonnées pour tous les échantillons, quelle que soit la collection considérée.

## Avant la version 2.9

Insérez manuellement l'enregistrement suivant dans la table dbparam :

~~~
insert into col.dbparam (dbparam_name, dbparam_value)
values ('consult_sees_all', 1);
~~~

## À partir de la version 2.9

Éditez les paramètres de l'application (menu d'administration), et basculez la valeur *consult_sees_all* à 1.
