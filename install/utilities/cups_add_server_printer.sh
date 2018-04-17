#!/bin/bash
# printer sharing for collec-science
# command to execute at root

# enable printer sharing
cupsctl --share-printers

# allow any to connect to cups (on otherside, only local subnet)
cupsctl --share-printers --remote-any

# add printer collec and share it
lpadmin -p collec -E -v usb:/dev/usb1 -o printer-is-shared=true -m fichier.ppd


