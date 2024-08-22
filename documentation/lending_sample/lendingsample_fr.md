# Prêter un ou plusieurs échantillons

Il est possible de suivre le prêt d'échantillons auprès de laboratoires tiers, avec une fonction dédiée. Le prêt peut concerner soit un échantillon unique, soit un ensemble d'échantillons, par exemple une boite de tubes.

## Principe général

Les objets prêtés (contenants ou échantillons) prennent le statut "prêté". Lors du prêt, l'emprunteur doit être désigné, et une date de retour prévue peut être positionnée.

Au retour des échantillons ou des contenants, les objets reviennent au statut "normal".

Le prêt ne fonctionne que pour des échantillons "complets". Il n'est pas possible de ne prêter qu'une partie d'un échantillon (en sous-échantillonnage) : dans ce cas de figure, il faut d'abord créer un échantillon dérivé contenant la partie de l'échantillon principal. C'est l'échantillon dérivé, entier (mais partie de l'échantillon principal), qui sera prêté.

## Créer les emprunteurs

Depuis le menu de paramètres, choisissez *Emprunteurs*. À partir de la liste, vous pouvez soit créer un nouvel emprunteur, soit consulter les échantillons ou les contenants qui lui ont été prêtés. 

## Prêter un ou plusieurs objets

Depuis la liste des échantillons ou des contenants, vous pouvez prêter directement des objets. Si vous prêtez un contenant, l'ensemble des échantillons ou des contenants qu'il contient sera également marqué comme prêté. Chaque échantillon ou contenant pourra être traité indépendamment des autres, c'est à dire avoir une date de retour différente.

Il est également possible de prêter un objet depuis son détail, dans l'onglet *Événements/prêts*.

## Générer la liste des objets exportés dans un contenant

Si vous exportez un contenant avec ses échantillons, vous pouvez générer un fichier qui pourra être importé dans l'instance Collec-Science de votre emprunteur.

Pour cela, depuis le menu *Objets > Contenants*, sélectionnez le ou les contenants concernés, puis cliquez sur le bouton "Export avec objets inclus". Un fichier au format JSON sera généré, que vous pourrez transmettre à votre emprunteur.

Celui-ci pourra importer le contenant et les échantillons associés dans sa base de données, à partir du menu *Imports/Exports > Imports de contenants externes*.
Au moment de l'importation, un mouvement d'entrée va être généré pour tous les échantillons présents dans le contenant.

La génération de ce fichier ne dispense pas de réaliser l'opération de prêt proprement dite.

## Réintégrer les échantillons

Une fois que l'emprunteur aura rendu ses échantillons, vous pouvez les réintégrer dans le logiciel.

Deux approches sont possibles : 

- dans le détail de l'échantillon, puis dans le détail du prêt, renseignez la *date de retour réelle* : le statut sera positionné automatiquement à "État normal" au moment de l'enregistrement ;
- créez un mouvement d'entrée de l'objet, soit global, soit objet par objet : le statut sera positionné automatiquement à "État normal", la date de retour du prêt sera également renseignée à la date courante.
