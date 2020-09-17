#!/bin/bash

source scripts/config.sh

sigles=data/sigles.csv

if [[ "$1" ]]
then
  message="$1"
  api="https://www.data.gouv.fr/api/1"

  # Pour l'instant l'app ne gère pas les colonnes supplémentaires
  cp $sigles ${sigles}.ori
  xsv select "term,definition,source,url_source" $sigles > temp.csv
  mv temp.csv $sigles

  curl -sL "$api/datasets/5ee0d624d915e528468166c6/resources/${resource_sigle_id}/upload/" -F "file=@$sigles" -H "X-API-KEY: $datagouvfr_API_key" > response.json


  jq .success response.json

  url=`jq -r .url response.json`
  jq --arg url "$url" '.config.resourceUrl |= $url' package.json > temp
  mv temp package.json
  git add package.json

  rm -f response.json

  mv $sigles.ori $sigles
  git add $sigles
  git commit -m "$message"

fi

# Mise à jour de l'URL de la ressource et du nombre de sigles dans l'app
nb=`xsv count data/sigles.csv`
echo ""
echo "$nb sigles"

jq --arg nb $nb '.config.nbTerms |= ($nb|tonumber)' package.json > temp
mv temp package.json
git add package.json

# Ajout du nombre d'entrées dans le <title>
sed -i "s/[0-9]* entrées/$nb entrées/" public/index.html
git add public/index.html

git commit -m "Nombre d'entrées actualisé ($nb) mis à jour"

echo ""
echo "Publication complète, n'oublie pas de marquer les contributions comme publiées."

