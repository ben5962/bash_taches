#!/bin/bash - 
#===============================================================================
#
#          FILE:  termine_tache.sh
# 
#         USAGE:  ./termine_tache.sh 
# 
#   DESCRIPTION:  arrete une tache
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Dr. Fritz Mehner (fgm), mehner@fh-swf.de
#       COMPANY: FH Südwestfalen, Iserlohn
#       CREATED: 21/11/2011 11:04:30 CET
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error
# commenté pour shunit2

# echo "${NOM_TACHE}:${EN_COURS}:${DEBUT}:${FIN}:${TOT_EN_COURS}:${TOT}" >> "${FICHIER_TACHES}"

function arrete_tache(){
# arrêter une tâche?
# 1) mettre EN_COURS à NON.
# 2) mettre FIN à date +%s
# 3) mettre TOT à FIN-DEBUT ou
# 3bis) ajouter FIN-DEBUT à TOT 
# 3 et 3bis seront faits dans une autre fonction
gawk -F':' -v g_nomtache="${NOM_TACHE}" -v g_fin="${FIN}" -v g_en_cours="${EN_COURS}" 'BEGIN { OFS=":";} $1==g_nomtache {
			# rien à faire sur $1
			# 1) mettre EN_COURS à NON 
			sub(/OUI/, g_en_cours, $2);
			# rien à faire sur date_debut donc pas touche $3
			# on doit passer $4 à date de fin
			sub($4, g_fin, $4);
			# on doit passer duree à la difference des deux
			sub($5, $4 - $3, $5);
			# s il s agit du premier lancement ($6 vaut PREMIER_LANCEMENT)
			# le cumul $6 vaut la différence calculée dans le champ préc.
			#
			# sinon le champ de cumul $6 vaut lui même 
			# auquel on ajoute  la différence calculée précéd. ds chp 5.
			sub(/[0-9]+/, $6 + $4 - $3, $6)	
			sub(/PREMIER_LANCEMENT/, $4 - $3, $6)		
			print $0;
		}
		$1!=g_nomtache { 
		print $0;
		}' 
	#"${FICHIER_TACHES}" 

}

