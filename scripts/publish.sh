#!/bin/bash

source scripts/config.sh

if [[ $1 == "merge" ]]
then
    ./scripts/merge.sh
fi

git add data/sigles.csv
git commit -m "Update data"

api="https://www.data.gouv.fr/api/1"

# Pour l'instant l'app ne gère pas les colonnes supplémentaires
xsv select "term,definition,source,url_source" data/sigles.csv > temp.csv
mv temp.csv data/sigles.csv

curl -sL "$api/datasets/5ee0d624d915e528468166c6/resources/${resource_sigle_id}/upload/" -F "file=@data/sigles.csv" -H "X-API-KEY: $datagouvfr_API_key" > response.json

jq .success response.json

url=`jq -r .url response.json`

# Mise à jour de l'URL de la ressource et du nombre de sigles dans l'app
nb=`xsv count data/sigles.csv`
echo ""
echo "$nb sigles"

jq --arg url "$url" --arg nb $nb '.config.resourceUrl |= $url | .config.nbTerms |= ($nb|tonumber)' package.json > temp
mv temp package.json



git add package.json
git commit -m "New resource URL"

echo ""
echo "Publication complète, n'oublie pas de marquer les contributions comme publiées."

rm response.json
