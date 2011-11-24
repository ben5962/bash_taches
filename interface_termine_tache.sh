#!/bin/bash - 
#===============================================================================
#
#          FILE:  interface_termine_tache.sh
# 
#         USAGE:  ./interface_termine_tache.sh 
# 
#   DESCRIPTION:  interface à termine tache. permet de tester termine tache sans effet de bord.
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Dr. Fritz Mehner (fgm), mehner@fh-swf.de
#       COMPANY: FH Südwestfalen, Iserlohn
#       CREATED: 22/11/2011 11:20:24 CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error


function interface_a_arrete_tache(){
. taches.conf
. termine_tache.sh
# arrêter une tâche?
# 1) mettre EN_COURS à NON.
# 2) mettre FIN à date +%s
# 3) mettre TOT à FIN-DEBUT ou
# 3bis) ajouter FIN-DEBUT à TOT 

echo "nom tâche à arrêter?"
read NOM_TACHE
EN_COURS="NON"
FIN="$(date +%s)"
TMP=$$
arrete_tache <$FICHIER_TACHES > $$
mv $$ $FICHIER_TACHES
}
interface_a_arrete_tache
