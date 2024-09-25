#!/bin/bash
source scripts/config.sh
source scripts/functions.sh

fileori=$1
file=`newDelimiter $fileori`
echo $file
source=$2
sourceUrl=$3

headers="id${d}term${d}definition${d}explanation"

if [[ ! `head -n 1 $file` == $headers ]]
then
    echo "Les en-têtes doivent être $headers."
    head -n 1 $file
    exit 1
fi

xsv select key $sigles | tail -n +2 > dicKeys.csv

echo "id,term,definition,source,url_source,explanation,source_explanation,url_source_explanation" > $fileori.new.csv

duplicates=0

while IFS="$d" read -r id term definition explanation
do
    if [[ ! $definition == "definition" ]]
    then
        key=`makeKey "$term" "$definition"`
        isDuplicate=0
        for k in `cat dicKeys.csv`
        do
            if [[ $k == $key ]]
            then
                echo "$term                 $definition"
                isDuplicate=1
                ((duplicates++))
                break;
            fi
        done
        if [[ $isDuplicate == 0 ]]
        then
            if [[ $explanation == "" ]]
            then
                sourceExplanation=""
                sourceExplanationUrl=""
            else
                sourceExplanation=$source
                sourceExplanationUrl=$sourceUrl
            fi
            if [[ "$term" == "Agro Paris Tech - ENGREF" ]]
            then
                echo "$definition"
            fi
            echo "\"${id}\",\"${term}\",\"${definition}\",\"${source}\",\"${sourceUrl}\",\"${explanation}\",\"${sourceExplanation}\",\"${sourceExplanationUrl}\"" >> $fileori.new.csv
        fi
    fi
done < $file

echo "$duplicates doublons détectés et supprimés dans $fileori.new.csv par rapport à $fileori."

rm dicKeys.csv
rm $file
