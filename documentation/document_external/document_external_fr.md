# Associer des documents externes à un échantillon

## Principe

L'application Collec-Science permet de stocker des documents dans la base de données. Si cette approche est pertinente pour les fichiers de petite taille (quelques Mo), le stockage de fichiers beaucoup plus volumineux (quelques centaines de Mo ou plus), comme les photos réalisées avec les microscopes modernes, rend leur gestion plus compliquée :

- le volume maximum téléchargeable *via* l'application est limité à 50 ou 100 Mo
- les mécanismes de sauvegarde sont pénalisés dès lors que le volume de ces document explose.

Pour pallier ces inconvénients, la version 2.7 introduit la possibilité d'associer à des échantillons des fichiers qui sont stockés dans une arborescence du serveur.

## Sécurité - limitations

Dès lors que l'on donne accès à des fichiers qui sont stockés dans une arborescence du serveur, un certain nombre de précautions sont prises pour limiter les risques qu'un utilisateur puisse obtenir des informations autres que celles auquel il a droit :

- pour une instance de Collec-Science, toutes les arborescences doivent être positionnées dans le même dossier de base ;
- une arborescence est décrite pour chaque collection. Deux collections peuvent se partager la même arborescence, mais une collection ne peut pas accéder à deux arborescences différentes ;
- depuis une arborescence de collection, les liens vers d'autres arborescences sont interdits ;
- seuls les utilisateurs qui disposent des droits d'accès à la collection peuvent télécharger les fichiers depuis le serveur.

## Paramétrage

### Paramétrage du serveur

L'ensemble de l'arborescence doit être accessible par le compte utilisé par le serveur web (*www-data* pour une implémentation *Apache2*). Il n'est pas nécessaire que le compte dispose d'un accès en écriture - c'est même fortement déconseillé.

Un dossier de base doit être créé dans le serveur, qui servira de racine à l'ensemble des arborescences décrites pour les collections. Le chemin complet doit être décrit dans le fichier *param/param.inc.php* :

    $APPLI_external_document_path = "/mnt/collec-science";

Par défaut, la variable est positionnée à */dev/null* pour empêcher son utilisation sans accord préalable de l'administrateur du serveur.

Les arborescences correspondant à chaque collection doivent commencer à partir de ce chemin. Il peut s'agir de montages vers d'autres serveurs de données, selon les protocoles adaptés à la situation locale.

### Paramétrage des collections

Pour activer le support des fichiers externes pour une collection, il faut modifier la fiche correspondante (*Paramétrage > Collections*, puis édition de la collection). Voici les informations à indiquer :

- "Le stockage de documents attachés aux échantillons est-il possible hors base de données ?" : coucher la case *oui*
- "Chemin d'accès aux fichiers externes" : indiquez le chemin relatif par rapport à la racine de stockage (variable *$APPLI_external_document_path*).

Dès lors, il sera possible de parcourir l'arborescence depuis un échantillon pour référencer un document.

## Pour référencer un ou plusieurs documents

Depuis l'écran de visualisation des échantillons, onglet *Documents associés* :

- sous le tableau, dans la section *Fichiers externes à associer avec l'échantillon*, cliquez sur la racine de l'arborescence :
    - la liste des fichiers et sous-dossiers présents est affichée
    - vous pouvez cliquer sur un sous-dossier pour parcourir cette branche de l'arborescence
- sélectionnez le ou les fichiers que vous voulez associer
- renseignez les zones *Description* et *Date de création des documents* si vous le souhaitez. Attention : ces deux informations seront valables pour tous les documents sélectionnés ensemble
- en bas d'arborescence, cliquez sur le bouton *Associer les fichiers sélectionnés*.

Si vous souhaitez modifier une description ou une date pour un document, il suffit de refaire la même opération, l'enregistrement pré-existant sera mis à jour.

## Que faire si l'arborescence d'une collection est déplacée ?

Il suffit simplement de recréer les montages et de modifier les paramètres de la collection dans l'application, si nécessaire.

Rédaction : Éric Quinton - 30/03/2022

