#!/usr/bin/env bash
source scripts/config.sh

file=$1
source=$2
urlSource=$3
head=`head -n 1 $file`

headers="id,term,definition,explanation"

if [[ ! $head == $headers ]]
then
    echo "Les en-têtes doivent être $headers."
    exit 1
fi

xsv search --select explanation ".+" $file | xsv select term,definition,explanation > $file.temp
xsv search --select explanation "^\$" $sigles | xsv select key > dicNoExplanation.csv

source scripts/makeKey.sh

while IFS=, read -r term definition explanation
do
    echo $term
    key2=`makeKey "$term" "$definition"`
    for key in `cat dicNoExplanation.csv`
    do
        if [[ "$key2" == "$key" ]]
        then
            echo "$term"
            echo "$term,`csv "$explanation"`,$source,$urlSource" >> $file.expl.csv
            ((newExplanations++))
        fi
    done < dicNoExplanation.csv

done < $file.temp

echo "$newExplanations nouvelles explications."
rm $file.temp dicNoExplanation.csv
