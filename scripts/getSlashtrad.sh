#!/bin/bash

source scripts/config.sh

echo "Téléchargement du document slashtrad..."
curl -sL $slashtradUrl | \
xsv search -s "Relu" "OK|MODIFIE" | \
xsv sort -s "term" | \
xsv select "$headers" \
> data/slashtrad.csv
