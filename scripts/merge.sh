#!/bin/bash

source scripts/config.sh

contributions="data/contributionsVerifiees.csv"
slashtrad="data/slashtrad.csv"

python scripts/merge.py
