#!/bin/bash

source ./scripts/config.sh

newFile=$1
dict=./data/sigles.csv
newDict=./data/newSigles.csv

rm data/contribution*

echo "Téléchargement des contributions (Google sheet)..."
echo ""

echo "$headersDev" > data/contributions.csv
curl -sL $contributionsUrl \
 | tail -n +2 \
 | xsv search -s "Statut sigle"  "Vérifié" \
 | xsv select Sigle,"Forme complète","Source","URL source sigle",Explication,"Source explication","URL source explication","Statut sigle","Statut explication" \
 | tail -n +2 >> data/contributions.csv

echo "Filtre des sigles avec explication vérifiée..."

xsv search -s "explanation_status" "Vérifié" data/contributions.csv | \
xsv select $headers > data/contributionsVerifiees.csv

echo "Filtre des sigles sans explication..."

echo $headersDev > data/contributionsTemp.csv

grep -e ",$" data/contributions.csv >> data/contributionsTemp.csv

xsv select $headers data/contributionsTemp.csv | \
tail -n +2 >> data/contributionsVerifiees.csv

# echo "term,definition,source,url_source,key" > $newDict
#
# while IFS=, read -r term definition,source,url_source,key
# do
#   if [[ ! $term == "term" ]]
#   then
#
#     # Removing punctuation
#     hash=`echo $definition | tr -d "[:punct:][:space:]"`
#
#     # Normalizing accentuation
#     hash=`echo $hash | tr `
#     newkey=
#   fi
# done < $dict
