#!/bin/bash

REPRO_DIR=/code/reproduction

###########
## Get Data
###########
mkdir -p ./data

echo "Data analysis for Figure 4"
#mirage (rco)
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh /code/aes/analysis/mirage/key1 /code/aes/analysis/mirage/key2 > $REPRO_DIR/analysis_scripts/fig1_4/fig4/data/ge_mirage_rco.csv

#mirage (reproduction) - three configurations (512B L1 Cache + Fixed Seed, 512B L1 Cache + Rand Seed, 64kB L1 Cache + Rand Seed) 
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh $REPRO_DIR/repro_results/L1512B.SeedFixed/profiled $REPRO_DIR/repro_results/L1512B.SeedFixed/victim > $REPRO_DIR/analysis_scripts/fig1_4/fig4/data/ge_mirage_repro_fixedseed_512B.csv
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh $REPRO_DIR/repro_results/L1512B.SeedRand/profiled $REPRO_DIR/repro_results/L1512B.SeedRand/victim > $REPRO_DIR/analysis_scripts/fig1_4/fig4/data/ge_mirage_repro_randseed_512B.csv
$REPRO_DIR/analysis_scripts/fig1_4/run_analysis.sh $REPRO_DIR/repro_results/L164kB.SeedRand/profiled $REPRO_DIR/repro_results/L164kB.SeedRand/victim > $REPRO_DIR/analysis_scripts/fig1_4/fig4/data/ge_mirage_repro_randseed_64kB.csv

###########
## Plot Fig 4
###########

echo "Plotting Figure 4"
python3 fig4.py
