#!/bin/bash

contributions=data/contributionsVerifiees.csv
slashtrad=data/slashtrad.csv
sigles=data/sigles.csv

./scripts/getContributions.sh &
./scripts/getSlashtrad.sh

echo ""
git checkout -- $sigles &> /dev/null
nb=`xsv count $sigles`
echo "$nb sigles avant le merge"
echo "++++++++++++++"
echo ""

if [[ `head -n 1 $slashtrad` == `head -n 1 $contributions` ]]
then
    cp $slashtrad $sigles
    tail -n +2 $contributions >> $sigles

    # Tri par sigle
    xsv sort -s "term" $sigles > $sigles.temp
    mv $sigles.temp $sigles

    for file in `ls data/*.csv`
    do
        nb=`xsv count $file`
        echo "$nb sigles dans $file"
    done
    echo ""
    echo "++++++++++++++"
    nb=`xsv count $sigles`
    echo "$nb sigles après le merge"
else
    echo "Les en-têtes de $slashtrad et $contributions ne correspondent pas."
    exit 1
fi
