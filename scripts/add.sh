#/bin/bash

newFile=$1
dict=./data/sigles.csv
newDict=./data/newSigles.csv
contributionsUrl=https://docs.google.com/spreadsheets/d/1kEJzE-8nCBZakKWptfrc5HhuctOEnMYy8AgxGz6dNW4/export\?format\=csv\&id\=1kEJzE-8nCBZakKWptfrc5HhuctOEnMYy8AgxGz6dNW4\&gid\=0

# echo "Getting contributions..."
# echo ""

echo "term,definition,source,url_source,explanation,source_explanation,url_source_explanation,explanation_status" > data/contributions.csv
curl -sL $contributionsUrl \
 | tail -n +2 \
 | xsv search -s "Statut sigle"  "OK" \
 | xsv select Sigle,"Forme complète","Source","URL source sigle",Explication,"Source explication","URL source explication","Statut explication" \
 | tail -n +2 >> data/contributions.csv

xsv search -s "explanation_status" "OK" data/contributions.csv | xsv select term,definition,source,url_source,explanation,source_explanation,url_source_explanation > data/contributionsSiglesExplications.csv

head -n 1 data/contributions.csv > data/contributionsSigles.csv
grep -e ",$" data/contributions.csv >> data/contributionsSigles.csv
xsv select term,definition,source,url_source,explanation,source_explanation,url_source_explanation data/contributionsSigles.csv > temp.csv
mv temp.csv data/contributionsSigles.csv

head -n 2 data/contributions.csv

echo ""

head -n 2 data/contributionsSiglesExplications.csv

echo ""

head -n 2 data/contributionsSigles.csv


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
