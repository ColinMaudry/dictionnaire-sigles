#!/bin/bash

file=$1

makeKey() {
    echo "${1}${2}" |
    # Minuscule
        sed -e 's/\(.*\)/\L\1/' |
    # Suppression des espaces et de la ponctuation
        tr -d "[:punct:][:space:]’"
}

headers="id,term,definition,explanation"

if [[ ! `head -n 1 $file` == $headers ]]
then
    echo "Les en-têtes doivent être $headers.
Seuls term et definition doivent être remplis."
    exit 1
fi

xsv select "term,definition" data/sigles.csv | tail -n +2 > temp.csv

while IFS=, read -r term definition
do
    key=`makeKey "$term" "$definition"`
    echo ${key} >> dicKeys.csv
done < temp.csv
rm -f temp.csv
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
                echo "$term         $definition"
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
