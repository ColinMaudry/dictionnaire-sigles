#!/bin/bash

source scripts/config.sh

makeKey() {
    echo "${1}${2}" |
    # Minuscule
        sed -e 's/\(.*\)/\L\1/' |
    # Suppression des espaces et de la ponctuation
        tr -d "[:punct:][:space:]’"
}

newDelimiter() {
    file="$1"
    xsv fmt -t "$d" $file > $file.newdelim
    echo $file.newdelim
}
