#!/bin/bash

source scripts/config.sh

if [[ $1 == "merge" ]]
then
    ./scripts/merge.sh
fi

git add data/sigles.csv
git commit -m "Update data"
git push

api="https://www.data.gouv.fr/api/1"

curl -sL "$api/datasets/5ee0d624d915e528468166c6/resources/${resource_sigle_id}/upload/" -F "file=@data/sigles.csv" -H "X-API-KEY: $datagouvfr_API_key" > response.json

echo ""

jq .success response.json

url=`jq -r .url response.json`

# Mise à jour de l'URL de la ressource dans l'app
jq --arg url "$url" '.config.resourceUrl |= $url' package.json > temp
mv temp package.json

echo ""
echo "Publication complète, n'oublie pas de marquer les contributions comme publiées."

rm response.json
