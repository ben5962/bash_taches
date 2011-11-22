#!/bin/bash - 
#===============================================================================
#
#          FILE:  ajoute_tache.sh
# 
#         USAGE:  ./ajoute_tache.sh 
# 
#   DESCRIPTION:  ajoute une tâche
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Dr. Fritz Mehner (fgm), mehner@fh-swf.de
#       COMPANY: FH Südwestfalen, Iserlohn
#       CREATED: 21/11/2011 10:37:05 CET
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# format:
# NOM_TACHE:EN_COURS(OUI/NON):DEBUT:FIN:TOTAL
# ajouter les variables locales
. taches.conf
#TODO: vérifier que le FICHIER_TACHES existe

function ajoute_tache(){
echo "${NOM_TACHE}:${EN_COURS}:${DEBUT}:${FIN}:${TOT_EN_COURS}:${TOT}" >> "${FICHIER_TACHES}"
}

function interface(){
echo "nom nouvelle tache?"
read NOM_TACHE
EN_COURS="OUI"
DEBUT="$(date +%s)"
FIN="EN_COURS"
TOT_EN_COURS="GENERE_SUR_DEMANDE"
TOT="PREMIER_LANCEMENT"
ajoute_tache
}

interface
