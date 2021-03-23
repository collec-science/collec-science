# Renommer un champ de métadonnées

## Présentation

Les métadonnées décrivant les échantillons sont stockées dans un champ au format JSON. S'il permet une grande souplesse (possibilité de rajouter des champs très facilement), il a également ses propres limites.

L'éditeur utilisé dans le logiciel pour modifier les métadonnées va réécrire complètement le contenu du champ JSON. Si celui-ci contenait au préalable un champ inconnu dans le modèle, celui-ci va être perdu.
Pour arriver à modifier le nom d'un champ, il faut donc procéder en plusieurs étapes.

Imaginons que nous souhaitions renommer le champ "espece" en "species".

### Première étape : renommer le champ dans la base de données

Avec un éditeur SQL, nous allons d'abord vérifier l'opération de renommage avant de l'exécuter : 

~~~
select sample_id, metadata, metadata -> 'espece',
jsonb_insert(metadata::jsonb, '{"species"}'::text[],  (metadata->'espece' )::jsonb) - 'espece'
from col.sample 
where metadata ->>'espece' is not null;
~~~

La requête permet de rajouter un champ "species" dont le contenu est 'espece' (*jsonb_insert*), puis de supprimer le champ 'espece' (- 'espece').

Pour mettre à jour les données, il suffit de modifier la requête ainsi : 

~~~
update col.sample 
set metadata = jsonb_insert(metadata::jsonb, '{"species"}'::text[],  (metadata->'espece' )::jsonb) - 'espece'
where metadata ->> 'espece' is not null;
~~~

### Seconde étape : modifier le ou les modèles de métadonnées correspondants

Dans le logiciel, modifiez les modèles de métadonnées pour renommer le champ 'espece' en 'species'.

Vous pouvez visualiser rapidement la liste des modèles de métadonnées qui contiennent le libellé concerné :

~~~
select metadata_id, metadata_name, metadata_schema
from col.metadata
where metadata_schema::text like '%espece%';
~~~