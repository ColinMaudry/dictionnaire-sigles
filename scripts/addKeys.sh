#!/bin/bash

source scripts/config.sh

file=$1
line=0

if [[ ! `head -n 1 $file` == $headers ]]
then
    echo "Les en-têtes du fichier traité doivent être :"
    echo $headers
    exit 1
fi

xsv select "id,term,definition" $file | tail -n +2 > temp.csv

echo "id,key" > withKeys.csv

while IFS=, read -r id term definition
do
    key=`echo ${term}${definition} |
    # Minuscule
        sed -e 's/\(.*\)/\L\1/' |
    # Suppression des espaces et de la ponctuation
        tr -d "[:punct:][:space:]’"

    `
    echo ${id},${key} >> withKeys.csv

done < temp.csv

xsv join id $file id withKeys.csv | \
xsv select $headers,key

rm temp.csv withKeys.csv
