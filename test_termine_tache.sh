#!/bin/bash - 
#===============================================================================
#
#          FILE:  test_termine_tache.sh
# 
#         USAGE:  ./test_termine_tache.sh 
# 
#   DESCRIPTION:  termine tache doit cloturer un certain nombre d'écritures et modifier le résultat de l'affichage de liste_taches
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Dr. Fritz Mehner (fgm), mehner@fh-swf.de
#       COMPANY: FH Südwestfalen, Iserlohn
#       CREATED: 22/11/2011 08:11:53 CET
#      REVISION:  ---
#===============================================================================

set +o nounset                              # Treat unset variables as an error
# ai du dégager le set -o nounset de termine_tache.sh pour pouvoir utiliser shunit2
. termine_tache.sh
:<< BLOC_COMMENTE
utiliser shunit2:

va lancer ttes les fonctions commencant par test

#testmachin(){
assertEquals ["message d'erreur"] 'valeur attendue' "valeur testée" 
}

. shunit2
va lancer Setup() > test() > tearDown()
pour chaque test puis faire un rapport
essayons.

il y aura aussi une fonction oneTimeSetup et du coup une fonction oneTimeTearDown
le test basique échoue avec un
shunit : line 9 ZSH_VERSION variable sans liaison. je vais devoir VIRER mon précieux set -o nounset !

la fonction testmachin est trouvée par shunit2 alors que dans bloc commenté!
BLOC_COMMENTE

# echo "${NOM_TACHE}:${EN_COURS}:${DEBUT}:${FIN}:${TOT_EN_COURS}:${TOT}" >> "${FICHIER_TACHES}"
function setUp(){
FICHIER_TACHES_SIMPLIFIE="essai.txt"
FICHIER_TACHES="autre_essai.txt"
AUTRE_FICHIER_TACHES_SIMPLIFIE="encore_un.txt"
FICHIER_TEST_DU_CUMUL_DERNIER_CHAMP="unptitdernier.txt"

cat <<OOO >"${FICHIER_TEST_DU_CUMUL_DERNIER_CHAMP}" 
essai:NON:1321869222:1321869223:1:1
OOO

cat <<VRAIEFIN >"${AUTRE_FICHIER_TACHES_SIMPLIFIE}"
autre essai:OUI:1321869831:EN_COURS:GENERE_SUR_DEMANDE:PREMIER_LANCEMENT
VRAIEFIN

cat <<FIN >"${FICHIER_TACHES_SIMPLIFIE}"
essai:OUI:1321869222:EN_COURS:GENERE_SUR_DEMANDE:PREMIER_LANCEMENT
FIN

cat <<FINDEFICHIER > "${FICHIER_TACHES}"
essai:OUI:1321869222:EN_COURS:GENERE_SUR_DEMANDE:PREMIER_LANCEMENT
autre essai:OUI:1321869831:EN_COURS:GENERE_SUR_DEMANDE:PREMIER_LANCEMENT
FINDEFICHIER

}

function tearDown(){
rm -f $FICHIER_TACHES_SIMPLIFIE
rm -f $FICHIER_TACHES
rm -f $AUTRE_FICHIER_TACHES_SIMPLIFIE
rm -f $FICHIER_TEST_DU_CUMUL_DERNIER_CHAMP
}


test_recoprint_pattern(){
ATTENDU="essai:OUI:1321869222:EN_COURS:GENERE_SUR_DEMANDE:PREMIER_LANCEMENT"
assertEquals "1" "$(test -z "${FICHIER_TACHES}"; echo "$?")"  
TRAITEMENT="$(gawk -F':'  '$1=="essai" {print $0;};' ${FICHIER_TACHES})"
assertEquals "$ATTENDU" "$TRAITEMENT"
}


