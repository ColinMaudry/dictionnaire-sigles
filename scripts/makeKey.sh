#!/bin/bash

makeKey() {
    echo "${1}${2}" |
    # Minuscule
        sed -e 's/\(.*\)/\L\1/' |
    # Suppression des espaces et de la ponctuation
        tr -d "[:punct:][:space:]’"
}
