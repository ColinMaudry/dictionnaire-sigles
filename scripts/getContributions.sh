#!/bin/bash

source ./scripts/config.sh

newFile=$1

rm data/contribution*

echo "Téléchargement des contributions (Google sheet)..."
echo ""

echo "$headersDev" > data/contributions.csv
curl -sL $contributionsUrl \
 | tail -n +2 \
 | xsv search -s "Statut sigle"  "Vérifié|Publié" \
 | xsv select id,Sigle,"Forme complète","Source","URL source sigle",Explication,"Source explication","URL source explication","Statut sigle","Statut explication" \
 | tail -n +2 >> data/contributions.csv

echo "Filtre des sigles avec explication vérifiée..."

xsv search -s "explanation_status" "Vérifié|Publié" data/contributions.csv | \
xsv select $headers > data/contributionsVerifiees.csv

echo "Filtre des sigles sans explication..."

echo $headersDev > data/contributionsTemp.csv

# Sigles sans explication
grep -e ",$" data/contributions.csv >> data/contributionsTemp.csv

# Sigles dont l'explication n'a pas été vérifiée
xsv search -s "explanation_status" "À vérifier" data/contributions.csv | \
xsv select "!explanation" | \
xsv select "!source_explanation" | \
xsv select "!url_source_explanation" | \
tail -n +2 >> data/contributionsTemp.csv

xsv fixlengths data/contributionsTemp.csv |
xsv select $headers | \
tail -n +2 >> data/contributionsVerifiees.csv

rm data/contributionsTemp.csv
