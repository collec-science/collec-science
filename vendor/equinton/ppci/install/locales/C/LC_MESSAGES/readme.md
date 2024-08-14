# Utilisation du module de traduction

Les libellés à traduire sont assemblés dans le fichier `en.po` avec l'outil _itstool_. Une traduction est proposée actuellement : en anglais. Une fois les traductions réalisées, un fichier sera généré : `en.mo`. La compilation est réalisée avec l'outil _msgfmt_.

## Mode opératoire

1.  récupérez les libellés à traduire à partir des fichiers php, des templates Smarty et du fichier xml décrivant les menus, avec le script `generate_po.sh`
2.  traduisez les traductions avec la commande `poedit en.po`
3.  compilez les traductions réalisées avec le script `compile.sh`
