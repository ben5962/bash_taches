#!/bin/bash - 
#===============================================================================
#
#          FILE:  lister_taches.sh
# 
#         USAGE:  ./lister_taches.sh 
# 
#   DESCRIPTION:  liste les taches en cours d'éxecution
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Dr. Fritz Mehner (fgm), mehner@fh-swf.de
#       COMPANY: FH Südwestfalen, Iserlohn
#       CREATED: 21/11/2011 10:44:06 CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# echo "${NOM_TACHE}:${EN_COURS}:${DEBUT}:${FIN}:${TOT_EN_COURS}:${TOT}" >> "${FICHIER_TACHES}"
. taches.conf
function liste_taches_en_cours(){
# si la tâche est en cours alors le champ en cours est à oui.
gawk -F: '$2  ~ /OUI/ {print $1;}' "${FICHIER_TACHES}"


}
liste_taches_en_cours
