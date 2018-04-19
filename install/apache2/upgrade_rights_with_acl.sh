#!/bin/bash
# program setting rights in collec-science with acl management
# must be run as upgrade_rights_with_acl.sh folder
if [ -d $1 ]
then
mkdir $1/display/templates_c
find $1 -type d -exec chmod 770 {} \;
find $1 -type f -exec chmod 660 {} \;
setfacl -R -m u:www-data:rwx $1/display/templates_c
setfacl -R -m d:u:www-data:rwx $1/display/templates_c
setfacl -R -m u:www-data:rwx $1/temp
setfacl -R -m d:u:www-data:rwx $1/temp
setfacl -R -m d:o::- .
rm -f clear_templates_c.sh
fi