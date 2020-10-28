#!/bin/bash
file="$1"

source scripts/makeKey.sh

head=`head -n 1 $file`

echo "Création des clés (hashes) des entrées de $file dans dicKeys.csv..."
echo "id,key" > dicKeys.csv

while IFS=, read -r `echo $head | sed 's/,/ /g'`
do
    key=`makeKey "$term" "$definition"`
    echo $id,${key} >> dicKeys.csv
done < $file

echo "Jointure de $file et dicKeys.csv pour ajouter la colonne keys..."
xsv join id $file id dicKeys.csv | xsv select "$head,key" > temp

if [[ `cat temp | wc -l` -gt 1 ]]
then
    mv temp $file
fi

rm dicKeys.csv
