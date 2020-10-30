#!/bin/bash

headers=id,term,definition,source,url_source,explanation,source_explanation,url_source_explanation
headersDev=$headers,term_status,explanation_status


contributionsUrl=https://docs.google.com/spreadsheets/d/1kEJzE-8nCBZakKWptfrc5HhuctOEnMYy8AgxGz6dNW4/export\?format\=csv\&id\=1kEJzE-8nCBZakKWptfrc5HhuctOEnMYy8AgxGz6dNW4\&gid\=0
slashtradUrl=https://docs.google.com/spreadsheets/d/1H6708p9IT9hfdDY1C02PX33ZmLyGPV8P_OYLrQre0vU/export\?format\=csv\&id\=1H6708p9IT9hfdDY1C02PX33ZmLyGPV8P_OYLrQre0vU\&gid\=676342226

resource_sigle_id=0fca6fc3-4919-458d-9c81-a2cf54a801ba

datagouvfr_API_key=

sigles=data/sigles.csv

# Délimiteur alternatif pour remplacer les virgules, sources d'erreur dans les traitements en bash
d="|"
