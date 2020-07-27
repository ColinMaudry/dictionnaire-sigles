#!/bin/bash

file=$1

makeKey() {
    echo "${1}${2}" |
    # Minuscule
        sed -e 's/\(.*\)/\L\1/' |
    # Suppression des espaces et de la ponctuation
        tr -d "[:punct:][:space:]’"
}

if [[ ! `head -n 1 $file` == "term,definition" ]]
then
    echo "Les en-têtes doivent être term,definition"
    exit 1
fi

xsv select "term,definition" data/sigles.csv | tail -n +2 > temp.csv

echo "term,definition,key" > withKeys.csv

while IFS=, read -r term definition
do
    key=`makeKey "$term" "$definition"`
    echo ${term},${definition},${key} >> withKeys.csv
done < temp.csv

rm -f temp.csv $file.keys.csv

while IFS=, read -r term definition
do
    if [[ ! $definition == "definition" ]]
    then
        key=`makeKey "$term" "$definition"`
        search=`xsv search -s key "^$key\$" withKeys.csv | wc -l`

        if [[ $search -lt 2 ]]
        then
            echo ${term},${definition} >> $file.keys.csv
        fi
    fi
done < $file

rm withKeys.csv
