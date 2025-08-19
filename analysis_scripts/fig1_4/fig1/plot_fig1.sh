#!/bin/bash

REPRO_DIR=/code/reproduction

###########
## Get Data
###########
mkdir -p ./data

#mirage, sass, scatter, ceaser (rco)
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh /code/aes/analysis/mirage/key1 /code/aes/analysis/mirage/key2 > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data/ge_mirage_rco.csv
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh /code/aes/analysis/sass/key1 /code/aes/analysis/sass/key2 > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data/ge_sass_rco.csv
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh /code/aes/analysis/scatter/key1 /code/aes/analysis/scatter/key2 > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data/ge_scatter_rco.csv
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh /code/aes/analysis/ceaser/key1 /code/aes/analysis/ceaser/key2 > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data/ge_ceasers_rco.csv

# mirage (reproduction)
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh $REPRO_DIR/repro_results/L1512B.SeedFixed/profiled $REPRO_DIR/repro_results/L1512B.SeedFixed/victim > $REPRO_DIR/analysis_scripts/fig1_4/fig1/data/ge_mirage_repro.csv

###########
## Plot Fig 1
###########

python3 fig1.py
