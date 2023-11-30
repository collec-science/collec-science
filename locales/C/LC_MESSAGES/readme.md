# Utilisation du module de traduction

Les libellés à traduire sont assemblés dans le fichier `en.po` avec l'outil *itstool*. Deux traductions sont proposées actuellement : en anglais et en américain. Une fois les traductions réalisées, deux fichiers seront générés : `en.mo` et `us.mo`, ce dernier après avoir recopié les traductions depuis `en.po` en `us.po`, puis les avoir également adaptées. La compilation est réalisée avec l'outil *msgfmt*.

## Mode opératoire

1. récupérez les libellés à traduire à partir des fichiers php, des templates Smarty et du fichier xml décrivant les menus, avec le script `generate_po.sh`
2. traduisez les traductions avec la commande `poedit en.po`
3. lancez la traduction spécifiquement pour l'américain avec le script `add_us_translation.sh` (corrigez notamment la date de la version)
4. compilez les traductions réalisées avec le script `compile.sh`