test_recoprint_pattern_param(){
ATTENDU="essai:OUI:1321869222:EN_COURS:GENERE_SUR_DEMANDE:PREMIER_LANCEMENT"
assertEquals "1" "$(test -z "${FICHIER_TACHES}"; echo "$?")"  
TRAITEMENT="$(gawk -F':'  -v g_essai="essai" '$1==g_essai {print $0;};' ${FICHIER_TACHES})"
assertEquals "$ATTENDU" "$TRAITEMENT"
}


test_recopattern_sub_print(){
ATTENDU="essai:NON:1321869222:EN_COURS:GENERE_SUR_DEMANDE:PREMIER_LANCEMENT"
assertEquals "1" "$(test -z "${FICHIER_TACHES}"; echo "$?")"  
TRAITEMENT="$(gawk -F':'  -v g_essai="essai" -v g_encours="NON" 'BEGIN {OFS=":";} $1==g_essai {sub(/OUI/, g_encours, $2); print $0;};' ${FICHIER_TACHES})"
assertEquals "$ATTENDU" "$TRAITEMENT"


}


test_arrete_tache(){
	# test avec fichier d'une seule ligne
ATTENDU="essai:NON:1321869222:1321869223:1:1"
# la variable fichier_taches doit exister dans l'env de test.
assertEquals "1" "$(test -z "${FICHIER_TACHES_SIMPLIFIE}"; echo "$?")"  
NOM_TACHE="essai"
FIN="1321869223"
#"$(date +%s)"
EN_COURS="NON"
TRAITEMENT="$(arrete_tache <${FICHIER_TACHES_SIMPLIFIE})"
assertEquals "$ATTENDU" "$TRAITEMENT"

# posera pb avec fichier de plusieurs lignes: n'affichera pas les lignes ne machant pas
# 
# devrait rendre la ligne telle quelle sans traitement: 
ATTENDU="autre essai:OUI:1321869831:EN_COURS:GENERE_SUR_DEMANDE:PREMIER_LANCEMENT"
# la variable fichier_taches doit exister dans l'env de test.
assertEquals "1" "$(test -z "${FICHIER_TACHES_SIMPLIFIE}"; echo "$?")"  
NOM_TACHE="essai"
FIN="1321869223"
#"$(date +%s)"
EN_COURS="NON"
TRAITEMENT="$(arrete_tache <${AUTRE_FICHIER_TACHES_SIMPLIFIE})"
assertEquals "$ATTENDU" "$TRAITEMENT"



# le pb du cumul des durees reste posé
# si premier lancement(le $5 vaut PREMIER_LANCEMENT), le cumul ($5) vaut la différence calculée 
ATTENDU="essai:NON:1321869222:1321869223:1:1"
# la variable fichier_taches doit exister dans l'env de test.
assertEquals "1" "$(test -z "${FICHIER_TACHES_SIMPLIFIE}"; echo "$?")"  
NOM_TACHE="essai"
FIN="1321869223"
#"$(date +%s)"
EN_COURS="NON"
TRAITEMENT="$(arrete_tache <${FICHIER_TACHES_SIMPLIFIE})"
assertEquals "$ATTENDU" "$TRAITEMENT"
#  ok. reste à propager les valeurs attendues
# FAIT

# si pas premier lancement (le $5 vaut pas PREMIER_LANCEMENT),
# le cumul ($5) doit valoir la somme entre lui-meme et le champ précédent.
ATTENDU="essai:NON:1321869222:1321869223:1:2"
# la variable fichier_taches doit exister dans l'env de test.
assertEquals "1" "$(test -z "${FICHIER_TEST_DU_CUMUL_DERNIER_CHAMP}"; echo "$?")"  
NOM_TACHE="essai"
FIN="1321869223"
#"$(date +%s)"
EN_COURS="NON"
TRAITEMENT="$(arrete_tache <${FICHIER_TEST_DU_CUMUL_DERNIER_CHAMP})"
assertEquals "$ATTENDU" "$TRAITEMENT"

}	
. shunit2
