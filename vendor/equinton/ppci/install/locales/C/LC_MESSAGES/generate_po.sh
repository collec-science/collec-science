mv en.po _old.po

#extrait les chaines {t}texte{/t} des templates smarty .tpl
../../../vendor/smarty-gettext/smarty-gettext/tsmarty2c.php -o _tpl.pot ../../..

#extrait les chaines _("Module gestion") du code php 
#pour laisser une note au traducteur :
# précéder d'un commentaire en commençant par "traduction:", par exemple : "// traduction: conserver les chaînes comme _START_"
#--add-comments=MOT rajoute les commentaires qui commencent par MOT et précédent un texte à traduire
#--force-po créer un fichier .po même s'il est vide
#--from-code encodage des fichiers d'entrée par défaut les fichiers d'entrée sont supposés être en ASCII.
find ../../.. -type f -iname "*.php" | xgettext --files-from=- --add-comments=traduction: --force-po --from-code=UTF-8 -o _php.pot

#extrait les chaines à traduire des .xml avec itstool
#vérifie que l'outil itstool est bien présent
itstool -v >/dev/null 2>&1 || { echo >&2 "Erreur : itstool doit être installé. Installez itstool et recommencez : sudo apt install itstool";} ## exit 1;
#les régles ITS sont dans le fichier xml même : https://www.w3.org/TR/its20/
#pour extraire les attributs label="text" tooltip="text" de menu.xml :
#<its:rules version="2.0">
#	<its:translateRule selector="//item/@label" translate="yes"/>
#	<its:translateRule selector="//item/@tooltip" translate="yes"/> 
#</its:rules>
itstool ../../../app/Config/menu.xml -o _xml.pot 

#agrége les fichiers .pot (provenant des templates smarty et du code php)
msgcat _xml.pot _php.pot _tpl.pot -o _todo.pot

#fusionne l'ancienne traduction avec les nouvelles chaînes à traduire
#--sort-by-file          trier les données de sortie selon l'emplacement des fichiers
msgmerge _old.po _todo.pot -o en.po

#supprime les fichiers temporaires
rm _xml.pot _tpl.pot _php.pot _todo.pot # _old.po

# lance l'outil de traduction
poedit en.po

