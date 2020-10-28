#!/bin/bash

source scripts/makeKey.sh

file=$1

headers="id,term,definition,explanation"

if [[ ! `head -n 1 $file` == $headers ]]
then
    echo "Les en-têtes doivent être $headers.
Seuls term et definition doivent être remplis."
    exit 1
fi

xsv select key data/sigles.csv | tail -n +2 > dicKeys.csv

echo $headers > $file.unique.csv

duplicates=0

while IFS=, read -r id term definition explanation
do
    if [[ ! $definition == "definition" ]]
    then
        key=`makeKey "$term" "$definition"`
        for k in `cat dicKeys.csv`
        do
            if [[ $k == $key ]]
            then
                echo "$term                 $definition"
                ((duplicates++))
                break;
            else
                echo ${id},${term},${definition},${explanation} >> $file.unique.csv
            fi
        done
    fi
done < $file

echo "$duplicates doublons détectés et supprimés dans $file.unique.csv par rapport à $file."

rm dicKeys.csv
