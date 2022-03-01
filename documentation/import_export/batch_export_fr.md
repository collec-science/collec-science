## Export par lot

### Introduction

Afin de pouvoir faire un export par lot, vous aller avoir besoin de configurer :

  * Un lot d'objets : liste des objets qui vont être exportés
  * Un modèle de dataset : listes des données d'un objet à exporter
  * Un modèle d'export : options d'export (nom de fichier, modèle de dataset à utiliser)

### Création d'un lot pour l'export

Aller dans "Objets" -> "Échantillons" :
 
  * Selectionnez la collection (obligatoire pour pouvoir créer le lot)
  * Définissez les filtres qui vous interressent (exemple: type d'échantillon, status, ...)
  * Effectuez la recherche en cliquant sur "Rechercher"
  * Selectionnez les objets puis, pour les élements selectionnés : "Créer un lot d'export"

La liste des échantillons, une fois créée, n'est plus modifiable.

### Création d'un modele de dataset

Allez dans "Impots/Exports", "Modèles de dataset" puis "Nouveau"...

  * Nom : ce nom sera affiché dans le modele d'export
  * Type : sample, collection... (défini les champs exportables)
  * Format d'export : CSV, JSON, XML (de preference JSON ;)
  * Nom du fichier qui sera dans le zip s'il y a plusieurs fichiers ou si vous demandé qu'il soit compressé
  * Le reste est utilisé pour personnalisé le XML ou le CSV

Quand vous avez fini, cliquez sur "Valider".

Une fois créé on peut spécifier les colonnes avec "Nouvelle colonne" :

  * Selectionnez le champ que vous souhaitez ajouter
  * Definissez le nom du champ dans l'export
  * Vous pouvez spécifier si ce champ est obligatoire pour l'export et si vous voulez une valeur par default s'il n'est pas renseigner
  * Vous pouvez également spécifier le formatage de date

Dans le cas des metadata, il faut également spécifier le nom de la metadonnée Sinon, le resultat sera vide. On ne peut pas exporter l'ensemble des metadonnée d'un coup.

### Création d'un modele d'export

Aller dans "Impots/Exports", "Modèles de dataset" puis "Nouveau"...

  * Nom
  * Description
  * Version
  * Fichier compressé
  * Nom du fichier généré
  * Selectionnez le modèle de dataset

### Lancer un export

Allez dans "Imports/Exports" puis "Lots d'export" :

  * Selectionnez un lot
  * Nouvel export
  * Sélectionnez le modèle d'export
  * Cliquez sur "Générer l'export"