#!/bin/bash
source scripts/config.sh
source scripts/makeKey.sh

file=$1
source=$2
sourceUrl=$3

headers="id,term,definition,explanation"

if [[ ! `head -n 1 $file` == $headers ]]
then
    echo "Les en-têtes doivent être $headers.
Seuls term et definition doivent être remplis."
    exit 1
fi

xsv select key $sigles | tail -n +2 > dicKeys.csv

echo "id,term,definition,source,url_source,explanation,source_explanation,url_source_explanation" > $file.new.csv

duplicates=0

while IFS=, read -r id term definition explanation
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
        if [[ $isDuplicate = 0 ]]
        then
            if [[ $explanation == "" ]]
            then
                sourceExplanation=""
                sourceExplanationUrl=""
            else
                sourceExplanation=$source
                sourceExplanationUrl=$sourceUrl
            fi
            echo "${id},${term},${definition},${source},${sourceUrl},${explanation},${sourceExplanation},${sourceExplanationUrl}" >> $file.new.csv
        fi
    fi
done < $file

echo "$duplicates doublons détectés et supprimés dans $file.unique.csv par rapport à $file."

rm dicKeys.csv
